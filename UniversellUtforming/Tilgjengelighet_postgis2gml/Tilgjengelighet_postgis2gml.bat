REM Hakker opp luftfratshindere i landsdekkende, kommunevise og fylkesvise gml-filer i lokal UTM-sone  
"C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\Tilgjengelighet_postgis2gml\Tilgjengelighet_postgis2gml.fmw --KNR "100-1799" --OUTPUT_EPSG_CODE "25832" --FANOUT "Kommuner"
"C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\Tilgjengelighet_postgis2gml\Tilgjengelighet_postgis2gml.fmw --KNR "1800-1999" --OUTPUT_EPSG_CODE "25833" --FANOUT "Kommuner"
"C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\Tilgjengelighet_postgis2gml\Tilgjengelighet_postgis2gml.fmw --KNR "2000-2099" --OUTPUT_EPSG_CODE "25835" --FANOUT "Kommuner"
"C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\Tilgjengelighet_postgis2gml\Tilgjengelighet_postgis2gml.fmw --FNR "1-17" --OUTPUT_EPSG_CODE "25832" --FANOUT "Fylker"
"C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\Tilgjengelighet_postgis2gml\Tilgjengelighet_postgis2gml.fmw --FNR "18-19" --OUTPUT_EPSG_CODE "25833" --FANOUT "Fylker"
"C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\Tilgjengelighet_postgis2gml\Tilgjengelighet_postgis2gml.fmw --FNR "20" --OUTPUT_EPSG_CODE "25835" --FANOUT "Fylker"
"C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\Tilgjengelighet_postgis2gml\Tilgjengelighet_postgis2gml.fmw --OUTPUT_EPSG_CODE "25833" --FANOUT "Norge"
"C:\Program Files\FME\fme.exe" \\nnrite507\Geodata\Jobs\Tilgjengelighet_postgis2gml\Tilgjengelighet_postgis2gml.fmw --OUTPUT_EPSG_CODE "4258" --FANOUT "Norge"

