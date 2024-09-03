@REM Author: Gerald Liu

@REM Hide "echo" when it's executed
@echo off

@REM Use pushd instead of cd because cd does not work when run as admin
@REM %0 refers to the name of the batch file.
@REM ~d extracts the drive letter of the batch file's path.
@REM ~p extracts the path (excluding the filename).
pushd %~dp0

setlocal

set LOGFILE="MaaResource_update.log"

@REM Clone first if the local branch is not available
if not exist MaaResource (
  echo %date% %time% Clone MaaResource from MaaAssistantArknights. >> %LOGFILE%
  git clone https://github.com/MaaAssistantArknights/MaaResource MaaResource
  echo %date% %time% Copy the updated files to MAA root. >> %LOGFILE%
  robocopy MaaResource . /xd MaaResource\.git /xf LICENSE README.md /e
)

cd MaaResource

@REM Check if local and remote are the same
git fetch origin main

@REM Count number of commits behind the origin
for /f "tokens=*" %%a in ('git rev-list --count HEAD..origin') do set BEHIND=%%a

@REM If the local version is different, do the git pull
if %BEHIND% gtr 0 (
  echo %date% %time% Pull MaaResource - %BEHIND% commits behind. >> ..\%LOGFILE%
  git pull -f origin main
  cd ..
  echo %date% %time% Copy the updated files to MAA root. >> %LOGFILE%
  robocopy MaaResource . /xd MaaResource\.git /xf LICENSE README.md /e
) else (
  cd ..
)

@REM Start MAA.exe in the directory where the batch file is located
start MAA.exe

exit /b

@REM Restore working directory
popd
