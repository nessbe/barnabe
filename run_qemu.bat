:: File:        run_qemu.bat
:: Project:     sosos
:: Repository:  https://github.com/nessbe/sosos
::
:: Copyright (c) 2025 nessbe
:: Licensed under the Apache License, Version 2.0 (the "License");
:: you may not use this file except in compliance with the License.
:: You may obtain a copy of the License at:
::
::     https://www.apache.org/licenses/LICENSE-2.0
::
:: Unless required by applicable law or agreed to in writing, software
:: distributed under the License is distributed on an "AS IS" BASIS,
:: WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
:: See the License for the specific language governing permissions and
:: limitations under the License.
::
:: For more details, see the LICENSE file at the root of the project.

@echo off
setlocal enabledelayedexpansion

set "BINARY_FILE_EXTENSION=bin"

:: Check if QEMU is installed
where qemu-system-x86_64 >nul 2>&1

if %errorlevel% neq 0 (
	echo QEMU is not installed, or is not in the PATH.
	echo Please install it and put it in the PATH, or in this directory.
	pause
	exit /b 1
)

:: Default configuration
set "CONFIGURATION=debug"

:: Parse command line arguments
if "%1"=="" (
	echo No configuration specified, using debug.
) else (
	set "CONFIGURATION=%1"
	echo Configuration: %CONFIGURATION%.
)

set "OUTPUT_DIR=build"

if "%CONFIGURATION%"=="dist" (
	set "OUTPUT_DIR=dist"
)

if not exist "%OUTPUT_DIR%" (
	echo Output directory %OUTPUT_DIR% does not exist. Aborting...
	pause
	exit /b 1
)

set "DISKS="

for %%f in (%OUTPUT_DIR%\*.%BINARY_FILE_EXTENSION%) do (
	set "DISK=-drive file=%%f,format=raw,if=floppy"
	echo Found binary file: %%f
	echo Creating disk: !DISK!
	set "DISKS=!DISKS! !DISK!"
)

:: Run QEMU with the specified image
qemu-system-x86_64 !DISKS! -m 512 -boot a

if %errorlevel% neq 0 (
	echo QEMU failed to start. Please check the image file and your QEMU installation.
	exit /b 1
)

echo QEMU ran successfully.

pause
