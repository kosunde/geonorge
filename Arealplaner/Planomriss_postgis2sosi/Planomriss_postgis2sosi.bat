REM Hakker opp planomriss i landsdekkende, kommunevise og fylkesvise SOSI-filer i lokal UTM-sone  
"C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\Planomriss_postgis2sosi\Planomriss_postgis2sosi.fmw --KNR "100-1799" --OUTPUT_EPSG_CODE "25832" --FANOUT "Kommuner"
"C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\Planomriss_postgis2sosi\Planomriss_postgis2sosi.fmw --KNR "1800-1999" --OUTPUT_EPSG_CODE "25833" --FANOUT "Kommuner"
"C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\Planomriss_postgis2sosi\Planomriss_postgis2sosi.fmw --KNR "2000-2099" --OUTPUT_EPSG_CODE "25835" --FANOUT "Kommuner"
"C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\Planomriss_postgis2sosi\Planomriss_postgis2sosi.fmw --FNR "1-17" --OUTPUT_EPSG_CODE "25832" --FANOUT "Fylker"
"C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\Planomriss_postgis2sosi\Planomriss_postgis2sosi.fmw --FNR "18-19" --OUTPUT_EPSG_CODE "25833" --FANOUT "Fylker"
"C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\Planomriss_postgis2sosi\Planomriss_postgis2sosi.fmw --FNR "20" --OUTPUT_EPSG_CODE "25835" --FANOUT "Fylker"
"C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\Planomriss_postgis2sosi\Planomriss_postgis2sosi.fmw --OUTPUT_EPSG_CODE "25835"