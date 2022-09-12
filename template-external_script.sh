#!/bin/bash

###########################################################
# Everest: a modular hdparm wrapper for power management
# Written by Eiza Stanford / "Charky Barky" / "Bash Sudo"
# template for "external" script
#
# meant to serve as an example of what an "external" or
# uesr-written script would look like
###########################################################


# This might be a useful place to jot down notes about what hdparm
# values your hard drive may or may not support (this can be checked
# through hdparm)

# -M	acoustic			(unsupported)
# -B	advanced power management	= 255	= off
# -S	spindown timer			= 243	= 1.5 hours

###########################################################
# File Paths
###########################################################

workingPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
corePath="$workingPath/hdparm-core.sh"

###########################################################
# Actual Call to core.sh
# NOTE: this script takes one parameter: a memo / label that
# is passed into the label parameter of core.sh
###########################################################

$corePath "$1" "YOUR-SERIAL-GOES-HERE" "243" "255" "-1"
