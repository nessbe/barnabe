:: File:        build.bat
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

set "SOURCE_FILE_EXTENSION=asm"
set "BINARY_FILE_EXTENSION=bin"

set "SOURCE_DIR=source"
set "BUILD_DIR=build"
set "DIST_DIR=dist"

set "FINAL_BINARY_FILE=final.%BINARY_FILE_EXTENSION%"
set "FINAL_BINARY_PATH=%DIST_DIR%\%FINAL_BINARY_FILE%"

:: Check if NASM is installed (Assembler)
where nasm >nul 2>&1

if %errorlevel% neq 0 (
	echo NASM is not installed, or is not in the PATH.
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

:: Create directories if they don't exist
if not exist %BUILD_DIR% (
	mkdir %BUILD_DIR%
)

if not exist %DIST_DIR% (
	mkdir %DIST_DIR%
)

:: Clear previous binaries
del /q "%BUILD_DIR%\*.%BINARY_FILE_EXTENSION%" >nul 2>&1
del /q "%FINAL_BINARY_PATH%" >nul 2>&1

:: Compile all Assembly files
for %%f in ("%SOURCE_DIR%\*.%SOURCE_FILE_EXTENSION%") do (
	echo Assembling %%f...
	nasm -f bin "%%f" -o "%BUILD_DIR%\%%~nf.%BINARY_FILE_EXTENSION%"
)

:: Check configuration
if /i "%CONFIGURATION%"=="dist" (
	:: Concatenate all binaries into a single file
	echo Creating final OS binary...
	copy /b "%BUILD_DIR%\*.%BINARY_FILE_EXTENSION%" "%FINAL_BINARY_PATH%" >nul
	echo Final OS binary created: %FINAL_BINARY_PATH%.
) else (
	:: Keep binaries separate
	echo Keeping separate binaries in build.
)

echo Build complete.
pause
