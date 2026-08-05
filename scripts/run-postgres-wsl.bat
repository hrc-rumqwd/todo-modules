@echo off

title Run WSL and Postgres with Docker setup
set "IMAGE=postgres:18.4"
set "CONTAINER_NAME=rum-postgres"
set "STORAGE_PATH=/var/lib/postgresql"

echo Run Docker service in WSL...
wsl -u root service docker start
echo Run Docker service successfully


set "CONTAINER_ID="
echo Check container is existed

for /f %%i in ('wsl docker ps -aq -f "name=%CONTAINER_NAME%"') do (
	set "CONTAINER_ID=%%i"
)

if defined CONTAINER_ID (
	echo Existing container found: %CONTAINER_NAME%
	echo Removing container...
	wsl docker rm -f %CONTAINER_NAME%
)

echo Pull Postgres image
wsl docker pull %IMAGE%
echo Pull done


echo Starting postgres
wsl docker run -d --name %CONTAINER_NAME% -e POSTGRES_PASSWORD=%DEFAULT_POSTGRES_PASSWORD% -p 127.0.0.1:5432:5432 -v pgdata:%STORAGE_PATH% %IMAGE%
echo Everything done

pause