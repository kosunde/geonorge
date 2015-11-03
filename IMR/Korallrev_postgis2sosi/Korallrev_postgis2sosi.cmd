@echo off
setlocal
time /t

rem
rem Definerer kilde for FME Workspace:
rem
rem set FMEWorkspace=\\nnrite507\Geodata\Jobs\Korallrev_postgis2sosi\Korallrev_postgis2sosi.fmw
set FMEWorkspace=D:\GitHub\geonorge\IMR\Korallrev_postgis2sosi\Korallrev_postgis2sosi.fmw

rem
rem Hakker opp planomriss i landsdekkende, kommunevise og fylkesvise SOSI-filer i lokal UTM-sone  
rem
"C:\Program Files\FME\fme.exe" %FMEWorkspace% --KNR "100-1799" --OUTPUT_EPSG_CODE "25832" --FANOUT "Kommuner"
"C:\Program Files\FME\fme.exe" %FMEWorkspace% --KNR "1800-1999" --OUTPUT_EPSG_CODE "25833" --FANOUT "Kommuner"
"C:\Program Files\FME\fme.exe" %FMEWorkspace% --KNR "2000-2099" --OUTPUT_EPSG_CODE "25835" --FANOUT "Kommuner"
"C:\Program Files\FME\fme.exe" %FMEWorkspace% --FNR "1-17" --OUTPUT_EPSG_CODE "25832" --FANOUT "Fylker"
"C:\Program Files\FME\fme.exe" %FMEWorkspace% --FNR "18-19" --OUTPUT_EPSG_CODE "25833" --FANOUT "Fylker"
"C:\Program Files\FME\fme.exe" %FMEWorkspace% --FNR "20" --OUTPUT_EPSG_CODE "25835" --FANOUT "Fylker"
"C:\Program Files\FME\fme.exe" %FMEWorkspace% --OUTPUT_EPSG_CODE "25833" --FANOUT "Norge"
time /t
endlocal
@echo on
