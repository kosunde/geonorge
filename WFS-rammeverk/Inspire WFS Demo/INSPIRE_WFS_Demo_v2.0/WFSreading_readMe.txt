Reading Safe Software's INSPIRE WFS
Jan 8, 2014

Use this URL:
http://inspire-safe-software.fmecloud.com:80/fmedatastreaming/INSPIRE/INSPIRE_WFS.fmw

*** Only query one theme at a time NamedPlace or CadastralParcels but not both at once ***

Sample GetFeature request:
http://inspire-safe-software.fmecloud.com:80/fmedatastreaming/INSPIRE/INSPIRE_WFS.fmw?SERVICE=WFS&VERSION=1.1.0&REQUEST=GetFeature&TYPENAME=CadastralParcel&MAXFEATURES=1111



CADASTRAL PARCELS QUERIES:

Parcels XML FILTERS:

<Filter><PropertyIsEqualTo><PropertyName>inspireId.Identifier.localId</PropertyName><Literal>136000AZ0063</Literal></PropertyIsEqualTo></Filter>

(Generates: `_whereQuery' has value `inspireId.Identifier.localId='136000AZ0063'')

<Filter><PropertyIsEqualTo><PropertyName>gml_id</PropertyName><Literal>id-ff84b9a7-5e8e-458b-8488-fd5d01d9ea29</Literal></PropertyIsEqualTo></Filter>

<Filter><PropertyIsEqualTo><PropertyName>nationalCadastralReference</PropertyName><Literal>66136000AZ0492</Literal></PropertyIsEqualTo></Filter>


Parcels SPATIAL QUERY:

0 to 5, 40 to 50 (W France)



GEOGRAPHIC NAMES QUERIES:

NamedPlace XML FILTERS:

<Filter><PropertyIsEqualTo><PropertyName>GeographicalName_language</PropertyName><Literal>Italian</Literal></PropertyIsEqualTo></Filter>

<Filter><PropertyIsEqualTo><PropertyName>geographicalname_spellingofname_text</PropertyName><Literal>Roma</Literal></PropertyIsEqualTo></Filter>


NamedPlace Spatial query:

0 to 5, 40 to 50 (W France)

0 to 25, 42 to 48 (should cover both Italy and S France so results overlap with parcels)



Can also get schemas from:

http://inspire.ec.europa.eu/schemas/cp/3.0/CadastralParcels.xsd
etc