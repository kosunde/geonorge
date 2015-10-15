set DriftsbasSti="E:\\Geodata\\Temadata\\"
set TestKjoring="False"
set AGServiceNavn="XXXXXXXX.MapServer"
set AGServiceNavnSkjermet="XXXXXXXXX.MapServer"
set MailTil="drift@innlandsgis.no"
             
C:\Python27\ArcGISx6410.2\python.exe KjorOppdatering.py %DriftsbasSti% %TestKjoring% %AGServiceNavn% %AGServiceNavnSkjermet% %MailTil%
pause