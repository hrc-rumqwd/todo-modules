@echo off
title Remove Postgres Container

set "CONTAINER_NAME=rum-postgres"
set "BIND_PATH="

echo Checking container is existing...
wsl sh -c "docker ps -f name=%CONTAINER_NAME% | grep -q %CONTAINER_NAME%)"
if %ERRORLEVEL% EQU 0
	echo Found the Container %CONTAINER_NAME%
	echo Begin searching for mount path...
	for /f "delims=" %%i in ('
		wsl docker inspect %CONTAINER_NAME% --format "{{json .HostConfig.Binds}}"
	') do (
    		set "BIND_PATH=%%i"
	)


	if exist "%BIND_PATH%" (
		echo Found binding path
		echo Begin remove volume
		wsl docker rm -v %CONTAINER_NAME%
	
		echo Begin remove binding path
		wsl rm -rf %BIND_PATH%
	)
	else (
		echo Not found binding path
	)

else (
echo Not found container
)

pause