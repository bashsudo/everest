#!/bin/bash

###########################################################
# Everest: a modular hdparm wrapper for power management
# Written by Eiza Stanford / "Charky Barky" / "Bash Sudo"
# template for "execute all" script
#
# meant to run multiple external scripts core.sh or run
# core.sh multiple times in one go
###########################################################

###########################################################
# Parameter and File Path:
# $1 / 1st option: a personal memo passed onto the calls to core.sh
###########################################################
workingPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
label=$1

###########################################################
# External Script Calling
###########################################################
$workingPath/hdparm-begin.sh "$label"
$workingPath/template-external_script.sh "$label"
# ...and you can write more external scripts for your hard drives...
# for example:
# $workingPath/hdd-seagate-750gb.sh "$label"
# $workingPath/hdd-seagate-2tb.sh "$label"
# $workingPath/hdd-western_digital_3tb.sh "$label"
