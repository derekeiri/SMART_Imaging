@echo off
echo This script will print out the drives available to assess SMART information
echo before and after a forensic acquisition with X-Ways Forensics (tested with v20.8).
echo.
echo.
echo ###REQUIRES ADMINISTRATOR PRIVILEGES###
echo.
echo.
:savetopath
set /P smartpath="Enter file path to save SMART information to:    "
set smartpath=%smartpath:"=%
echo.
echo.
set smartpath_verify=
set /P smartpath_verify="###WARNING. THIS WILL OVERWRITE EXISTING REPORT FILES AT THIS LOCATION.### Confirm [Y/N]:    "
if /I "%smartpath_verify%" == "N" goto savetopath
if /I "%smartpath_verify%" == "Y" goto checksmartdir
if not defined "%smartpath_verify%" echo Please confirm.
goto savetopath

:checksmartdir
if exist "%smartpath%" goto xwfimageformat
if not exist "%smartpath%" echo ###Folder does not exist. Please try again.###
goto savetopath

:xwfimageformat
echo.
echo.
set /P xwf_format="Type an image format for XWF to use, 'e01' or 'raw':    "
set xwf_format=%xwf_format%

set /P xwf_format_verify="Confirm [Y/N]:    "
if /I "%xwf_format_verify%" == "Y" goto xwfsavetopath
if /I "%xwf_format_verify%" == "N" goto xwfimageformat
if not defined "%xwf_format_verify%" echo Please confirm.
goto xwfimageformat

:xwfsavetopath
echo.
echo.  
echo Please enter a path, including name of file, to save the acquired image to, 
set /P xwfimagepath="e.g. 'D:\XWF_DIR\IMAGES\my_image_name':    "
set xwfimagepath=%xwfimagepath:"=%

:xwfsavetopathverify
echo.
echo.
set /P xwfimagepath_verify="###WARNING. THIS WILL OVERWRITE EXISTING FILES OF THE SAME NAME.### Confirm [Y/N]:    "
if /I "%xwfimagepath_verify%" EQU "Y" goto checkxwffile
if /I "%xwfimagepath_verify%" EQU "N" goto xwfsavetopath
if not defined "%xwfimagepath_verify%" echo Please confirm.
goto xwfsavetopath

:checkxwffile
if not exist "%xwfimagepath%.%xwf_format%" goto xwf_image_description
if exist "%xwfimagepath%.%xwf_format%" echo ###An image file of that name and format already exists. Silly goose. Please try again.###
goto xwfsavetopath

:xwf_image_description
echo.
echo.
set /P xwf_image_desc="Enter an image description for XWF to use:    "
set xwf_image_desc=%xwf_image_desc%

set /P xwf_image_desc_verify="Confirm [Y/N]:    "
if /I "%xwf_image_desc_verify%" == "Y" goto xwf_image_examiner_name
if /I "%xwf_image_desc_verify%" == "N" goto xwf_image_description
if not defined "%xwf_image_desc_verify%" echo Please confirm.
goto xwf_image_description

:xwf_image_examiner_name
echo.
echo.
set /P xwf_examiner_name="Enter name of analyst:    "
set xwf_examiner_name=%xwf_examiner_name%

:xwf_image_examiner_name_verify
set /P xwf_examiner_name_verify="Confirm [Y/N]:    "
if /I "%xwf_examiner_name_verify%" == "Y" goto smart_drive_selection
if /I "%xwf_examiner_name_verify%" == "N" goto xwf_image_examiner_name
if not defined "%xwf_examiner_name_verify%" echo Please confirm.
goto xwf_image_examiner_name

:smart_drive_selection

call "%~dp0"smart_imaging_config.bat
rem Consider creating a batch file of variable of path to smartctl.exe
echo.
echo.
echo These are the drives available according to smartctl.exe.
cd "%smartmontools%" 
smartctl.exe --scan
echo.
echo.
echo Please enter a drive to report on SMART.

:drive_selection
echo If using a DeepSpar USB Controller, select the letter 
echo before the device reporting on the USB bridge:    "
set /P drive="Enter a drive. e.g. '/dev/sda'"   "

:drive_selection_verify
echo.
echo.
set /P drive_verify="You entered '%drive%'. Are you sure [Y/N]?:    "
if /I "%drive_verify%" == "Y" goto xwfdrive_help
if /I "%drive_verify%" == "N" goto drive_selection
if not defined "%drive_verify%" echo Please confirm.
goto drive_selection

:xwfdrive_help
echo.
echo.
echo list disk | diskpart
set /P drive_help="Would you like to know about these disks [Y/N]?:    "
if /I "%drive_help%" == "Y" goto xwfdrive_detaildisk
if /I "%drive_help%" == "N" goto xwfdrive_selection
if not defined "%drive_verify%" echo "Do you need help?"
goto xwfdrive_help

:xwfdrive_detaildisk
echo list disk | diskpart
set /P detaildisk="Enter the drive number you want to learn more about, e.g. 1.:    "
echo You typed %detaildisk%.
(echo list disk
echo select disk %detaildisk%
echo detail disk
)| diskpart

:drive_selection_verify
echo.
echo.
echo list disk | diskpart
set /P drive_more_help="Did you want to learn more about another drive [Y/N]?:    "
if /I "%drive_more_help%" == "Y" goto xwfdrive_detaildisk
if /I "%drive_more_help%" == "N" goto xwfdrive_selection
if not defined "%drive_more_help%" echo "Do you want more help?"
goto xwfdrive_selection

:xwfdrive_selection
set /P xwfdrive="Enter the drive number that corresponds with the Windows drive letter, e.g. 1.:    "
echo You typed %xwfdrive%.

:xwfdrive_selection_verify
set /P xwfdrive_verify="You entered '%xwfdrive%'. Are you sure [Y/N]?:    "
if /I "%xwfdrive_verify%" == "Y" goto bridgeexistence
if /I "%xwfdrive_verify%" == "N" goto xwfdrive_selection_verify
if not defined "%xwfdrive_verify%" echo Please confirm.
goto xwfdrive_selection_verify

:bridgeexistence
echo.
echo.
set /P bridge="Are you using a smartmontools supported USB bridge [Y/N]?:   "
if /I "%bridge%" == "Y" goto bridgedevice
if /I "%bridge%" == "N" goto nobridgedevice_before
if not defined "%bridge%" echo Please answer.
goto bridgeexistence

:bridgedevice
echo.
echo.
echo A selection of smartctl.exe supported USB bridges:
echo 1. Realtek RTL9210
echo 2. JMicron JMS583
echo 3. ASMedia ASM2362
echo 4. Other via SAT ATA pass-through
set devctrl=[]
set /P devctrl="Which bridge? Select a number:    "
if %devctrl%==1 goto RTL9210_before
if %devctrl%==2 goto JMS583_before
if %devctrl%==3 goto ASM2362_before
if %devctrl%==4 goto SAT_ATA_before
if %devctrl%==[] echo Please answer.
goto bridgedevice

:RTL9210_before
cd "%smartmontools%" 
smartctl.exe -a -d sntrealtek %drive% > "%smartpath%\smartbefore.txt"
goto XWF

:JMS583_before
cd "%smartmontools%" 
smartctl.exe -a -d sntjmicron %drive% > "%smartpath%\smartbefore.txt"
goto XWF

:ASM2362_before
cd "%smartmontools%" 
smartctl.exe -a -d sntasmedia %drive% > "%smartpath%\smartbefore.txt"
goto XWF

:SAT_ATA_before
cd "%smartmontools%" 
smartctl.exe -a -d sat,12 %drive% > "%smartpath%\smartbefore.txt"
goto XWF

:nobridgedevice_before
cd "%smartmontools%" 
smartctl.exe -a %drive% > "%smartpath%\smartbefore.txt"
goto XWF

:XWF
rem Consider creating a batch file of variable of path to xwforensics64.exe
echo X-Ways Forensics is ready to start.
Pause
START /W "" %xwf_path% :%xwfdrive% "|%xwf_format%|%xwfimagepath%%xwf_image_name%.%xwf_format%|%xwf_image_desc%|%xwf_examiner_name%" auto
ping -n 6 0.0.0.0 >nul
goto bridgedevice_after

:bridgedevice_after
if /I '%bridge%'=='N' goto nobridgedevice_after
if %devctrl%==1 goto RTL9210_after
if %devctrl%==2 goto JMS583_after
if %devctrl%==3 goto ASM2362_after
if %devctrl%==4 goto SAT_ATA_after

:RTL9210_after
cd "%smartmontools%" 
smartctl.exe -a -d sntrealtek %drive% > "%smartpath%\smartafter.txt"
goto smartcompare

:nobridgedevice_after
cd "%smartmontools%"
smartctl.exe -a %drive% > "%smartpath%\smartafter.txt"
goto smartcompare

:JMS583_after
cd "%smartmontools%" 
smartctl.exe -a -d sntjmicron %drive% > "%smartpath%\smartafter.txt"
goto smartcompare

:ASM2362_after
cd "%smartmontools%" 
smartctl.exe -a -d sntasmedia %drive% > "%smartpath%\smartafter.txt"
goto smartcompare

:SAT_ATA_after
cd "%smartmontools%" 
smartctl.exe -a -d sat,12 %drive% > "%smartpath%\smartafter.txt"
goto smartcompare

:smartcompare
rem Consider creating a batch file of variable of path to WinMergeU.exe
cd "%winmerge%" 
WinMergeU.exe "%smartpath%\smartbefore.txt" "%smartpath%\smartafter.txt" -or "%smartpath%\smart_check_text_report.html"
echo.
echo.
echo This script is finished. Have a nice day.
pause
exit
