README

INSPIRE_WFS.fmw Version 2.0


OVERVIEW 

This workspace comprises an INSPIRE WFS when published to the FME Server data streaming service. 

The local server url is: 
http://localhost/fmedatastreaming/INSPIRE/INSPIRE_WFS.fmw

Safe Software's WFS demo server url is:
http://inspire-safe-software.fmecloud.com/fmedatastreaming/INSPIRE/INSPIRE_WFS.fmw  

It also supports writing INSPIRE GML using the XSD enabled GML writer available as of FME 2014

Accepts GetCapabilities, DescribeFeatureTypes and GetFeature requests either as GET URL or POST XML. Supports Filter expressions. 

When you send an HTTP POST to FME Server, it automatically overrides the input of this workspace with the post body. Note this means you have to have only one input and you assume that it is http post wfs xml 

If there is a POST then the post body is the WFS request such as the WFS GetFeatures XML with the embedded xml filter query. 

Supports FME Viewer and FME Data Inspector WFS clients. Should support third party WFS clients as well.



SETUP 

1. Modify workspace paths to make sure source database is accessible by FeatureReaders in the theme data extraction custom transformers (CadastralParcels and NamedPlace).

2. Update workspace parameters as needed (default theme, max features etc)

3. Set GML writer default parameters such as axis order, SRS etc 

4. Test run workspace using each of GetCapabilities, DescribeFeature and GetFeature request types to make sure correct output is generated 

5. Prepare for publishing by changing request back to GetCapabilities and removing any filters before saving. The goal is to have user friendly default parameter values. 

6. Publish to FME Server data streaming service. Upload all supporting resources: source_get.txt etc. Make sure both Text File writer and GML writer are published outputs.
Note xsds no longer need to be uploaded as they are included with the INSPIRE writer. If you wish to use a draft or newer schema than what is delivered with FME you will need to make sure these are uploaded.

7. Don't forget security settings in any WFS client.


BACKGROUND 

This is a WFS 'service broker' workspace. This just needs to be published to the data streaming service and will accept WFS GET or POST requests (GetCapabilities, 
DescribeFeature and GetFeatrue) and generate the appropriate responses as XML or GML data streams (GetCapabilities, Describe feature XML docs or GML 
features). Supports XMLfilters which is something our built in WFS did not do. Also, configured to support FME Data Inspector as a WFS client. Note that 
this requires FME Server 2014 or later to function. This is required to support the new GML writer. 

Presently a fairly basic example as it only supports 2 features type and one xml filter operation, though these can be extended fairly easily by following 
the example / approach laid out in this workspace. 

Any WxS such as WFS-T, WCS, WPS etc could be supported by a workspace like this. All that is required is to understand the web service protocol 
client / server requirements and configure accordingly. Could also be used to support SOS O&M (observation and measurements). Also, any complex XML / GML 
that needs to be transmitted via WFS can be supported by this, whether INSPIRE, AIXM, metadata/CSW etc. Of course, this still entails a lot of setup work 
depending on the service. But essentially this approach gives the user control to configure their web services how they want - essentially a custom web service.


HISTORY

By: Dean Hintz, Safe Software 
Created: Feb 25, 2013 
Last modified Apr 17, 2014
Current Version: 2.0

Apr 17, 2014
Added error handling. Bad feature request yields an xml error message.

Jan 8, 2014
Extensive modifications to support INSPIRE webinar:
Replaced GML writer with INSPIRE writer - xsds no longer need to be uploaded
Changed query database from SDF to PostGIS
Added CadastralParcels
Generalized theme handling to handle multiple themes. This required changes to GetCapabilities and DescribeFeatureType. Theme is now checked before providing response xsd.
Added MaxFeature parameter and handling
Created custom transformers for each INSPIRE theme to more clearly separate WFS message handling from GML data stream publication.
Updated Docs

Oct 10, 2013 
Updated to support FME 2014 (reimported destination feature type and made required schemaMappings in AttributeCopier)
Updated Docs 
Set SRS to 4326 (LL84 axis 2,1)
Corrected DescribeFeature to DescribeFeatureType 

Sept 6, 2013 
Disabled XML / Text File writer for GetFeature GML output and added new GML writer instead. 
New GML writer is based on GeographicalNames.xsd not XMLTemplater / templates. 
All I did was add the GML writer and then import the schema from GeographicalNames.xsd 


USAGE NOTES 

Make sure you publish with a non-xml source so that by default xml test will fail. 
Also make sure parameter Filter = "" and Request = GetCapabilities by default 
GeoServer uses TypeNames and FME Viewer client uses TypeName 


OUTSTANDING 

Currently only handles WFS 1.1 / GML 3.1.1. 
Only handles queries to one theme at a time.
Need to add support for WFS 2.0. This should be straight forward - just need to update template headers and use GML 3.2.1 geometry extraction. Needs to handle POST extents query
Invalid SDF query (column name doesnt exist) causes crash due to problem in open source library.


