@echo off
:: Get and Set all variables inside Settings.txt
for /f "delims== tokens=1,2" %%G in (%0\..\Settings.txt) do set %%G=%%H

call echo "Accessing "%STORE_URL%" store.. Please wait"

:: Run shopify commands
:: Shopify login OAUTH request
call shopify login --store=%STORE_URL%

:: Change directory to repo
call cd %STORE_PATH%

:: Check the store
call shopify store

:: Start store in local
call shopify theme serve

:: When stopped, should logout for security
:: Not working at the moment
call shopify logout

pause
exit