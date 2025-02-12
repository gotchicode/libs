@echo off
:: Set variables
setlocal enabledelayedexpansion
set OUTPUT_FOLDER=encoded_files
set LIST_FILE=file_list.txt
set LOG_FILE=processed_files.log

:: Create the output folder
if not exist "%OUTPUT_FOLDER%" (
    mkdir "%OUTPUT_FOLDER%"
    echo Created folder "%OUTPUT_FOLDER%"
) else (
    echo Folder "%OUTPUT_FOLDER%" already exists
)

:: Create or clear the log file
echo Processing log - %date% %time% > "%LOG_FILE%"
echo -------------------------------------- >> "%LOG_FILE%"

:: Create a list of avi files
echo Listing .avi files in the current folder...
dir /b *.avi > "%LIST_FILE%"

if not exist "%LIST_FILE%" (
    echo No .avi files found in the current folder.
    pause
    exit /b
)

:: Process each file in the list
echo Processing files with ffmpeg...
for /f "delims=" %%f in (%LIST_FILE%) do (
    set INPUT_FILE=%%f
    set OUTPUT_FILE=%OUTPUT_FOLDER%\%%~nf.mp4
    echo Processing: "!INPUT_FILE!" -> "!OUTPUT_FILE!"
    ffmpeg -y -i "!INPUT_FILE!" -c:v libx265 -b:v 2000k -c:a aac -b:a 128k "!OUTPUT_FILE!"

    :: Log the processed file
    if exist "!OUTPUT_FILE!" (
        echo Processed: "!INPUT_FILE!" -> "!OUTPUT_FILE!" >> "%LOG_FILE%"
    ) else (
        echo Failed to process: "!INPUT_FILE!" >> "%LOG_FILE%"
    )
)

:: Clean up the list file
del "%LIST_FILE%"
echo All files processed. Output is in the "%OUTPUT_FOLDER%" folder.
echo Log saved to "%LOG_FILE%"
pause
