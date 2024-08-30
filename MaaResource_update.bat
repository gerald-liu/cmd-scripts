@REM Author: Gerald Liu

@REM Hide "echo" when it's executed
@echo off

@REM Use pushd instead of cd because cd does not work when run as admin
@REM %0 refers to the name of the batch file.
@REM ~d extracts the drive letter of the batch file's path.
@REM ~p extracts the path (excluding the filename).
pushd %~dp0

set LOGFILE="MaaResource_update.log"

@REM Append output to the log file
call :to_Log >> %LOGFILE%

@REM Avoid executing other scripts by mistake
goto :eof


:to_Log

@REM Clone first if the local branch is not available
if not exist MaaResource (
  echo %date% %time% Clone MaaResource from MaaAssistantArknights.
  git clone https://github.com/MaaAssistantArknights/MaaResource MaaResource
)
cd MaaResource

@REM Check if local and remote are the same
git fetch origin

@REM Get the status of the Git repository in a simplified ("porcelain") format
@REM ^: Asserts that the match must occur at the beginning of the line.
@REM [ M]: Indicates a character class matching either a space or an M.
@REM - An M indicates that a file has been modified.
@REM - A space indicates that there are untracked files.
@REM %errorlevel%: success (1) or failure (0) of the last command that was run.
@REM If there are no modified or untracked files, findstr will not find a match, 
@REM and the errorlevel will be set to 1.
@REM >nul: Redirects the output of the command to nul to silence the output.
git status --porcelain | findstr "^[ M]" >nul
if %errorlevel% neq 0 (
  cd ..
  goto start_MAA
)

@REM If the local version is different, do the git pull
echo %date% %time% Update MaaResource via git pull.
git pull -f
cd ..

@REM Copy the updated files
@REM MaaResource: This is the source directory from which files will be copied.
@REM .: This represents the destination (current directory).
@REM /xd: Exclude the following directories.
@REM %cd%\MaaResource\.git: This specifies the directory to exclude.
@REM /xf: Exclude the following files.
@REM - %cd% is a variable that represents the current directory.
@REM /e: Copy all subdirectories, including empty ones.
echo %date% %time% Copy the updated files to MAA root.
robocopy MaaResource . /xd %cd%\MaaResource\.git /xf LICENSE README.md /e

@REM End of to_Log
exit /b


:start_MAA
@REM Start MAA.exe in the directory where the batch file is located
start MAA.exe

@REM End of start_MAA
exit /b


@REM Restore working directory
popd
