#!/bin/bash
# 03/11/2022

label=$1

workingPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
logPath="$workingPath/log.txt"

function logRecord {
	echo "$1" >> $logPath
}

echo $'\n\n\n' >> $logPath
logRecord ">>> >>> >>> >>> BEGIN SREAK FOR UPDATE HDPARM"
logRecord "    GIVEN LABEL: $label"
logRecord "    DATE: $(date)"
