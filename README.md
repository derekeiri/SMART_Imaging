# SMART_Imaging

Batch files that automates imaging and capaturing SMART information.

## Description

A small project to replicate a feature observed on the Atola Forensic Imager that compares SMART information before and after the imaging process. These batch files automate the following:
* Uses examiner specified details
* Capture the SMART information before imaging
* Initiate the imaging process
* Capture the SMART information again
* Compare the SMART information outputs, then saves an HTML report.

## Getting Started

The batch files are described below:
* *smart_imaging.bat*: The primary batch file. This is executed from a Command Prompt using Administrative Privileges. From the prompt, cd to the directory of the batch files then enter the following command:
```
start smart_imaging.bat
```
The batch command will guide the examiner data input: path to save SMART information, path and filename of the image, image format. Examiner name and descriptions are included in the image file created by X-Ways Forensics. Prompts will also determine which commands to use for smartctl.exe to access the drive with or without a USB adapter.
* *smart_imaging_config.bat*: A supporting batch file. This may be edited with a text editor to speicify the paths of the smartctl.exe, X-Ways Forensics, and WinMerge.


### Dependencies

I used a Windows 10 Pro OS, v10.0.19044 Build 19044. The following programs are used:
* smartctl.exe from v7.3 of [Smartmontools](https://www.smartmontools.org/)
* [X-Ways Forensics](https://www.x-ways.net/) v20.8
* [WinMerge](https://winmerge.org/) v2.16.30

The writeblocker tested with smartctl.exe is DeepSpar USB Stablizer (Firmware v.3.03a) using USB controller, Realtek RTL9210. ASMedia ASM2362 and JMicron JMS583 are included, but not tested.

Future additions expected to follow is supporting SAT ATA pass-through.
