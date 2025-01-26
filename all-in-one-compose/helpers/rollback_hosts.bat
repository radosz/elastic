@echo off
SETLOCAL

:: Path to the hosts file and the backup file
SET HOSTS_PATH=C:\Windows\System32\drivers\etc\hosts
SET BACKUP_PATH=C:\Windows\System32\drivers\etc\hosts.bak

:: Check if the backup file exists
IF NOT EXIST "%BACKUP_PATH%" (
    echo ERROR: Backup file "%BACKUP_PATH%" does not exist.
    echo Rollback failed! No backup to restore.
    EXIT /B 1
)

rem :: Create a new backup of the current hosts file (optional, for safety)
rem echo Creating a backup of the current hosts file...
rem copy "%HOSTS_PATH%" "%HOSTS_PATH%.rollback" > NUL

:: Restore the hosts file from the backup
echo Restoring the hosts file from the backup...
copy "%BACKUP_PATH%" "%HOSTS_PATH%" > NUL

:: Confirm success
echo Hosts file has been successfully restored from the backup!
EXIT /B 0
