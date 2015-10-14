# -*- coding: UTF-8 -*-
#-------------------------------------------------------------------------------
# Purpose:  Dette skriptet oppdaterer driftsbaser i løsningen
#
# Author:   INNLANDSGIS
# Created:  15.08.2015
# Licence:  ArcGIS 10.2.2
#-------------------------------------------------------------------------------

import subprocess
import ftplib
from ftplib import FTP
import arcpy
import sys, string, os, StringIO, traceback
import smtplib, sys
import httplib, urllib, json
from email.mime.text import MIMEText
from datetime import datetime, date
from ctypes import *
serviceStoppet = False

def FTPSlett(path, fp, TestKjoring):
    try:
        ftp.cwd(path)
        #clone path to destination
    except ftplib.error_perm:
        #invalid entry (ensure input form: "/dir/folder/something/")
        fp.write ("Ftp feil: could not change to "+path)
        sys.exit("ending session")
    #list children:
    filelist=ftp.nlst()
    for file in filelist:
        try:
            #this will check if file is folder:
            ftp.cwd(path+file+"/")
            if TestKjoring == True:
              fp.write ("   Ftp ga til: ftp.cwd(" + path+file+"/)" + "\r")
            #if so, explore it:
            FTPSlett(path+file+"/")
            if TestKjoring == True:
              fp.write ("   Ftp slett katalog: ftp.rmd(" + path+file+"/)" + "\r")
            else:
              ftp.rmd(path+file+"/")
            print "Ftp slett katalog: ftp.rmd(" + path+file+"/)"
        except ftplib.error_perm:
            #not a folder with accessible content
            if TestKjoring == True:
              fp.write ("   Ftp slett fil: ftp.delete(" + file+"/)" + "\r")
            else:
              ftp.delete(file)
            print "Ftp slett fil: ftp.delete(" + file+"/)"
    return

def FTPdownloadFiles(path,destination, fp, TestKjoring):
#Kopierer alle filer fra ftp://ftp-2.fri-nett.no/Nedlasting/ til lokal disk for videre prosessering
#path & destination er str paa formen "/dir/folder/something/"
    try:
        retur = True
        ftp.cwd(path)
        #clone path to destination
        os.chdir(destination)
        os.mkdir(destination[0:len(destination)-1]+path)
        print destination[0:len(destination)-1]+path+" built"
    except OSError:
        #folder already exists at destination
        pass
    except ftplib.error_perm:
        #invalid entry (ensure input form: "/dir/folder/something/")
        fp.write ("Ftp feil: could not change to "+path)
        sys.exit("ending session")
    #list children:
    filelist=ftp.nlst()
    for file in filelist:
        try:
            #this will check if file is folder:
            ftp.cwd(path+file+"/")
            if TestKjoring == True:
              fp.write ("   Ftp ga til: ftp.cwd(" + path+file+"/)" + "\r")
            #if so, explore it:
            FTPdownloadFiles(path+file+"/",destination, fp, TestKjoring)
        except ftplib.error_perm:
            try:
                #not a folder with accessible content
                #download & return
                os.chdir(destination[0:len(destination)-1]+path)
                #possibly need a permission exception catch:
                ftp.cwd(path)
                nyDest = destination[0:len(destination)-1]+path
                ftp.retrbinary("RETR "+file, open(os.path.join(nyDest,file),"wb").write)
                zipkommando = ""
                if file.find(".zip")>0:
                    zipkommando = "7z x " + nyDest + "\\" + file + " -y"
                    os.system(zipkommando)
                    os.remove(file)
                if TestKjoring == True:
                    fp.write ("   Ftp last ned: ftp.retrbinary('RETR '"+file +", open("+os.path.join(nyDest,file)+",'wb').write)" + "\r")
                    fp.write ("   Pakker ut nedlastet fil: os.system(" + path+zipkommando+")" + "\r")
                    fp.write ("   Sletter nedlastet fil: os.remove(" + path+zipkommando+")" + "\r")
                print "Ftp last ned: ftp.retrbinary('RETR '"+file +", open("+os.path.join(nyDest,file)+",'wb').write)"
                print "Pakker ut nedlastet fil: os.system(" + path+zipkommando+")"
                print "Sletter nedlastet fil: os.remove(" + path+zipkommando+")"
                retur = False
            except:
                streng = StringIO.StringIO()
                traceback.print_exc(file=streng)
                message = streng.getvalue()
                fp.write ("Feil i funksjon FTPdownloadFiles:")
                fp.write (message)
                retur = True
    return retur


def assertJsonSuccess(data):
    #A function that checks that the input JSON object is not an error object.
    obj = json.loads(data)
    if 'status' in obj and obj['status'] == "error":
        print "Error: JSON object returns an error. " + str(obj)
        return False
    else:
        return True

def getToken(username, password, serverName, serverPort):
    tokenURL = "/arcgis/admin/generateToken"
    params = urllib.urlencode({'username': username, 'password': password, 'client': 'requestip', 'f': 'json'})
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain"}
    httpConn = httplib.HTTPConnection(serverName, serverPort)
    httpConn.request("POST", tokenURL, params, headers)
    response = httpConn.getresponse()
    if (response.status != 200):
        httpConn.close()
        print "Error while fetch tokens from admin URL. Please check the URL and try again."
        return
    else:
        data = response.read()
        httpConn.close()
        token = json.loads(data)
        return token['token']

def stopOrStartService(stopOrStart, fp, AGServiceNavn):
    username = "XXXXXX"
    password = "XXXXXX"
    serverName = "localhost"
    serverPort = "6080"
    folder = "ROOT"
    token = getToken(username, password, serverName, serverPort)
    if token == "":
        print "Could not generate a token with the username and password provided."
        return
    # Construct URL to read folder
    if str.upper(folder) == "ROOT":
        folder = ""
    else:
        folder += "/"
    folderURL = "/arcgis/admin/services/" + folder
    params = urllib.urlencode({'token': token, 'f': 'json'})
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "text/plain"}
    # Connect to URL and post parameters
    httpConn = httplib.HTTPConnection(serverName, serverPort)
    httpConn.request("POST", folderURL, params, headers)
    # Read response
    response = httpConn.getresponse()
    if (response.status != 200):
        httpConn.close()
        print "Could not read folder information."
        return
    else:
        data = response.read()
        # Check that data returned is not an error object
        if not assertJsonSuccess(data):
            print "Error when reading folder information. " + str(data)
        # Deserialize response into Python object
        dataObj = json.loads(data)
        httpConn.close()
        # Loop through each service in the folder and stop or start it
        for item in dataObj['services']:

            fullSvcName = item['serviceName'] + "." + item['type']
            if fullSvcName == AGServiceNavn:
                print "Tjeneste: " + fullSvcName
                # Construct URL to stop or start service, then make the request
                stopOrStartURL = "/arcgis/admin/services/" + folder + fullSvcName + "/" + stopOrStart
                if TestKjoring == True:
                  fp.write ("Service startes/stoppes: httpConn.request('POST', stopOrStartURL, params,headers)" + "\r")
                else:
                  httpConn.request("POST", stopOrStartURL, params, headers)
                  # Read stop or start response
                  stopStartResponse = httpConn.getresponse()
                  if (stopStartResponse.status != 200):
                      httpConn.close()
                      print "Error while executing stop or start. Please check the URL and try again."
                      return
                  else:
                      stopStartData = stopStartResponse.read()
                      # Check that data returned is not an error object
                      if not assertJsonSuccess(stopStartData):
                          if str.upper(stopOrStart) == "START":
                              print "Error returned when starting service " + fullSvcName + "."
                          else:
                              print "Error returned when stopping service " + fullSvcName + "."

                          print str(stopStartData)

                      else:
                          print "Service " + fullSvcName + " processed successfully."

        return

def SendMail (Filnavn, MailTil):
  SMTP_SERVER = 'aaa.aaa.aaa.aa'
  SMTP_PORT = 25
  # Her antas at tekstfila kun inneholder ASCII.
  fp = open(Filnavn, 'rb')
  # Lager meldingsinnholdet
  msg = MIMEText(fp.read())#,_subtype='plain',_charset='windows-1255')
  fp.close()
  msg['Subject'] = 'Oppdatering av driftsdatabaser - logg'
  msg['From'] = 'innlandsgisserver.ikkesvar@innlandsgis.no'
  msg['To'] = MailTil
  # Sender melding UTEN ENEVELOPE HEADER som blir stygt hos epostmottaker
  s = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
  s.sendmail('innlandsgisserver.ikkesvar@innlandsgis.no', MailTil, msg.as_string())
  s.quit()
  return

def Oppdater_FC ( FC, GDB, GDB_FC_ny, FDS, fp, TestKjoring, DriftsbasSti, kommuneTempSti, NyBaseSti, PostGISSti ):
  try:
    # Oppdatering av et datasett
    #FC = "vannkraftverk"
    #GDB = "beredskap.gdb"
    #GDB_FC_ny = "vannkraftverk.shp"
    #GDB_FC_ny = "beredskap.gdb\\vannkraftverk"
    FDSKat=""
    if FDS!="":
        FDSKat="\\" + FDS
    Datasett_ny = NyBaseSti + "\\" + GDB_FC_ny
    GDB_drift = DriftsbasSti + GDB
    FC_drift = DriftsbasSti + GDB + FDSKat + "\\" + FC
    BackupSti = "E:\\Geodata\\Temadata\\Sikkerhetskopi\\"
    GDB_backup = BackupSti + GDB
    FC_backup = BackupSti + GDB + FDSKat + "\\" + FC
    FC_kommuneTemp = kommuneTempSti + "\\" + FC
    data_type = ""
    print "Oppdaterer: " + FC_drift + " fra " + Datasett_ny

    #Sjekker om drifts- og backupbase er lÃ¥st av annen bruker
    lockTest = arcpy.TestSchemaLock(FC_drift)
    if lockTest==True:
        lockTest = arcpy.TestSchemaLock(FC_backup)
    if lockTest:
        KlarForOppdatering = True
    else:
        KlarForOppdatering = False

    #Sjekker om alle egenskaper er med i det nye datasettet
    EgenskaperOK = True
    fieldList_drift = arcpy.ListFields(FC_drift)
    fieldList_ny = arcpy.ListFields(Datasett_ny)
    feltIkkeFunnet = ""
    KlarForOppdatering = True
    for field_drift in fieldList_drift:
      feltFunnet = False
      if field_drift.name != "OBJECTID" and field_drift.name != "SHAPE" and field_drift.name.find("SHAPE_")!=1:
          for field_ny in fieldList_ny:
              if field_drift.name.upper() == field_ny.name.upper():
                  feltFunnet = True
          if feltFunnet == False:
              EgenskaperOK = feltFunnet
              feltIkkeFunnet = feltIkkeFunnet + ", " + field_drift.name

    GeometritypeOK = True
    if arcpy.Describe(FC_drift).shapeType<>arcpy.Describe(FC_drift).shapeType:
        GeometritypeOK = False
    if EgenskaperOK == False or GeometritypeOK == False:
        if EgenskaperOK == False:
          fp.write ("   Tabell ikke importert: " + Datasett_ny + " - felt ikke funnet: " + feltIkkeFunnet + "\r")
        if GeometritypeOK == False:
          fp.write ("   Tabell ikke importert: " + Datasett_ny + " - geometritype er ulik " + "\r")
        KlarForOppdatering = False

    else:
      if TestKjoring == True:
        fp.write ("   Ny datakilde testet for innhold: Alle attributter er riktig" + "\r\n")

    if KlarForOppdatering == True:
      #Stopper tjenesten
      if serviceStoppet == False:
        global serviceStoppet
        serviceStoppet = True
        print "Tjeneste stoppet"
        stopOrStartService ("STOP", fp, AGServiceNavn)
        stopOrStartService ("STOP", fp, AGServiceNavnSkjermet)
      # Sikkerhetskopi av siste datasett
      if not arcpy.Exists(GDB_backup):
        if TestKjoring == True:
          fp.write ("   GDB backup mangler - opprettes: arcpy.CreateFileGDB_management(" + GDB_backup + ")" + "\r")
        else:
          arcpy.CreateFileGDB_management(BackupSti, GDB)
      if arcpy.Exists(FC_backup):
        if TestKjoring == True:
          fp.write ("   FC backup klar for sletting: arcpy.Delete_management(" + FC_backup + ")" + "\r")
        else:
          arcpy.Delete_management(FC_backup )
      #Kopierer inn oppdatert datasett i databasen
      if TestKjoring == True:
        fp.write ("   Kommandoer for oppdatering av datasett:" + "\r")
        fp.write ("      arcpy.Copy_management(" + FC_drift + ", " + FC_backup + ")" + "\r")
        fp.write ("      arcpy.Delete_management(" + FC_drift + ")" + "\r")
        fp.write ("      arcpy.CopyFeatures_management(" + Datasett_ny + ", " + FC_drift + ")" + "\r")
        fp.write ("      arcpy.Delete_management(" + Datasett_ny + ")" + "\r")
      else:
        arcpy.Delete_management(FC_backup)
        arcpy.Copy_management(FC_drift, FC_backup)
        arcpy.Delete_management(FC_drift)
        arcpy.CopyFeatures_management(Datasett_ny, FC_drift)
        arcpy.Delete_management(Datasett_ny)


      #Kopierer til shp for nedlasting - også skjermede data
      if GDB.find("skjermede_data11111.gdb") == -1:
          if FDS == "":
            zipfilnavn = FC + ".zip"
          else:
            zipfilnavn = "Gruppe_" + FDS + ".zip"
          FC_kommuneTempShp = FC_kommuneTemp + ".shp"
          if TestKjoring == True:
            fp.write ("   Kommandoer for kopiering til shp for nedlasting:" + "\r")
            fp.write ("      outCS = arcpy.SpatialReference(25832)" + "\r")
            fp.write ("      arcpy.Project_management(" + FC_drift + ", " + FC_kommuneTempShp + ", outCS)" + "\r")
            fp.write ("      os.system(7z u " + kommuneTempSti + "\\" + zipfilnavn + " " + FC_kommuneTemp + ".*" + ")" + "\r\n")
          else:
            outCS = arcpy.SpatialReference(25832)
            if arcpy.Exists(FC_kommuneTempShp):
              arcpy.Delete_management(FC_kommuneTempShp)
            arcpy.Project_management(FC_drift, FC_kommuneTempShp, outCS)
            # shp for nedlasting pakkes til en zip
            #Hvis zip-fila ikke finnes fra for opprettes den. Hvis den finnes legges filene til.
            #Hvis filene finnes i zipfila fra for, oppdateres de.
            zipkommando = "7z u " + kommuneTempSti + "\\" + zipfilnavn + " " + FC_kommuneTemp + ".*"
            print zipkommando
            os.system(zipkommando)
            #zip-fil kopieres til ftp for tilgjengeliggjoring
            ftp = FTP("ftp-2.fri-nett.no")
            ftp.login("XXXXXX", "XXXXXX")
            ftp.cwd("/XXXXXX/Nedlasting")
            ftp.storbinary("STOR "+zipfilnavn, open(os.path.join(kommuneTempSti,zipfilnavn),"rb"))
            ftp.quit()

          #Til PostGIS
          GDB_PostGIS = PostGISSti + GDB
          FC_PostGIS = PostGISSti + GDB + "\\" + FC
          if TestKjoring == True:
            fp.write ("   Kommandoer for kopiering til gdb for nedlasting til PostGIS:" + "\r")
            fp.write ("      outCS = arcpy.SpatialReference(25832)" + "\r")
            fp.write ("      arcpy.Project_management(" + FC_drift + ", " + FC_PostGIS + ", outCS)" + "\r")
            fp.write ("      os.system(7z u " + PostGISSti + "\\" + zipfilnavn + " " + GDB_PostGIS + ")" + "\r\n")
          else:
            if not arcpy.Exists(GDB_PostGIS):
              if TestKjoring == True:
                  fp.write ("   GDB PostGIS mangler - opprettes: arcpy.CreateFileGDB_management(" + GDB_PostGIS + ")" + "\r")
              else:
                  arcpy.CreateFileGDB_management(PostGISSti, GDB)
            if arcpy.Exists(FC_PostGIS):
              if TestKjoring == True:
                  fp.write ("   FC PostGIS klar for sletting: arcpy.Delete_management(" + FC_PostGIS + ")" + "\r")
              else:
                  arcpy.Delete_management(FC_PostGIS )
            arcpy.Project_management(FC_drift, FC_PostGIS, outCS)
            #gdb for import i PostGIS pakkes til en zip
            #Hvis zip-fila ikke finnes fra for opprettes den. Hvis den finnes legges filene til.
            #Hvis filene finnes i zipfila fra for, oppdateres de.
            zipfilnavn=GDB[0:len(GDB)-4]+".zip"
            zipkommando = "7z u " + PostGISSti + "\\" + zipfilnavn + " " + GDB_PostGIS
            print zipkommando
            process = subprocess.Popen(zipkommando, stdout=subprocess.PIPE)
            process.wait()
            #os.system(zipkommando)
            #zip-fil kopieres til ftp for tilgjengeliggjoring
            ftp = FTP("ftp-2.fri-nett.no")
            ftp.login("XXXXXX", "XXXXXX")
            ftp.cwd("/XXXXXX/Kontrollert")
            ftp.storbinary("STOR "+zipfilnavn, open(os.path.join(PostGISSti,zipfilnavn),"rb"))
            ftp.quit()

      fp.write ("      Driftsbase oppdatert" + "\r\n")
  except:
    streng = StringIO.StringIO()
    traceback.print_exc(file=streng)
    message = streng.getvalue()
    fp.write ("Feil i funksjon Oppdater_FC:")
    fp.write (message)
    print message
  return

def behandle_FC ( GDB, FDS, FC, fp ):
  return

def getDriftsbase ( GDB_FC_ny, FC, fp, TestKjoring, DriftsbasSti, kommuneTempSti, NyBaseSti, PostGISSti ):
  FCFunnet = False
  dirList = os.listdir(DriftsbasSti)
  #For alle temadata geodatabaser
  for dir in dirList:
    if dir.find(".gdb") != -1 :
      GDB = dir
      arcpy.env.workspace = DriftsbasSti + "\\" + dir
      fcList = arcpy.ListFeatureClasses("*","")
      fcList.sort()
      #For alle featureClass i gdb
      for fc1 in fcList:
        #print "      FeatureClass: " + fc1
        FDS = ""
        if fc1 == FC:
          Oppdater_FC (fc1, GDB, GDB_FC_ny, FDS, fp, TestKjoring, DriftsbasSti, kommuneTempSti, NyBaseSti, PostGISSti)
          FCFunnet = True
      arcpy.env.workspace = DriftsbasSti + "\\" + dir
      datasetList = arcpy.ListDatasets("*", "Feature")
      #For alle dataset i gdb
      for dataset in datasetList:
        #print "   dataset: " + dataset
        FDS = dataset
        fcList = arcpy.ListFeatureClasses("*","",dataset)
        fcList.sort()
        #For alle featureClass i dataset
        for fc1 in fcList:
          if fc1 == FC:
            Oppdater_FC (fc1, GDB, GDB_FC_ny, FDS, fp, TestKjoring, DriftsbasSti, kommuneTempSti, NyBaseSti, PostGISSti)
            #print "   FeatureClass: " + fc1
            FCFunnet = True
  if FCFunnet != True:
    fp.write ("   Drifsbase ikke funnet, oppdatering ikke utfort: " + "\r")
  return

############################################################################
####################   Start skript ##################################
############################################################################
# Input argumenter fra batch:
#    sys.argv[1] - sti til driftsbasene (DriftsbasSti).
#    sys.argv[2] - angir om dette er testkjoring. Hvis True, blir ingen oppdateringer kjort, men logget.
#    sys.argv[3] - AG Service som importerte data inngar i (AGServiceNavn).
#    sys.argv[4] - AG Service som importerte data inngar i (AGServiceNavnSkjermet).
#    sys.argv[5] - Mailadresse som oppdateringslogg skal sendes til.
try:
  #sys.argv er string, dvs. andre datatyper ma handteres i kode (f.eks. True/False)
  nyttDatasettFinnes = False
  DriftsbasSti = sys.argv[1]
  if sys.argv[2] == "False":
      TestKjoring = False
  else:
      TestKjoring =True
  AGServiceNavn = sys.argv[3]
  AGServiceNavnSkjermet = sys.argv[4]
  MailTil = sys.argv[5]
except:
  TestKjoring = False
  AGServiceNavn = "RpArealformalomriss.MapServer"
  AGServiceNavnSkjermet = "SampleWorldCities.MapServer"
  DriftsbasSti = "E:\\Geodata\\Test\\Skripttest\\"

  AGServiceNavn = "Temadata_REST.MapServer"
  AGServiceNavnSkjermet = "data.MapServer"
  DriftsbasSti = "E:\\Geodata\\Temadata\\"
  MailTil ='ingar.skogli@vegvesen.no'
  pass
Filnavn = "F:\\Geodata_inn\\Oppdateringsskript\\Logg\\Feilmelding" + str(date.today()) + ".txt"
fp = open(Filnavn, 'w')
feilsituasjon = False
fp.write ("Oppdatering dato " + str(datetime.now()) + "\r\n")
feilsituasjon = False

NyBaseSti = "F:\\Geodata_inn\\XXXXXX\\TilInnlandsGIS"
FTPdest="F:/Geodata_inn/"
kommuneTempSti = "F:\\Temp"
PostGISSti = "F:\\Geodata_inn\\TilPostGIS\\"
try:
  #Sletter innhold fra kommuneTempSti
  for root, dirs, files in os.walk(kommuneTempSti, topdown=False):
    for name in files:
        os.remove(os.path.join(root, name))
    for name in dirs:
        os.rmdir(os.path.join(root, name))
  #Sletter innhold fra PostGISSti
  for root, dirs, files in os.walk(PostGISSti, topdown=False):
    for name in files:
        os.remove(os.path.join(root, name))
    for name in dirs:
        os.rmdir(os.path.join(root, name))

  #Kopierer fra ftp til F:\Geodata_inn\TilInnlandsGIS
  ftp=FTP("ftp-2.fri-nett.no")
  ftp.login("XXXXXX", "XXXXXX")
  FTPsource="/XXXXXX/TilInnlandsGIS/"
  feilsituasjon = FTPdownloadFiles(FTPsource,FTPdest, fp, TestKjoring)
  if feilsituasjon == False:
    FTPSlett(FTPsource, fp, TestKjoring)

  #Sjekker om det ligger klar nye data for et datasett
  dirList = os.listdir(NyBaseSti)
  for dir in dirList:
    #Nye data i shp-fil: shp-fila ma vare bygd opp med GDB-base navn__FeatureClass i driftsbasen
    if dir.find(".shp")==len(dir)-4:
      nyttDatasettFinnes = True
      fp.write ("Shp-fil klar for oppdatering: " + dir + "\r")
      skille = dir.find(".shp")
      GDB_FC_ny = dir
      FC = dir[0: skille]
      print "Hoved3: FC:  " + FC + " GDB_FC_ny " + GDB_FC_ny
      getDriftsbase ( GDB_FC_ny, FC, fp, TestKjoring, DriftsbasSti, kommuneTempSti, NyBaseSti, PostGISSti )
    #Nye data i gdb-fil: gdb-fila ma ha samme navn som gdb i driftsbasen
    elif dir.find(".gdb")==len(dir)-4:
      nyttDatasettFinnes = True
      GDB = dir
      arcpy.env.workspace = NyBaseSti + "\\" + dir
      fcList = arcpy.ListFeatureClasses("*","")
      fcList.sort()
      #For alle featureClass i Inndata gdb
      for FC in fcList:
          GDB_FC_ny = dir + "\\" + FC
          print "Hoved1: FC:  " + FC + " GDB " + GDB + " GDB_FC_ny " + GDB_FC_ny
          fp.write ("GDB FeatureClass klar for oppdatering: " + GDB_FC_ny + "\r")
          getDriftsbase ( GDB_FC_ny, FC, fp, TestKjoring, DriftsbasSti, kommuneTempSti, NyBaseSti, PostGISSti )
      arcpy.env.workspace = NyBaseSti + "\\" + dir
      datasetList = arcpy.ListDatasets("*", "Feature")
      #For alle dataset i Inndata gdb
      for dataset in datasetList:
        fcList = arcpy.ListFeatureClasses("*","",dataset)
        fcList.sort()
        #For alle featureClass i dataset
        for FC1 in fcList:
            fp.write ("GDB-fil klar for oppdatering: " + GDB_FC_ny + "\r")
            GDB_FC_ny = dir + "\\" + FC1
            print "Hoved2: FC:  " + FC1 + " GDB " + GDB + " GDB_FC_ny " + GDB_FC_ny
            getDriftsbase ( GDB_FC_ny, FC1, fp, TestKjoring, DriftsbasSti, kommuneTempSti, NyBaseSti, PostGISSti )

  #Hvis en gdb i inndata-katalogen er tom, skal den slettes (shp-filer og FC i gdb slettes i prosedyre Oppdater_FC.
  for dir in dirList:
    if dir.find(".gdb")==len(dir)-4:
      print "Til sletting: " + dir
      AlleDataSlettet = True
      GDB = dir
      arcpy.env.workspace = NyBaseSti + "\\" + dir
      fcList = arcpy.ListFeatureClasses("*","")
      fcList.sort()
      #For alle featureClass i Inndata gdb
      for FC in fcList:
        AlleDataSlettet = False
      arcpy.env.workspace = NyBaseSti + "\\" + dir
      datasetList = arcpy.ListDatasets("*", "Feature")
      #For alle dataset i Inndata gdb
      for dataset in datasetList:
        fcList = arcpy.ListFeatureClasses("*","",dataset)
        fcList.sort()
        #For alle featureClass i dataset
        for FC1 in fcList:
          AlleDataSlettet = False
      if AlleDataSlettet == True:
        if TestKjoring == True:
          fp.write ("      arcpy.Delete_management(" + GDB + ")" + "\r")
        else:
          #print "arcpy.Delete_management("+ NyBaseSti + "\\" + dir + ")"
          arcpy.Delete_management(NyBaseSti + "\\" + dir)
  if serviceStoppet == True:
    print "Tjeneste startet"
    stopOrStartService ("START", fp, AGServiceNavn)
    stopOrStartService ("START", fp, AGServiceNavnSkjermet)
  fp.write ("Oppdatering utfort " + str(datetime.now()))
except:
    streng = StringIO.StringIO()
    traceback.print_exc(file=streng)
    message = streng.getvalue()
    fp.write ("Feil i hovedfunksjon:")
    fp.write (message)
    print message
    fp.write ("Oppdatering avbrutt! " + str(datetime.now()))
    feilsituasjon = True
    pass
fp.close()
if nyttDatasettFinnes == True or feilsituasjon == True:
  SendMail (Filnavn, MailTil)
  #   if