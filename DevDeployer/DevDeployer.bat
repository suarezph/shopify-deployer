@echo off
:: Get and Set all variables inside DevSettings.txt
for /f "delims== tokens=1,2" %%G in (%0\..\Settings.txt) do set %%G=%%H
echo ==Dev Deployer==
call echo "Accessing "%STORE_URL%" store.. Please wait"

:: Run shopify commands
:: Shopify login OAUTH request
call shopify login --store=%STORE_URL%

:: Check the store
call shopify store

:: Change directory to repo
call cd %STORE_PATH%

:: Check the branch and run confirm or exit
call echo Repository: current branch
call echo --------------------------------------------------------------
call git branch --show-current
call echo --------------------------------------------------------------
:: If it hang up: try control+C and exit, Retry again.
call git pull
call echo --------------------------------------------------------------

CHOICE /C YNC /M "Upload new theme?"
IF %ERRORLEVEL% EQU 1 goto YES
IF %ERRORLEVEL% EQU 2 goto NO
IF %ERRORLEVEL% EQU 2 goto END

:: CANCEL (C) option selected
:END
exit

:: YES (Y) option selected
:YES
:: Shopify theme push
call shopify theme push --unpublished

echo "Successfully deployed. Press any key to exit."
pause>nul
exit

:: NO (N) option selected
:NO
:: Shopify theme push
call shopify theme push 

echo "Successfully deployed. Press any key to exit."
pause>nul
exit