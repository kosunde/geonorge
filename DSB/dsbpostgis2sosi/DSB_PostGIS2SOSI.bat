REM Hakker opp DSBdata i landsdekkende, kommunevise og fylkesvise SOSI-filer i lokal UTM-sone  
REM "C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\DSB_postgis2sosi\DSB_postgis2sosi.fmw --KNR "100-1799" --OUTPUT_EPSG_CODE "25832" --FANOUT "Kommuner"
REM "C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\DSB_postgis2sosi\DSB_postgis2sosi.fmw --KNR "100-2100" --OUTPUT_EPSG_CODE "25833" --FANOUT "Kommuner"
REM "C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\DSB_postgis2sosi\DSB_postgis2sosi.fmw --KNR "2000-2099" --OUTPUT_EPSG_CODE "25835" --FANOUT "Kommuner"
REM "C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\DSB_postgis2sosi\DSB_postgis2sosi.fmw --FNR "1-17" --OUTPUT_EPSG_CODE "25832" --FANOUT "Fylker"
"C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\DSB_postgis2sosi\DSB_postgis2sosi.fmw --FNR "1-20" --OUTPUT_EPSG_CODE "25833" --FANOUT "Fylker"
REM "C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\DSB_postgis2sosi\DSB_postgis2sosi.fmw --FNR "20" --OUTPUT_EPSG_CODE "25835" --FANOUT "Fylker"
REM "C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\DSB_postgis2sosi\DSB_postgis2sosi.fmw --OUTPUT_EPSG_CODE "25833"
