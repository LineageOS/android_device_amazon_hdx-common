@echo off
for /d %%d in (%systemdrive%\python*) do set py=%%d\python
%py% %*
