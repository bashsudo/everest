#!/bin/bash

###########################################################
# Everest: a modular hdparm wrapper for power management
# Written by Eiza Stanford / "Charky Barky" / "Bash Sudo"
# core.sh: the primary script of the entire project
###########################################################

###########################################################
# Parameters (all are required, cannot be blank):
# $1 / 1st option: a personal memo / reason for the file execution (stored in the logfile)
# $2 / 2nd option: the serial number for the hard drive
# $3 / 3rd option: the value for the -S flag of hdparm (standby timeout); this cannot be skipped with "-1"
# $4 / 4th option: the value for the -B option of hdparm (APM); specify "-1" to skip this parameter
# $5 / 5th option: the value for the -M option of hdparm (AAM); specify "-1" to skip this parameter
###########################################################



###########################################################
# Parameters
###########################################################

label=$1
serial=$2
optionS=$3
optionB=$4
optionM=$5

###########################################################
# Important Variables
###########################################################

blockFile=""

workingPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
logPath="$workingPath/log.txt"

divider="-------------------------------------------"

###########################################################
# Logging Functions
###########################################################

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

###########################################################
# Serial Number to Device Block Function
###########################################################

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

###########################################################
# Important Step:
# immediately chcek to see if the serial number is valid; otherwise the program
# cannot continue
###########################################################

SerialToBlock


###########################################################
# hdparm Functions and Output Variable
###########################################################

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

###########################################################
# smartctl Functions and Output Variable
###########################################################

# Run Smartctl and Gather Basic Information Output
smartctlInfoOutput="$(/sbin/smartctl -a $blockFile 2>&1)"

function smartctlSearch {
	echo "$(echo "$smartctlInfoOutput" | grep "$1")"
}

###########################################################
# Gathering and Logging Information of Hard Drive:
# uses smartctlSearch to grep the smartctl -i output for
# important information and SMART details for the specified
# hard drive
###########################################################

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

###########################################################
# The "Main" Execution of the Script
###########################################################
logChunkHeader
logChunkEventDetails
logChunkSmartctl
hdparmExecute
logChunkHdparm
