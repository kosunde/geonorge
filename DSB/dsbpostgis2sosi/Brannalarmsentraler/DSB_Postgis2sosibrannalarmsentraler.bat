REM Hakker opp DSBdata i landsdekkende, kommunevise og fylkesvise SOSI-filer i lokal UTM-sone  
"C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\DSB_postgis2sosi\Brannalarmsentraler\DSB_postgis2sosibrannalarmsentraler.fmw --KNR "100-1799" --OUTPUT_EPSG_CODE "25832" --FANOUT "Kommuner"
"C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\DSB_postgis2sosi\Brannalarmsentraler\DSB_postgis2sosibrannalarmsentraler.fmw --KNR "100-2100" --OUTPUT_EPSG_CODE "25833" --FANOUT "Kommuner"
"C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\DSB_postgis2sosi\Brannalarmsentraler\DSB_postgis2sosibrannalarmsentraler.fmw --KNR "2000-2099" --OUTPUT_EPSG_CODE "25835" --FANOUT "Kommuner"
"C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\DSB_postgis2sosi\Brannalarmsentraler\DSB_postgis2sosibrannalarmsentraler.fmw --FNR "1-17" --OUTPUT_EPSG_CODE "25832" --FANOUT "Fylker"
"C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\DSB_postgis2sosi\Brannalarmsentraler\DSB_postgis2sosibrannalarmsentraler.fmw --FNR "1-20" --OUTPUT_EPSG_CODE "25833" --FANOUT "Fylker"
"C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\DSB_postgis2sosi\Brannalarmsentraler\DSB_postgis2sosibrannalarmsentraler.fmw --FNR "20" --OUTPUT_EPSG_CODE "25835" --FANOUT "Fylker"
"C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\DSB_postgis2sosi\Brannalarmsentraler\DSB_postgis2sosibrannalarmsentraler.fmw --OUTPUT_EPSG_CODE "25833"
