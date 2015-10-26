# -*- coding: utf-8 -*-

import json
# import pdb
import codecs
import nvdb
import datetime
import numpy as np
from shapely.wkt import loads
from shapely.geometry import Point, LineString
from pyproj import Proj, transform
from copy import deepcopy


# Data container for geojson. GLOBAL variable
ulykker = {
                "type": "FeatureCollection",
                 "crs": {
                            "type": "name",
                            "properties": {
                                  "name": "urn:ogc:def:crs:EPSG::25833"
                              }
                    },
                "features": [ ]
            }

ulykker_feilUTM = deepcopy( ulykker)

def fylker():

    fylker = [ '01', '02', '03', '04', '05', '06',
                '07', '08',
                '09', '10', '11', '12', '14', '15',
                '16', '17', '18', '19', '20' ]

    for fy in fylker:
        hentKommuner( fy)

def hentKommuner( fylke ):

    # Data container for geojson
    global ulykker
    global ulykker_feilUTM

    kommuner = nvdb.query( '/omrader/kommuner' )

#    nyeulykker = hentUlykker( '2017' )
#    ulykker['features'].append( nyeulykker)
#    test = [ { 'nummer' : 101}, { 'nummer' : 105 } ]

#    fylke = '08'
    fylkenr = int( fylke) * 100
    print "Henter fylke", fylke


    for kom in kommuner['kommuner']:
#    for kom in test:

        if fylkenr <= int( kom['nummer']) <= fylkenr+99:
#            print 'Henter kommune', kom['nummer']

            hentUlykker( kom['nummer'])

    # Lagrer resultater
    fileDir = '/home/jansimple/mysite/static/myresults/'
    fileUtm = fileDir + 'ulykker_feilUTM' + fylke + '.geojson'
    fileUl = fileDir + 'ulykker_feil' + fylke + '.geojson'

    with open(fileUtm, 'w') as outfile:
        json.dump(ulykker_feilUTM, outfile)

    with open(fileUl, 'w') as outfile:
        json.dump(ulykker, outfile)

    print 'Skrev til: ', fileUtm
    print 'Skrev til: ', fileUl



def hentUlykker( kommuneNr):

    global ulykker
    global ulykker_feilUTM

    # Henter kun ulykker med egengeometri, per kommune
    ulFilter =  [{
    			"type": "Geometri, punkt",
    			"operator": "!=",
    			"verdi": None
    		}]
    lokasjon = {"kommune": [ kommuneNr ]}

    # Jukser litt for å få ulykker med feil UTM sone å jobbe/teste med:
    # lokasjon = {"bbox": "382914,6480154,844856,6705029"} # Sørøst i Sverige
    # lokasjon = {"bbox": "-547717,7584617,376168,8034367"} # Utenfor Lofoten



    ulSok = [{"id":"570","antall":"100000","filter": ulFilter}]
#     fylker = nvdb.query( '/omrader/fylker' )
#     resultat = [ [ 'fylke', 'bruNummer', 'navn', 'NVDB Id' ]]



    ulData = nvdb.query_search( ulSok , lokasjon )

    # Mulige projeksjoner
    outProj = Proj(init='epsg:25833')
    inProjs = [ Proj(init='epsg:25832'), Proj(init='epsg:25834'),
                Proj(init='epsg:25835'), Proj(init='epsg:25836') ]

    # Tellere for antall ulykker som tilfredsstiller våre kriterier.
    countNyUTM = 0
    countUlykke = 0

    if ulData.antall > 0:

        for ul in ulData.data['resultater'][0]['vegObjekter']:
            ulObj = nvdb.Objekt( ul)
            referanselokasjon = ulObj.referanseLokasjonPunkt()

            # if ul['lokasjon']['vegReferanser'][0]['nummer'] != 99999:

            uldict = {

                        "type": "Feature",
                          "geometry": {
                            "type": "LineString",
                            "coordinates": []
                            },
                          "properties": {
                                'egenGeom' : str(ulObj.egenskap(5123)),
                                'refGeom'   : referanselokasjon['punktPaVegReferanseLinjeUTM33'],
                                'referansetekst' : referanselokasjon['visningsNavn'],
                                'nvdbObjId' :  ulObj.id,
                                'kommunenr'     : ul['lokasjon']['kommune']['nummer']
                            }
                    }


            # Sjekker avstand; loads er fra shapely-modulen
            p1 = loads( uldict['properties']['egenGeom'] )
            p2 = loads( uldict['properties']['refGeom'] )
            uldict['properties']['avstandRef2Egen'] = p1.distance(p2)

            # print p1.coords
            linje = LineString( [(p1.x, p1.y), (p2.x, p2.y)])
            uldict['geometry']['coordinates'] = list(linje.coords)

            # Skal ha egenskapsverdier for avstand referanse - egengeometri og logikk
            # for sjekk om grove avvik går opp med feil i UTMsone. (og et eget flagg for dette)

            minDistance = uldict['properties']['avstandRef2Egen']
            gmlDistance = minDistance
            reproj = False
            for inProj in inProjs:

                x3,y3 = transform(inProj,outProj,p1.x,p1.y)
                p3 = Point( x3, y3)
                newDist = p3.distance(p2)

                if newDist < minDistance:
                    reproj = True
                    srs = inProj.srs
                    minDistance = newDist
                    newP = p3

            uldict['properties']['reproject'] = reproj
            if reproj:
                uldict['properties']['fromProj'] = srs
                uldict['properties']['GMLavstandRef2Egen'] = gmlDistance
                uldict['properties']['avstandRef2Egen'] = minDistance
                uldict['properties']['newX'] = newP.x
                uldict['properties']['newY'] = newP.y

                linje = LineString( [(newP.x, newP.y), (p2.x, p2.y)])
                uldict['geometry']['coordinates'] = list(linje.coords)

                ulykker_feilUTM['features'].append( uldict)
                countNyUTM += 1
  #              print referanselokasjon['visningsNavn']

            else:
                if uldict['properties']['avstandRef2Egen'] > 5:
                    ulykker['features'].append( uldict)
                    countUlykke += 1
   #                 referanselokasjon['visningsNavn']

    print "Kommune ", kommuneNr, " : ",  ulData.antall, "ulykker hvorav ", \
            countUlykke, " > 5m avstand og ", countNyUTM, "i feil UTM sone"

    # print json.dumps( ulykker, indent=4)


if __name__=="__main__":
    fylker()
