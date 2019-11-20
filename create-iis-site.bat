REM Define variables
set hostspath=%windir%\System32\drivers\etc\hosts
set appcmdpath=%windir%\System32\inetsrv
set sitedir="%CD%\Sources\Burbolka.Web"
set project=v8.burbolka
set hostname=dev.burbolka.com
REM Delete site and pool
%appcmdpath%\appcmd.exe delete site /site.name:"rnd-%project%"
%appcmdpath%\appcmd.exe delete apppool /apppool.name:"rnd-%project%"

REM Create AppPool
%appcmdpath%\appcmd.exe add apppool /name:"rnd-%project%"
%appcmdpath%\appcmd.exe set apppool /apppool.name:"rnd-%project%" /processModel.identityType:NetworkService
%appcmdpath%\appcmd.exe set apppool /apppool.name:"rnd-%project%" /enable32BitAppOnWin64:False
%appcmdpath%\appcmd.exe set apppool /apppool.name:"rnd-%project%" /managedPipelineMode:Integrated
%appcmdpath%\appcmd.exe set apppool /apppool.name:"rnd-%project%" /managedRuntimeVersion:v4.0
%appcmdpath%\appcmd.exe set apppool /apppool.name:"rnd-%project%" /autoStart:True
%appcmdpath%\appcmd.exe start apppool /apppool.name:"rnd-%project%"

REM Create site
%appcmdpath%\appcmd.exe add site /name:"rnd-%project%" /physicalPath:"%sitedir%"
%appcmdpath%\appcmd.exe set app /app.name:"rnd-%project%/" /applicationPool:"rnd-%project%"

REM Define bindings (leave first as)
%appcmdpath%\appcmd set site /site.name:"rnd-%project%" /+bindings.[protocol='http',bindingInformation='*:80:%hostname%']
%appcmdpath%\appcmd set site /site.name:"rnd-%project%" /+bindings.[protocol='https',bindingInformation='127.0.0.1:443:%hostname%']

REM start site
%appcmdpath%\appcmd.exe start site /site.name:"rnd-%project%"

@echo off
REM Add hosts to host file
echo. >> %hostspath%
echo 127.0.0.1		%hostname% >> %hostspath%

REM create connectionstring config file
IF NOT EXIST %sitedir%\config\connectionString.config (
	ECHO F|xcopy %sitedir%\connectionString.config.example %sitedir%\config\connectionString.config 
)

REM create mailSettings config file
IF NOT EXIST %sitedir%\config\smtp.config (
	ECHO F|xcopy %sitedir%\smtp.config.example %sitedir%\config\smtp.config 
)