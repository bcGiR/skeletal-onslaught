mkdir %HOMEPATH%\SkeletalOnslaught
mkdir %HOMEPATH%\SkeletalOnslaught\areas
mkdir %HOMEPATH%\SkeletalOnslaught\enemies
mkdir %HOMEPATH%\SkeletalOnslaught\heroes
mkdir %HOMEPATH%\SkeletalOnslaught\items
mkdir %HOMEPATH%\SkeletalOnslaught\npcs

COPY "*.rb" %HOMEPATH%\SkeletalOnslaught
COPY "*.txt" %HOMEPATH%\SkeletalOnslaught
COPY "*.bat" %HOMEPATH%\SkeletalOnslaught
COPY "*.csv" %HOMEPATH%\SkeletalOnslaught
COPY "*.ico" %HOMEPATH%\SkeletalOnslaught
COPY "areas\*.rb" %HOMEPATH%\SkeletalOnslaught\areas
COPY "enemies\*.rb" %HOMEPATH%\SkeletalOnslaught\enemies
COPY "heroes\*.rb" %HOMEPATH%\SkeletalOnslaught\heroes
COPY "items\*.rb" %HOMEPATH%\SkeletalOnslaught\items
COPY "npcs\*.rb" %HOMEPATH%\SkeletalOnslaught\npcs

@echo off

set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"

echo Set oWS = WScript.CreateObject("WScript.Shell") >> %SCRIPT%
echo sLinkFile = "%USERPROFILE%\Desktop\SkeletalOnslaught.lnk" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = "%HOMEPATH%\SkeletalOnslaught\SkeletalOnslaught.bat" >> %SCRIPT%
echo oLink.WorkingDirectory = "%HOMEPATH%\SkeletalOnslaught" >> %SCRIPT%
echo oLink.IconLocation = "%HOMEPATH%\SkeletalOnslaught\head.ico" >> %SCRIPT%
echo oLink.Save >> %SCRIPT%

cscript /nologo %SCRIPT%
del %SCRIPT%
