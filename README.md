# SMART_Imaging

Batch files that automates imaging and capturing SMART information.

## Description

A small personal project to replicate a feature observed on the Atola Forensic Imager that compares SMART information before and after the imaging process. These batch files automate the following:
* Use examiner specified details
* Capture the SMART information and output results to a text file before imaging
* Initiate the imaging process
* Capture the SMART information and output results to a text file, again
* Compare the SMART information output, then save an HTML report.

Commands are based on [smartmontools wiki for USB devices](https://www.smartmontools.org/wiki/USB).
* ASMedia ASM2362 
* JMicron JMS583 
* Realtek RTL9210/1 
* various via SAT ATA pass-through 12

## Getting Started

In XWF, turn off the warning to not forget to take your dongle. The script will be interrupted if it pops up.

The batch files are described below:
* *smart_imaging.bat*: The primary batch file. This is executed from Command Prompt using administrator privileges. From the console window, change to the directory (cd) where the batch files are located. The batch file may be executed by entering the following command:
```
start smart_imaging.bat
```
It will prompt for the following information: path to save SMART information, path and filename of the image, image format. Examiner name and descriptions, also prompted by the script, are included in the image file created by X-Ways Forensics. Prompts will also determine which supported bridge is used, if at all, for smartctl.exe to report on the drive.
* *smart_imaging_config.bat*: A supporting batch file that is called in smart0imaging.bat. This may be edited with a text editor to specify the paths of the smartctl.exe, X-Ways Forensics, and WinMerge.


### Dependencies

I used a Windows 10 Pro OS, v10.0.19044 Build 19044. The script has commands to execute the following programs:
* smartctl.exe from v7.3 of [Smartmontools](https://www.smartmontools.org/)
* diskpart to list disks
* [X-Ways Forensics](https://www.x-ways.net/) v20.8
* [WinMerge](https://winmerge.org/) v2.16.30

The write blocker tested with smartctl.exe is DeepSpar USB Stablizer (Firmware v.3.03a) using USB/NVMe bridge, Realtek RTL9210, and an Inateck USB/SATA bridge that supports SAT ATA pass-through 12. ASMedia ASM2362 and JMicron JMS583 are included, but have not been tested.
