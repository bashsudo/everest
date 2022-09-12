#!/bin/bash

###########################################################
# HDPARM Hard Drive 
#
###########################################################


# 03/11/2022

# NOTE: I was paranoid and specified absolute paths for most builtin Linux utilities (i.e. gawk), even though that would only be necessary for non-builtins like "smartctl" and "hdparm"

#	$1 = reason for file execution (can be literally anything, just a label for logging)
#	$2 = the name of the block file, /dev/sdX
#	$3 = the value for -S
#	$4 = the value for -B
#	$5 = the value for -M

# = = = = = =	PARAMETERS		= = = = = =
label=$1
serial=$2
optionS=$3
optionB=$4
optionM=$5

# = = = = = =	CRITICAL VARIABLES	= = = = = =
blockFile=""

workingPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
logPath="$workingPath/log.txt"

divider="-------------------------------------------"

# = = = = = =	CRITICAL LOG FUNCS	= = = = = =
function logNewLine {
	echo $'\n' >> $logPath
}

function logRecord {
	echo "$1" >> $logPath
}

function logChunkHeader {
	logNewLine
	logRecord ">>> >>> UPDATE HDPARM: SERIAL [$serial] AUTO-MATCHED BLOCK [$blockFile]"
}

function logChunkEventDetails {
	logRecord "EVENT DETAILS:"
	logRecord "    GIVEN LABEL: $label"
	logRecord "    DATE: $(date)"
}

# = = = = = =	SERIAL TO BLOCK		= = = = = =
function SerialToBlock {
	line="$(/bin/lsblk -o name,serial | grep $serial)"
	if [[ -n "$line" ]]; then #CONDITION: IF THE LINE IS NOT BLANK
		blockFilePartialName="$(echo "$line" | /bin/gawk 'match($0, /(sd[a-z])/, group) {print group[1]}')"
		blockFile="/dev/$blockFilePartialName"
	else
		logNewLine
		logRecord ">>> >>> UPDATE HDPARM: FATAL ERROR, GIVEN SERIAL $serial, BUT CANNOT FIND CORRESPONDING BLOCK FILE!"
		logChunkEventDetails
		exit 1
	fi
}

# >>> >>> >>> IMMEDIATELY CHECK TO SEE IF SERIAL IS VALID - OTHERWISE WHOLE PROGRAM CANNOT CONTINUE
SerialToBlock

# = = = = = =	HDPARM		= = = = = =
hdparmOutput=""

function hdparmExecute {
	optionFinalS="-S $optionS"
	optionFinalB=""
	optionFinalM=""

	if [[ "$optionB" == "-1" ]]; then
		logRecord "-B IS -1: AVOID -B OPTION"
	else
		optionFinalB="-B $optionB"
	fi

	if [[ "$optionM" == "-1" ]]; then
		logRecord "-M IS -1: AVOID -M OPTION"
	else
		optionFinalM="-M $optionM"
	fi

	logRecord "HDPARM PARAMETERS (RAW, GIVEN TO SCRIPT): -S $optionS -B $optionB -M $optionM"
	logRecord "HDPARM PARAMETERS (FINAL): $optionFinalS $optionFinalB $optionFinalM"
	hdparmOutput="$(/sbin/hdparm $optionFinalS $optionFinalB $optionFinalM $blockFile 2>&1)"
}

function logChunkHdparm {
	logRecord "HDPARM STDOUT AND STDERR:"
	logRecord "$divider"
	logRecord "$hdparmOutput"
	logRecord "$divider"
}

# = = = = = =	SMARTCTL	= = = = = =

smartctlInfoOutput="$(/sbin/smartctl -a $blockFile 2>&1)"

# WARNING, I AM NESTING DOUBLE QUOTES BELOW, THIS MAY OR MAY NOT BREAK UNDER SPECIFIC CONDITIONS!
# HOWEVER, SINCE SMARTCTL OUTPUT DOES NOT INVOLVE WEIRD CHARACTERS, I WILL KEEP THIS IMPLEMENTATION

function smartctlSearch {
	echo "$(echo "$smartctlInfoOutput" | grep "$1")"
}

driveFamily="$(smartctlSearch "Model Family:")"
driveModel="$(smartctlSearch "Device Model:")"
driveSerial="$(smartctlSearch "Serial Number:")"
driveReallocated="$(smartctlSearch "Reallocated_Sector_Ct")"
drivePowerOnHours="$(smartctlSearch "Power_On_Hours")"
driveStartStopCount="$(smartctlSearch "Start_Stop_Count")"
drivePowerCycleCount="$(smartctlSearch "Power_Cycle_Count")"
driveRetractCount="$(smartctlSearch "Power-Off_Retract_Count")"

function logChunkSmartctl {
	logRecord "SMARTCTL IDENTIFICATION FOR $blockFile:"
	logRecord "    $driveFamily"
	logRecord "    $driveModel"
	logRecord "    $driveSerial"
	logRecord "SMARTCTL ADDITIONAL INFO FOR $blockFile:"
	logRecord "    $driveReallocated"
	logRecord "    $drivePowerOnHours"
	logRecord "    $driveStartStopCount"
	logRecord "    $drivePowerCycleCount"
	logRecord "    $driveRetractCount"
}

# = = = = = =	RECORD LOGS	= = = = = =
logChunkHeader
logChunkEventDetails
logChunkSmartctl
hdparmExecute
logChunkHdparm
