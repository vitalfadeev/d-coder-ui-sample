@ECHO OFF

set PATH=C:\D\LDC-1.26\bin;%PATH%

dub build --arch=x86_64  --compiler=ldc2.exe  --build=release -c windows
rem dub build --arch=x86_64  --compiler=ldc2.exe  --build=debug
