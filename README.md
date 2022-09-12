# Everest: a wrapper for hdparm and smartctl

# What is the Program?
Everest is a wrapper of `hdparm` and `smartctl` that focuses on adjusting the Automatic Acoustic Management (AAM), Standby Timeout, and the Advanced Power Management (APM) parameters of hard drives.
The utility `hdparm` actually modifies the settings of hard drives, while `smartctl` is used for merely gathering the SMART information of the hard drives (without actually running SMART tests).

Some of Everest's main features include:
* A modular design that maximizes utility and minimizes stress for the user.
    * The main script `core.sh` performs all of the work in executing hdparm and smartctl and saving their output and other important information into a log file.
    * All the user has to do is call `core.sh` either in the shell, in another script, or in a cronjob.
* A highly readible log file.
    * Captures the STDOUT and STDERR from hdparm, aiding in troubleshooting and debugging hdparm options after running.
* References hard drives by their serial numbers, NOT by their Linux block devices.
    * Normally block devices for hard drives (e.g. `/dev/sdX`) are NOT permamently assigned; they change as devices are plugged in and unplugged.
    * Thus, one of the least ambiguous ways to reference a hard drive is to use its serial number.


AAM = -M
Standby = -S
APM = -B

# Motivation for the Program
* began on March 11, 2022
* Whenever I would run HDPARM on my hard drives on my file server, the power-related behavior of the hard drives would not change
    * my file server has multiple brands of hard drives and different models, strange
* in an effort to troubleshoot that issue, I wrote this system
* it evolved to become a modular, flexible model and implementation of BASH scripts that may inspire BASH projects I may have in the future

# Contents of this Repository
* core.sh
* begin.sh
* template for "execute all"
* template for "external script"

# Usage and Implementation:

## Simplest Usage
* having the system immediately use HDPARM to configure your hard drives, is as simple as running the "core.sh" script directly with these parameters:
    * 1st parameter: label          (required) a small memo or message to distinguish this invocation of core.sh from other invocations in the logs
    * 2nd parameter: serial         (required) the serial number of the hard drive
    * 3rd parameter: "option S"     (required) sets the Standby Timeout value in HDPARM (same as -S option), this cannot be ignored with -1
    * 4th parameter: "option B"     (required) sets the APM value in HDPARM, use "-1" to skip this parameter and do nothing in terms of APM
    * 5th parameter: "option M"     (required) sets the AAM value in HDPARM, use "-1" to skip this parameter and do nothing in terms of AAM

(INSERT IMAGE)

## Long-Term Implementation

### Running core.sh in another script file
* this is recommended if you are expecting to execute core.sh with specific parameters many times in the present and future
* also ideal for crontab
* use the provided template for writing scripts

(INSERT IMAGE)

### Writing an "execute all" script file
* if you have multiple hard drives that you want to use simultaneously with this system, then it is recommended
    * this is not much more than having a basic BASH script running core.sh multiple times (or the external user script files)

* use or modify the provided template
* things to note about the "execute all" script file (or running core.sh multiple times in one go):
    * before running core.sh (or other external scripts) within the script file, it is recommended to run the "begin"