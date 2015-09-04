--------------------------------------------------------------------------------
-- Name       : v_akvakulturpunkt
-- Purpose    : Inneholder informasjon fra akvakulturpunkt koblet opp mot:
--               -> akvatillatelsesinformasjon
--               -> art
--               -> firmaeier
--              
--              Tabellene er relaterte ved at akvakulturpunkt.objid kobles mot:
--               -> akvatillatelsesinformasjon.tillatelsesinformasjonfk
--               -> art.artfk
--               -> firmaeier.firmaeierfk
--              Disse koblingene er satt opp i en null-til-amnge relasjon
--
-- Author     : xgrimor
-- Created    : 28.08.2015
-- Coypyright : (c) xgrimor
-- Licence    : <your licence>
--------------------------------------------------------------------------------
create or replace view akvakultur.v_akvakulturpunkt as
select punkt.objtype                      as objtype,
       punkt.akva_enhet                   as akva_enhet,
       punkt.akva_kapasitet               as akva_kapasitet,
       punkt.av_class                     as akva_av_class,
       punkt.plassering                   as akva_plassering,
       punkt.vannmiljo                    as akva_vannmiljo,
       punkt.kopidato                     as akva_kopidato,
       punkt.omraade                      as akva_omraade,
       tillatelse.lok_navn                as tillatelse_lok_navn,
       tillatelse.lok_nr                  as tillatelse_lok_nr,
       tillatelse.fiskebruknummerfylke    as tillatelse_fylke,
       tillatelse.fiskebruknummerkommune  as tillatelse_kommune,
       tillatelse.akvatillatelsesnummer   as tillatelse_nr,
       tillatelse.tillatelsesformaal      as tillatelse_formaal,
       tillatelse.tillatelsesstatus       as tillatelse_status,
       tillatelse.tillatelsestype         as tillatelse_type,
       tillatelse.tillatelsesurl          as tillatelse_url,
       tillatelse.kopidatp                as tillatelse_kopidato,
       art.art                            as art_art,
       art.kopidato                       as art_kopidato,
       eier.firma                         as firma_firma,
       eier.fiske_bedr_eier               as firma_eier,
       eier.adresse                       as firma_adresse,
       eier.postnr                        as firma_postnr,
       eier.postadresse                   as firma_postadresse,
       eier.telefonnr                     as firma_telefonnr,
       eier.kontaktperson                 as firma_kontaktperson,
       eier.kopidato                      as firma_kopidato
  from akvakultur.akvakulturpunkt as punkt
  left outer join akvakultur.akvatillatelsesinformasjon as tillatelse
    on tillatelse.tillatelsesinformasjonfk = punkt.objid
  left outer join akvakultur.art as art
    on art.artfk = punkt.objid
  left outer join akvakultur.firmaeier as eier
    on eier.firmaeierfk = punkt.objid;
