# -*- coding: utf-8 -*-
#-------------------------------------------------------------------------------
# Name:        zipfiles.py
# Purpose:     Pakker filer i output folderen
#
# Author:      xsunknu
#
# Created:     18.09.2015
# Copyright:   (c) xsunknu 2015
# Licence:     <your licence>
#-------------------------------------------------------------------------------

import sys, os, zipfile

def zip(sosifile, zfile):
    from os.path import basename

    # Lager korresponderende zip-fil av SOSI-fil
    if os.path.isfile(zfile):
        os.remove(zfile)

    zf = zipfile.ZipFile(zfile, "w", zipfile.ZIP_DEFLATED)

    # Ønsker ikke full sti inn i ZIP-filen
    arcname = basename(sosifile)

    # ZIP-formatet støtter ikke non-ascii tegn
    # Erstatter AØÅæøå med ascii-tegn
    arcname = arcname.replace('\xc6', 'E')
    arcname = arcname.replace('\xd8', 'O')
    arcname = arcname.replace('\xc5', 'A')
    arcname = arcname.replace('\xe6', 'e')
    arcname = arcname.replace('\xf8', 'o')
    arcname = arcname.replace('\xe5', 'a')

    zf.write(sosifile, arcname)
    zf.close()
    os.remove(sosifile)

    return

def main():

    # Outputfolder er eneste argument
    path = sys.argv[1]

    for dirpath, dnames, fnames in os.walk(path):
        for f in fnames:
            if f.endswith(".sos"):
                # Scanner gjennom alle SOSI-filer
                sosifile = os.path.join(path, f)
                zfile = os.path.splitext(sosifile)[0] + '.zip'
                if os.path.isfile(zfile):

                    # Korresponderende ZIP-fil finnes, sjekker timestamps
                    sositstamp = os.stat(sosifile).st_mtime
                    ziptstamp = os.stat(zfile).st_mtime

                    if sositstamp > ziptstamp:
                        # SOSI-fil er nyere enn ZIP-fila, ZIP-fila oppdateres
                        # SOSI-fila slettes
                        try:
                            zip(sosifile, zfile)
                        except:
                            print 'Kunne ikke pakke: ' + sosifile
                    else:
                        # SOSI-fila er eldre enn ZIP-fila
                        # SOSI-fila slettes
                        try:
                            os.remove(sosifile)
                        except:
                            print 'Kunne ikke slette: ' + sosifile
                else:
                    # ZIP-fila eksisterer ikke og lages
                    # SOSI-fila slettes
                    try:
                        zip(sosifile, zfile)
                    except:
                        print 'Kunne ikke pakke: ' + sosifile


if __name__ == '__main__':
    main()
