@echo off
:: Get and Set all variables inside settings.txt
for /f "delims== tokens=1,2" %%G in (%0\..\Settings.txt) do set %%G=%%H

echo ==Live Deployer==
echo.

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

:: START options
:START
echo.
echo List of stores:
echo 1. All Store
echo 2. Singapore Store
echo 3. US Store
echo 4. Canada Store
echo 0. Exit

set choice=
set /p choice=Type the number to deploy: 
if not '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='1' goto STORE_ALL
if '%choice%'=='2' goto STORE_SG
if '%choice%'=='3' goto STORE_US
if '%choice%'=='4' goto STORE_CA
if '%choice%'=='0' goto END
echo "%choice%" is not valid, try again
echo.
goto START

:STORE_ALL
call :DeployAll

:STORE_SG
call :DeployIndividualFunc %STORE_URL_SG% Singapore

:STORE_US
call :DeployIndividualFunc %STORE_URL_US% US

:STORE_CA
call :DeployIndividualFunc %STORE_URL_CA% Canada

:: Deploy method for final theme deployment
:DeployIndividualFunc
    :START_DEPLOY
    cls
    echo.
    echo You've selected %~2 store, choose an option:
    echo 1. Upload new theme
    echo 2. Upload to an existing theme
    echo 0. Exit
    set choice=
    set /p choice=Type the number to upload: 
    if not '%choice%'=='' set choice=%choice:~0,1%
    if '%choice%'=='1' goto NEW_THEME
    if '%choice%'=='2' goto EXISTING_THEME
    if '%choice%'=='0' goto END
    echo.
    goto START_DEPLOY

    :NEW_THEME
    call shopify login --store=%~1
    call shopify store
    call shopify theme push --unpublished
    echo "Successfully deployed. Press any key to exit."
    pause>nul
    exit

    :EXISTING_THEME
    call shopify login --store=%~1
    call shopify store
    call shopify theme push
    echo "Successfully deployed. Press any key to exit."
    pause>nul
    exit

goto :eof

:: Deploy method for final theme deployment
:DeployAll
    :START_DEPLOY
    cls
    echo.
    echo You've selected ALL store, choose an option:
    echo 1. Upload new theme
    echo 2. Upload to an existing theme
    echo 0. Exit
    set choice=
    set /p choice=Type the number to upload: 
    if not '%choice%'=='' set choice=%choice:~0,1%
    if '%choice%'=='1' goto ALL_NEW_THEME
    if '%choice%'=='2' goto ALL_EXISTING_THEME
    if '%choice%'=='0' goto END
    echo.
    goto START_DEPLOY

    :ALL_NEW_THEME
    call shopify login --store=%STORE_URL_SG%
    call shopify theme push --unpublished
    call shopify login --store=%STORE_URL_US%
    call shopify theme push --unpublished
    call shopify login --store=%STORE_URL_CA%
    call shopify theme push --unpublished
    echo "Successfully deployed. Press any key to exit."
    pause>nul
    exit

    :ALL_EXISTING_THEME
    call shopify login --store=%STORE_URL_SG%
    call shopify theme push
    call shopify login --store=%STORE_URL_US%
    call shopify theme push
    call shopify login --store=%STORE_URL_CA%
    call shopify theme push
    echo "Successfully deployed. Press any key to exit."
    pause>nul
    exit

goto :eof

:END
exit