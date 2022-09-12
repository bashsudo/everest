#!/bin/bash

workingPath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
label=$1

$workingPath/hdparm-begin.sh "$label"
$workingPath/hdparm-hitachi.sh "$label"
$workingPath/hdparm-wdc_green.sh "$label"
$workingPath/hdparm-seagate_750gb.sh "$label"
$workingPath/hdparm-seagate_online_data.sh "$label"
$workingPath/hdparm-seagate_online_extra.sh "$label"
