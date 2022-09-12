#!/bin/bash

###########################################################
# Everest: a modular hdparm wrapper for power management
# Written by Eiza Stanford / "Charky Barky" / "Bash Sudo"
# preface.sh: logs a major header preceding multiple core.sh calls
###########################################################

###########################################################
# Parameters and File Path
###########################################################

label=$1
workingPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
logPath="$workingPath/log.txt"

###########################################################
# Logging Function
###########################################################

function logRecord {
	echo "$1" >> $logPath
}

###########################################################
# Actual Logging / Behavior of Program
###########################################################

echo $'\n\n\n' >> $logPath
logRecord ">>> >>> >>> >>> BEGIN SREAK FOR UPDATE HDPARM"
logRecord "    GIVEN LABEL: $label"
logRecord "    DATE: $(date)"
