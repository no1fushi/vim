@echo off
cd C:\Users\%username%\centos

:loop
set /P Select="upかhaltを入力してください: "

if "%Select%" == "up" (
@echo on
vagrant up
) else if "%Select%" == "halt" (
@echo on
vagrant halt
) else (
call :loop
exit \b
)

exit \b