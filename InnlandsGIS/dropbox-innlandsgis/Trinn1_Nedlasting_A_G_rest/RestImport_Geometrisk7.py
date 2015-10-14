# -*- coding: utf-8 -*-
#-------------------------------------------------------------------------------
# Name:     module1
# Purpose:  Dette skriptet kopierer AG REST datakilde til en filgeodatabase
#	    REST datakilde: Angis i baseURL (argument 1)
#	    filgeodatabase: Angis i gdbResultat (argument 2).
#	    Feature Class: Angis i fcNResultatavn (argument 2). Om ikke fc finnes i gdb, opprettes denne. Navn må ikke samsvare med REST datakilde.
#   
# Author:   INNLANDSGIS
# Created:  08.06.2014
# Licence:  ArcGIS 10.2.2
#-------------------------------------------------------------------------------

import sys, urllib, urllib2, json, arcpy, StringIO, os, math, time, shutil, traceback, smtplib
from ftplib import FTP
from arcpy import env
from datetime import datetime, date
from pprint import pprint
from os.path import abspath, join
from email.mime.text import MIMEText


#sys.argv er parametrene som sendes inn fra batchfil
#sys.argv er string, dvs. andre datatyper ma handteres i kode (f.eks. True/False)
baseURL= sys.argv[1]
gdbResultat=sys.argv[2]
gdbResultat=gdbResultat + ".gdb"
fcNResultatavn = sys.argv[2]
zipfilnavn = fcNResultatavn + ".zip"

date_string = time.strftime("%Y-%m-%d")

arbKatalog = "F:\\Geodata_inn\\Oppdateringsskript\\rest_import"
loggFilNavn = "Loggfil_" + date_string + ".txt"
temadatakatalog = r"E:\Geodata\Temadata"

if os.path.isfile("F:/Geodata_inn/Oppdateringsskript/rest_import/logfiler/" + loggFilNavn):
    fp = open("F:/Geodata_inn/Oppdateringsskript/rest_import/logfiler/" + loggFilNavn, 'a')
else:
    fp = open("F:/Geodata_inn/Oppdateringsskript/rest_import/logfiler/" + loggFilNavn, 'w')

fp.write ("Sjekker status på featureklassen " + fcNResultatavn.upper() + " " + str(time.strftime("%H:%M:%S")) + ": " + "\n")
kjor_nedlasting = False
EgenskaperOK = True
ftpoverforing = False
attributtsjekk = True

#sjekker om zip-fil allerede finnes på ftp-området for tilgjengeliggjoring
try:
    sjekk = True
    ftp = FTP("ftp-2.fri-nett.no")
    ftp.login("ftp_ilg", "FlGs2013")
    ftp.cwd("/FTP_ILG/TilInnlandsGIS")
    if zipfilnavn in ftp.nlst():
        sjekk = False
        fp.write ("Featureklassen er allerede lastet ned og ligger allerede på ftp-området. Årsaken er at oppdateringsskriptet feilet ved sist kjøring." + "\n")
    ftp.quit()
except:
    sjekk = True


if sjekk == True:
    # Finner aktuell featureklasse i vår geodatabase:
    def walk_directory(temadatakatalog):
        funnet_featureklasse = False
        output_list = "ingenting"
        for base_dir, child_dirs, filenames in arcpy.da.Walk(temadatakatalog, datatype='FeatureClass'):
            if funnet_featureklasse == False:
                for filename in filenames:
                    data = join(abspath(base_dir), filename)
                    output_list = data
                    if filename == fcNResultatavn:
                        funnet_featureklasse = True
                        break
                    else:
                        continue
            else:
                break
        return output_list
        
    output_data = walk_directory(temadatakatalog)

if sjekk == True:
    # Teller objekter i aktuell featureklasse i vår database:
    arcpy.MakeTableView_management(output_data, "myTableView")
    antall_objekter_vaar = str(arcpy.GetCount_management("myTableView").getOutput(0))
    arcpy.Delete_management("myTableView")
    fp.write ("Antall objekter i aktuell featureklasse i vår geodatabase:  " + antall_objekter_vaar + "\n")

    # Sammenlikner antall objekter i aktuell featureklasse i vår database med kooresponderende lag i dataeiers tjeneste:    

    try:
        resultatCount_eier = urllib2.urlopen(baseURL + "query?where=&text=&objectIds=&time=&geometry={%22rings%22:[[[386848.62862589676,6625057.1097229011],[320815.40022600256,6631674.0196643658],[285587.64109016117,6709457.649964096],[266742.04089665692,6662532.8903666362],[219235.57211083453,6698210.265744308],[127971.68328801263,6788053.7049356401],[90684.880461570807,6896362.9893362634],[103113.81473705079,6919800.408255741],[181238.54446864966,6939331.5906886421],[223141.80859741382,6919800.408255741],[247289.45233263448,6963124.122015994],[288312.66956620105,6963892.511014536],[388269.07825738285,6932584.4549391009],[386848.62862589676,6625057.1097229011]]]}&geometryType=esriGeometryPolygon&inSR=25833&spatialRel=esriSpatialRelIntersects&relationParam=&outFields=&returnGeometry=false&maxAllowableOffset=&geometryPrecision=&returnIdsOnly=false&returnCountOnly=true&orderByFields=&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&gdbVersion=&returnDistinctValues=false&f=pjson", '').read()
        jsonresultatCount_eier = json.loads(resultatCount_eier)
        antall_objekter_eier = str(jsonresultatCount_eier["count"])
        fp.write ("Kontakt med dataeiers tjeneste ble oppnådd på første forsøk." + "\n")
        fp.write ("Antall objekter i dataeiers tjeneste:  " + antall_objekter_eier + "\n")
        if antall_objekter_vaar <> antall_objekter_eier:
            kjor_nedlasting = True
        else:    
            fp.write ("Antall objekter i dataeiers service og vår geodatabase er likt."  + "\n")
    except:
        time.sleep(30)
        try:
            resultatCount_eier = urllib2.urlopen(baseURL + "query?where=&text=&objectIds=&time=&geometry={%22rings%22:[[[386848.62862589676,6625057.1097229011],[320815.40022600256,6631674.0196643658],[285587.64109016117,6709457.649964096],[266742.04089665692,6662532.8903666362],[219235.57211083453,6698210.265744308],[127971.68328801263,6788053.7049356401],[90684.880461570807,6896362.9893362634],[103113.81473705079,6919800.408255741],[181238.54446864966,6939331.5906886421],[223141.80859741382,6919800.408255741],[247289.45233263448,6963124.122015994],[288312.66956620105,6963892.511014536],[388269.07825738285,6932584.4549391009],[386848.62862589676,6625057.1097229011]]]}&geometryType=esriGeometryPolygon&inSR=25833&spatialRel=esriSpatialRelIntersects&relationParam=&outFields=&returnGeometry=false&maxAllowableOffset=&geometryPrecision=&returnIdsOnly=false&returnCountOnly=true&orderByFields=&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&gdbVersion=&returnDistinctValues=false&f=pjson", '').read()
            jsonresultatCount_eier = json.loads(resultatCount_eier)
            antall_objekter_eier = str(jsonresultatCount_eier["count"])
            fp.write ("Kontakt med dataeiers tjeneste ble oppnådd på andre forsøk." + "\n")
            fp.write ("Antall objekter i dataeiers tjeneste:  " + antall_objekter_eier + "\n")
            if antall_objekter_vaar <> antall_objekter_eier:
                kjor_nedlasting = True
            else:    
                fp.write ("Antall objekter i dataeiers service og vår geodatabase er likt."  + "\n")
        except:
            time.sleep(30)
            try:
                resultatCount_eier = urllib2.urlopen(baseURL + "query?where=&text=&objectIds=&time=&geometry={%22rings%22:[[[386848.62862589676,6625057.1097229011],[320815.40022600256,6631674.0196643658],[285587.64109016117,6709457.649964096],[266742.04089665692,6662532.8903666362],[219235.57211083453,6698210.265744308],[127971.68328801263,6788053.7049356401],[90684.880461570807,6896362.9893362634],[103113.81473705079,6919800.408255741],[181238.54446864966,6939331.5906886421],[223141.80859741382,6919800.408255741],[247289.45233263448,6963124.122015994],[288312.66956620105,6963892.511014536],[388269.07825738285,6932584.4549391009],[386848.62862589676,6625057.1097229011]]]}&geometryType=esriGeometryPolygon&inSR=25833&spatialRel=esriSpatialRelIntersects&relationParam=&outFields=&returnGeometry=false&maxAllowableOffset=&geometryPrecision=&returnIdsOnly=false&returnCountOnly=true&orderByFields=&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&gdbVersion=&returnDistinctValues=false&f=pjson", '').read()
	        jsonresultatCount_eier = json.loads(resultatCount_eier)
	        antall_objekter_eier = str(jsonresultatCount_eier["count"])
	        fp.write ("Kontakt med dataeiers tjeneste ble oppnådd på tredje forsøk." + "\n")
	        fp.write ("Antall objekter i dataeiers tjeneste:  " + antall_objekter_eier + "\n")
	        if antall_objekter_vaar <> antall_objekter_eier:
	            kjor_nedlasting = True
	        else:    
	            fp.write ("Antall objekter i dataeiers service og vår geodatabase er likt."  + "\n")
	    except:
                time.sleep(30)
                try:
	            resultatCount_eier = urllib2.urlopen(baseURL + "query?where=&text=&objectIds=&time=&geometry={%22rings%22:[[[386848.62862589676,6625057.1097229011],[320815.40022600256,6631674.0196643658],[285587.64109016117,6709457.649964096],[266742.04089665692,6662532.8903666362],[219235.57211083453,6698210.265744308],[127971.68328801263,6788053.7049356401],[90684.880461570807,6896362.9893362634],[103113.81473705079,6919800.408255741],[181238.54446864966,6939331.5906886421],[223141.80859741382,6919800.408255741],[247289.45233263448,6963124.122015994],[288312.66956620105,6963892.511014536],[388269.07825738285,6932584.4549391009],[386848.62862589676,6625057.1097229011]]]}&geometryType=esriGeometryPolygon&inSR=25833&spatialRel=esriSpatialRelIntersects&relationParam=&outFields=&returnGeometry=false&maxAllowableOffset=&geometryPrecision=&returnIdsOnly=false&returnCountOnly=true&orderByFields=&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&gdbVersion=&returnDistinctValues=false&f=pjson", '').read()
	            jsonresultatCount_eier = json.loads(resultatCount_eier)
	            antall_objekter_eier = str(jsonresultatCount_eier["count"])
	            fp.write ("Kontakt med dataeiers tjeneste ble oppnådd på fjerde forsøk." + "\n")
	            fp.write ("Antall objekter i dataeiers tjeneste:  " + antall_objekter_eier + "\n")
	            if antall_objekter_vaar <> antall_objekter_eier:
	                kjor_nedlasting = True
	            else:    
	                fp.write ("Antall objekter i dataeiers service og vår geodatabase er likt."  + "\n")
	        except:
                    fp.write ("Det gikk av en eller annen grunn ikke å telle objektene i dataeiers service." + "\n")


def getServiceFields(URL):

    fURL = baseURL + "?f=json"

    openURL = urllib2.urlopen(fURL, '').read()
    outJson = json.loads(openURL)
    return outJson["fields"]
    
    
if kjor_nedlasting == True: 
    from datetime import datetime, date
    jsonFile = fcNResultatavn + ".json"
    fcResultat=gdbResultat + "\\" + fcNResultatavn
    arcpy.env.overwriteOutput = True
    arcpy.env.workspace = gdbResultat
    schemaType = "NO_TEST"
    token = ''
    
    try:
        #Trekker ut feltnavn for query
        fields = getServiceFields(baseURL)
        outFields = ""
        for f in fields:
            type = f["type"]
            if f["type"] != "esriFieldTypeGeometry" and type != "esriFieldTypeOID":
                outFields = outFields + f["name"] + ","          
        outFields = outFields[:-1]
    
        #Sjekker om alle egenskaper er med i det nye datasettet
        fieldList_drift = arcpy.ListFields(output_data)
        feltIkkeFunnet = ""
        for field_drift in fieldList_drift:
            feltFunnet = False
            if field_drift.name.upper() != "OBJECTID" and field_drift.name.upper() != "SHAPE" and "SHAPE_" not in field_drift.name.upper():
                if field_drift.name.upper() in outFields.upper():
                    feltFunnet = True
                if feltFunnet == False:
                    EgenskaperOK = False
                    feltIkkeFunnet = feltIkkeFunnet + ", " + field_drift.name
    except:
        attributtsjekk = False
              
    if EgenskaperOK == False and attributtsjekk == True:
        epost_tittel = "Nedlasting av temadata - feil for " + fcNResultatavn.upper()
        epost_fra = "innlandsgisserver.ikkesvar@innlandsgis.no"
        epost_til = "fmopegu@fylkesmannen.no"
        fp.write ("Attributter i driftsdatabasen ble ikke funnet i dataeiers service: " + feltIkkeFunnet + "\n")
        fp.write ("Datasett blir likevel forsøkt lastet ned og lagret på F:\Geodata_inn\Oppdateringsskript\rest_import\attributter_ikke_ok."+ "\n")
        SMTP_SERVER = '158.149.230.10'
        SMTP_PORT = 25
        eposttext = "Det er noen attributter i driftsdatabasen som ikke ble funnet i dataeiers service.\nDette kan tyde på at tjenesten har endret innhold.\nDatasett blir likevel forsøkt lastet ned og lagret på F:\Geodata_inn\Oppdateringsskript\rest_import\attributter_ikke_ok."
        msg = MIMEMultipart('alternative')
        msg['Subject'] = epost_tittel
        msg['From'] = epost_fra
        msg['To'] = epost_til
        epostinnhold = MIMEText(eposttext, 'plain')
        msg.attach(epostinnhold)
        s = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
        s.sendmail(epost_fra, epost_til, msg.as_string())
        s.quit()
        
    if EgenskaperOK == True and attributtsjekk == True:
        fp.write ("Alle attributtene i driftsdatabasen ble funnet i dataeiers service." + "\n")
        
    if attributtsjekk == False:
        kjor_nedlasting = False
        fp.write ("Pga. en feil gikk det ikke å verifisere attributtnavnene i vår geodatabase mot dataeiers service." + "\n")
        

# Starter..
if kjor_nedlasting == True:
    try:
       from datetime import datetime, date
       jsonFile = fcNResultatavn + ".json"
       fcResultat=gdbResultat + "\\" + fcNResultatavn
       arcpy.env.overwriteOutput = True
       arcpy.env.workspace = gdbResultat
       schemaType = "NO_TEST"
       token = ''

       #Oppretter filbase om den ikke allerede eksisterer
       if not arcpy.Exists(arbKatalog + gdbResultat):
           arcpy.CreateFileGDB_management(arbKatalog, gdbResultat)
       
       # query i neste linje er geometrisk og beskriver en bounding box for Hedmark og Oppland fylker..
       query = "query?where=&text=&objectIds=&time=&geometry={%22rings%22:[[[386848.62862589676,6625057.1097229011],[320815.40022600256,6631674.0196643658],[285587.64109016117,6709457.649964096],[266742.04089665692,6662532.8903666362],[219235.57211083453,6698210.265744308],[127971.68328801263,6788053.7049356401],[90684.880461570807,6896362.9893362634],[103113.81473705079,6919800.408255741],[181238.54446864966,6939331.5906886421],[223141.80859741382,6919800.408255741],[247289.45233263448,6963124.122015994],[288312.66956620105,6963892.511014536],[388269.07825738285,6932584.4549391009],[386848.62862589676,6625057.1097229011]]]}&geometryType=esriGeometryPolygon&inSR=25833&spatialRel=esriSpatialRelIntersects&relationParam=&outFields=&returnGeometry=false&maxAllowableOffset=&geometryPrecision=&returnIdsOnly=true&returnCountOnly=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&gdbVersion=&returnDistinctValues=false&f=pjson"
       resultat = urllib2.urlopen(baseURL + query, '').read()
       jsonresultat = json.loads(resultat)
       objectIdFeltnavn=jsonresultat["objectIdFieldName"]
       Objektliste=[]
       Objektliste=jsonresultat["objectIds"]
       
       fp.write ("Første forsøk på nedlasting startet " + str(time.strftime("%H:%M:%S")) + "\n")
       
       #til info: antall iterasjoner
       antIterasj = int(math.ceil(jsonresultatCount_eier["count"]/150.))

       #Lager lister med OBJECTID med 150 i hver
       i=1
       Grupper=[Objektliste[x:x+150] for x in xrange(0, len(Objektliste), 150)]
       for Gruppe  in Grupper:
           strGruppeListeREST = "(" + ','.join(str(e) for e in Gruppe) + ")"
           queryREST = "query?where={}&outFields={}&returnGeometry=true&f=pjson&outSR=25833".format(objectIdFeltnavn + '%20in%20' + strGruppeListeREST, outFields)
           helRESTURL = baseURL + queryREST
           jsonFileInn = urllib2.urlopen(helRESTURL)
           fsInn = arcpy.AsShape(jsonFileInn.read(), True)

           #Første iterasjon håndteres spesielt i og med at den oppretter featureclassen:
           if i==1:
               arcpy.CopyFeatures_management(fsInn, fcResultat)
           else:
               arcpy.Append_management(fsInn, fcResultat, schemaType)

           i=i+1
       
       fp.write ("Data ble lastet ned på første forsøk ")
       #Pakker gdb
       zipkommando = "\"C:\\Program Files\\7-Zip\\7z\" a " + arbKatalog + "\\" + zipfilnavn + " " + arbKatalog + "\\" + gdbResultat
       os.system(zipkommando)
    
    except:
        fp.write ("Første forsøk på nedlasting feilet " + str(time.strftime("%H:%M:%S")) + "\n")
        try:
            from datetime import datetime, date
            time.sleep(20)
            fp.write ("Andre forsøk på nedlasting startet  " + str(time.strftime("%H:%M:%S")) + "\n")
            jsonFile = fcNResultatavn + ".json"
            fcResultat=gdbResultat + "\\" + fcNResultatavn
            arcpy.env.overwriteOutput = True
            arcpy.env.workspace = gdbResultat
            schemaType = "NO_TEST"
            token = ''

            #Oppretter filbase om den ikke allerede eksisterer
            if not arcpy.Exists(arbKatalog + gdbResultat):
                arcpy.CreateFileGDB_management(arbKatalog, gdbResultat)
       
            #Trekker ut feltnavn for query
            fields = getServiceFields(baseURL)
            outFields = ""
            for f in fields:
                type = f["type"]
                if f["type"] != "esriFieldTypeGeometry" and type != "esriFieldTypeOID":
                    outFields = outFields + f["name"] + ","          
            outFields = outFields[:-1]
       
            # query i neste linje er geometrisk og beskriver en bounding box for Hedmark og Oppland fylker..
            query = "query?where=&text=&objectIds=&time=&geometry={%22rings%22:[[[386848.62862589676,6625057.1097229011],[320815.40022600256,6631674.0196643658],[285587.64109016117,6709457.649964096],[266742.04089665692,6662532.8903666362],[219235.57211083453,6698210.265744308],[127971.68328801263,6788053.7049356401],[90684.880461570807,6896362.9893362634],[103113.81473705079,6919800.408255741],[181238.54446864966,6939331.5906886421],[223141.80859741382,6919800.408255741],[247289.45233263448,6963124.122015994],[288312.66956620105,6963892.511014536],[388269.07825738285,6932584.4549391009],[386848.62862589676,6625057.1097229011]]]}&geometryType=esriGeometryPolygon&inSR=25833&spatialRel=esriSpatialRelIntersects&relationParam=&outFields=&returnGeometry=false&maxAllowableOffset=&geometryPrecision=&returnIdsOnly=true&returnCountOnly=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&gdbVersion=&returnDistinctValues=false&f=pjson"
            resultat = urllib2.urlopen(baseURL + query, '').read()
            jsonresultat = json.loads(resultat)
            objectIdFeltnavn=jsonresultat["objectIdFieldName"]
            
            Objektliste=[]
            Objektliste=jsonresultat["objectIds"]
            
            fp.write ("Andre forsøk på nedlasting startet " + str(time.strftime("%H:%M:%S")) + "\n")

            #til info: antall iterasjoner
            antIterasj = int(math.ceil(jsonresultatCount_eier["count"]/150.))

            #Lager lister med OBJECTID med 150 i hver
            i=1
            Grupper=[Objektliste[x:x+150] for x in xrange(0, len(Objektliste), 150)]

            for Gruppe  in Grupper:
                strGruppeListeREST = "(" + ','.join(str(e) for e in Gruppe) + ")"
                queryREST = "query?where={}&outFields={}&returnGeometry=true&f=pjson&outSR=25833".format(objectIdFeltnavn + '%20in%20' + strGruppeListeREST, outFields)
                helRESTURL = baseURL + queryREST
                jsonFileInn = urllib2.urlopen(helRESTURL)
                fsInn = arcpy.AsShape(jsonFileInn.read(), True)

                #Første iterasjon håndteres spesielt i og med at den oppretter featureclassen:
                if i==1:
                    arcpy.CopyFeatures_management(fsInn, fcResultat)
                else:
                    arcpy.Append_management(fsInn, fcResultat, schemaType)

            i=i+1
            
            fp.write ("Data ble lastet ned på andre forsøk ")
            #Pakker gdb
            zipkommando = "\"C:\\Program Files\\7-Zip\\7z\" a " + arbKatalog + "\\" + zipfilnavn + " " + arbKatalog + "\\" + gdbResultat
            os.system(zipkommando)
            
    
        except:
	    streng = StringIO.StringIO()
	    traceback.print_exc(file=streng)
	    message = streng.getvalue()
	    fp.write ("Nedlasting feilet etter to forsøk " + str(time.strftime("%H:%M:%S")) + "\n")
	    fp.write ("Feil i hovedfunksjon:" + "\n")
	    fp.write (message)
            pass

else:
    fp.write ("Datasettet ble ikke lastet ned." + "\n")


if os.path.isfile(zipfilnavn) and EgenskaperOK == True:
    #Teller objekter som er lastet ned
    arcpy.MakeTableView_management(fcResultat, "myTableView2")
    antall_nedlastede_objekter = str(arcpy.GetCount_management("myTableView2").getOutput(0))
    arcpy.Delete_management("myTableView2")
    if antall_nedlastede_objekter == antall_objekter_eier:
        fp.write ("og alle objekter ble lastet ned." + "\n")
        ftpoverforing = True
    else:
        fp.write ("men ikke alle objektene ble lastet ned." + "\n")
        os.remove(zipfilnavn)


if os.path.isfile(zipfilnavn) and EgenskaperOK == False:
    import shutil
    shutil.copy2(zipfilnavn, "F:\\Geodata_inn\\Oppdateringsskript\\rest_import\\attributter_ikke_ok\\" + zipfilnavn)
    fp.write ("Featureklassen ble lagt på katalogen attributter_ikke_ok." + "\n")
    os.remove(zipfilnavn)
    
        
if ftpoverforing == True:
    try:
        ftp = FTP("ftp-2.fri-nett.no")
	ftp.login("ftp_ilg", "FlGs2013")
	ftp.cwd("/FTP_ILG/TilInnlandsGIS")
	ftp.storbinary("STOR "+zipfilnavn, open(zipfilnavn,"rb"))
	ftp.quit()
	fp.write ("Featureklassen ble overført til ftp-område på første forsøk." + "\n")
	os.remove(zipfilnavn)
    except:
        time.sleep(20)
        try:
	    #zip-fil kopieres til ftp for tilgjengeliggjoring
	    ftp = FTP("ftp-2.fri-nett.no")
            ftp.login("ftp_ilg", "FlGs2013")
            ftp.cwd("/FTP_ILG/TilInnlandsGIS")
	    ftp.storbinary("STOR "+zipfilnavn, open(zipfilnavn,"rb"))
            ftp.quit()
	    fp.write ("Featureklassen ble overført til ftp-område på andre forsøk." + "\n")
	    os.remove(zipfilnavn)
	except:
            time.sleep(20)
            try:
	    	#zip-fil kopieres til ftp for tilgjengeliggjoring
	    	ftp = FTP("ftp-2.fri-nett.no")
	        ftp.login("ftp_ilg", "FlGs2013")
	        ftp.cwd("/FTP_ILG/TilInnlandsGIS")
	    	ftp.storbinary("STOR "+zipfilnavn, open(zipfilnavn,"rb"))
	        ftp.quit()
	    	fp.write ("Featureklassen ble overført til ftp-område på tredje forsøk." + "\n")
	    	os.remove(zipfilnavn)
	    except:
                time.sleep(20)
                try:
	            #zip-fil kopieres til ftp for tilgjengeliggjoring
		    ftp = FTP("ftp-2.fri-nett.no")
		    ftp.login("ftp_ilg", "FlGs2013")
		    ftp.cwd("/FTP_ILG/TilInnlandsGIS")
                    ftp.storbinary("STOR "+zipfilnavn, open(zipfilnavn,"rb"))
		    ftp.quit()
	            fp.write ("Featureklassen ble overført til ftp-område på fjerde forsøk." + "\n")
	            os.remove(zipfilnavn)
	        except:
                    fp.write ("Av en eller annen grunn var ftp-området utilgjengelig. Featureklassen ble derfor ikke lastet opp." + "\n")
                    os.remove(zipfilnavn)



if os.path.isdir(gdbResultat):
    shutil.rmtree(gdbResultat)
           
fp.write ("Avsluttet " + str(time.strftime("%H:%M:%S")) + "\n")
fp.write ("-------------------------------" + "\n" + "\n")
fp.close()



