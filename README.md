# Name
Everest

# What is the Program?
* A wrapper of HDPARM that focuses on adjusting the Automatic Acoustic Management (AAM), Standby Timeout, and the Advanced Power Management (APM) parameters of hard drives.
* Main features:
    * modular design (a few "central" scripts that interface with custom user scripts)
        * the centralized script (core.sh) provides many, many helper functions
        * yet, since the user writes external, individual scripts that communicate with the core.sh...
            * the external scripts are tiny (all helper functions in core.sh)
            * the external scripts can be called separately by crontab at different times
    * highly readible log file
        * many logging-related functions in the core.sh that simplify the process of logging and allow for more readibility
    * captures the stdout AND stderr from hdparm (ensuring that any hdparm errors are recorded and visible later)
    * hard drives are referred by their serial numbers, not arbitrary block devices
        * (built-in serial number to block device conversion)
        * normally the block devices for hard drives (e.g. /dev/sda) in linux are not permanently assigned; they may change over time as devices are plugged in and unplugged
        * one of the least ambiguous ways to refer to a specific hard drive is to use its serial number
* I did NOT write nor own HDPARM

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