REM @echo off

REM Parameter 1: URL til datasett i tjenesten.
REM Parameter 2: Navn på korresponderende featureklasse i driftsdatabasen.

REM ----------------------  MILJØDIREKTORATET ----------------------

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://arcgisproxy.miljodirektoratet.no/arcgis/rest/services/artnasjonal/MapServer/1/" "art_sarlig_stor_forv_int"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://arcgisproxy.miljodirektoratet.no/arcgis/rest/services/artnasjonal/MapServer/3/" "art_omr_sarlig_stor_forv_int"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://arcgisproxy.miljodirektoratet.no/arcgis/rest/services/artnasjonal/MapServer/25/" "art_stor_forv_int"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://arcgisproxy.miljodirektoratet.no/arcgis/rest/services/artnasjonal/MapServer/27/" "art_omr_stor_forv_int"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://arcgisproxy.miljodirektoratet.no/arcgis/rest/services/artnasjonal/MapServer/29/" "art_fremmed"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://arcgisproxy.miljodirektoratet.no/arcgis/rest/services/artnasjonal/MapServer/31/" "art_omr_fremmed"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://arcgisproxy.miljodirektoratet.no/arcgis/rest/services/vern/MapServer/0/" "verneomrader_punkt"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://arcgisproxy.miljodirektoratet.no/arcgis/rest/services/vern/MapServer/1/" "verneomrader_flate"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://arcgisproxy.miljodirektoratet.no/arcgis/rest/services/friluftsliv/MapServer/0/" "statlig_sikra_friluftsliv"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://arcgisproxy.miljodirektoratet.no/arcgis/rest/services/helhetlige_kulturlandskap/MapServer/0/" "kulturlandskap"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://arcgisproxy.miljodirektoratet.no/arcgis/rest/services/naturtyper_naturbase/MapServer/0/" "naturtype_punkt"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://arcgisproxy.miljodirektoratet.no/arcgis/rest/services/naturtyper_naturbase/MapServer/1/" "naturtype_flate"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://kart.miljodirektoratet.no/arcgis/rest/services/avlop/MapServer/0/" "avlopsanlegg"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://kart.miljodirektoratet.no/arcgis/rest/services/grunnforurensning/MapServer/1/" "forurensetgrunn"

REM ----------------------  NVE ------------------------------------

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://gis3.nve.no/map/rest/services/Elvenett/MapServer/2/" "elvenettverk"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://gis3.nve.no/map/rest/services/Flomsoner/MapServer/2/" "flom10"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://gis3.nve.no/map/rest/services/Flomsoner/MapServer/3/" "flom20"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://gis3.nve.no/map/rest/services/Flomsoner/MapServer/4/" "flom50"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://gis3.nve.no/map/rest/services/Flomsoner/MapServer/5/" "flom100"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://gis3.nve.no/map/rest/services/Flomsoner/MapServer/6/" "flom200"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://gis3.nve.no/map/rest/services/Flomsoner/MapServer/7/" "flom500"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://gis3.nve.no/map/rest/services/Flomsoner/MapServer/1/" "flomsoner_dekningsomr"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://gis3.nve.no/map/rest/services/VerneplanforVassdrag/MapServer/0/" "verneplan_for_vassdrag"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://gis3.nve.no/map/rest/services/Nedborfelt/MapServer/3/" "regineenheter"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://gis3.nve.no/map/rest/services/Vannkraftverk/MapServer/2/" "vannkraftverk"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://gis3.nve.no/map/rest/services/Vannkraftverk/MapServer/0/" "vannkraft_dam"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://gis3.nve.no/map/rest/services/SkredHendelser/MapServer/1/" "skredhendelser"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://gis3.nve.no/map/rest/services/Sikringstiltak/MapServer/0/" "sikringstiltak_vassdrag"

REM ----------------------  RIKSANTIKVAREN -------------------------

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://askeladden_wms.ra.no/arcgis/rest/services/WMS/RA_Askeladden/MapServer/4/" "enkeltminner"

C:\Python27\ArcGISx6410.2\python.exe RestImport_Geometrisk7.py "http://askeladden_wms.ra.no/arcgis/rest/services/WMS/RA_Askeladden/MapServer/5/" "lokaliteter"
