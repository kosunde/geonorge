#-------------------------------------------------------------------------------
# Name:        SetSOSIUnit
# Purpose:     Set SOSI unit based on geographic or projected coordinatesystem
#              based on EPSG code ['OUTPUT_EPSG_CODE']
#
# Author:      xgrimor
#
# Created:     21.08.2015
# Copyright:   (c) xgrimor 2015
# Licence:     <your licence>
#-------------------------------------------------------------------------------

import fme, pypyodbc, fmeobjects
from xml.etree import ElementTree as ET

logger = fmeobjects.FMELogFile()

#Read XML config file
configtree = ET.parse(fme.macroValues['CONFIG_FILE'])
configdoc = configtree.getroot()
sODBC = configdoc.find('pgODBCdriver').text

try:
#
# Set ODBC connection string. Driver is 'PostgreSQL ODBC Deriver(UNICODE)', rest is per parameters
#
    pgODBC  = 'DRIVER=' + sODBC + ';'
    pgODBC += 'SERVER=' + fme.macroValues['PG_HOST'] + ';'
    pgODBC += 'DATABASE=' + fme.macroValues['PG_DB'] + ';'
    pgODBC += 'UID=' + fme.macroValues['PG_USER'] + ';'
    pgODBC += 'PWD=' + fme.macroValues['PG_PWD']
#
# Define select versus epsg.epsg_coordinatereferencesystem
#
    SQLstm  = 'select coord_ref_sys_kind from epsg.epsg_coordinatereferencesystem where coord_ref_sys_code=' + fme.macroValues['OUTPUT_EPSG_CODE']
#
# Start connection and retreive coordinatsystem type:
#
    logger.logMessageString('pgODBC   = ' + pgODBC)
    conn = pypyodbc.connect(pgODBC)
    cur = conn.cursor()
    logger.logMessageString('SQLstm   = ' + SQLstm)
    cur.execute(SQLstm)
    type = cur.fetchone()[0]
    logger.logMessageString('type     = ' + type)
#
# Set SOSIunit according to type:
#  -> compound      -> 0.000001
#  -> engineering   -> 0.000001
#  -> geocentric    -> 0.000001
#  -> geographic 2D -> 0.000001
#  -> geographic 3D -> 0.000001
#  -> projected     -> 0.01
#  -> vertical      -> 0.01
#     otherwise     -> 0.01
#
    if type == 'compound':
        SOSIunit = '0.000001'
    elif type == 'engineering':
        SOSIunit = '0.000001'
    elif type == 'geocentric':
        SOSIunit = '0.000001'
    elif type == 'geographic 2D':
        SOSIunit = '0.000001'
    elif type == 'geographic 3D':
        SOSIunit = '0.000001'
    elif type == 'projected':
        SOSIunit = '0.01'
    elif type == 'vertical':
        SOSIunit = '0.01'
    else:
        SOSIunit = '0.01'
except:
#
# If we're unable to fetch type from epsg.epsg_coordinatereferencesystem,
# set SOSIunit = 0.01 (same as projected - GeoSOSIPro default)
#
    SOSIunit = '0.01'

logger.logMessageString('SOSIunit = ' + SOSIunit)

return SOSIunit