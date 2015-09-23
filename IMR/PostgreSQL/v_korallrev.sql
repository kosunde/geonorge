--------------------------------------------------------------------------------
-- Name       : v_korallrev
-- Purpose    : Inneholder informasjon fra korallrev koblet opp mot:
--               -> kommuneflate
--               -> fylkeflate
--              
--              Det gjøres en spatial-join mellom korallrevene(punkt) og
--               -> kommuneflate
--               -> fylkeflate
--              for at vi skal få med kommunenummer/navn og fylkesnummer/navn.
--              Dette brukes videre for "FANOUT" av eksportfiler baasert på
--              fylke eller kommune.
--
-- Author     : xgrimor
-- Created    : 23.09.2015
-- Coypyright : (c) xgrimor
-- Licence    : <your licence>
--------------------------------------------------------------------------------
CREATE OR REPLACE VIEW korallrev.v_sp_korallrev AS
SELECT rev.objid               as objid,
       rev.objtype             as objtype, 
       rev.obs_metode          as obs_metode, 
       rev.obs_start           as obs_start, 
       rev.obs_slutt           as obs_slutt, 
       rev.bmnatyp             as bmnatyp, 
       rev.bm_kildenavn        as bm_kildenavn, 
       rev.bm_kildetittel      as bm_kildetittel, 
       rev.bmkildtyp           as bmkildtyp, 
       rev.bm_kildeaar         as bm_kildeaar, 
       rev.dybde_min           as dybde_min, 
       rev.dybde_max           as dybde_max, 
       rev.posisjon            as posisjon, 
       rev.lokalid             as lokalid, 
       rev.navnerom            as navnerom, 
       rev.versjonid           as versjonid, 
       rev.verifiseringsdato   as verifiseringsdato, 
       rev.maalemetode         as maalemetode, 
       rev.noeyaktighet        as noeyaktighet, 
       rev.synbarhet           as synbarhet, 
       rev.maalemetodehoeyde   as maalemetodehoeyde, 
       rev.h_noeyaktighet      as h_noeyaktighet, 
       rev.max_avvik           as max_avvik, 
       rev.medium              as medium,
       rev.opphav              as opphav, 
       rev.noeyaktighetsklasse as noeyaktighetsklasse, 
       rev.produkt             as produkt,
       rev.versjon             as versjon,
       komm.kommuneid          as k_kommuneid,
       komm.navn               as k_navn,
       fylke.fylkeid           as f_fylkeid,
       fylke.navn              as f_navn
  FROM korallrev.korallrev rev,
       admingrense.fylkeflate fylke,
       admingrense.kommuneflate komm
 WHERE ST_Intersects(komm.geom, rev.posisjon)
   AND ST_Intersects(fylke.geom, rev.posisjon);
   
CREATE OR REPLACE VIEW korallrev.v_korallrev AS
SELECT objid,
       objtype, 
       obs_metode, 
       obs_start, 
       obs_slutt, 
       bmnatyp, 
       bm_kildenavn, 
       bm_kildetittel, 
       bmkildtyp, 
       bm_kildeaar, 
       dybde_min, 
       dybde_max, 
       posisjon, 
       lokalid, 
       navnerom, 
       versjonid, 
       verifiseringsdato, 
       maalemetode, 
       noeyaktighet, 
       synbarhet, 
       maalemetodehoeyde, 
       h_noeyaktighet, 
       max_avvik, 
       medium,
       opphav, 
       noeyaktighetsklasse, 
       produkt,
       versjon,
       k_kommuneid,
       k_navn,
       f_fylkeid,
       f_navn
  FROM korallrev.v_sp_korallrev
UNION
SELECT objid,
       objtype, 
       obs_metode, 
       obs_start, 
       obs_slutt, 
       bmnatyp, 
       bm_kildenavn, 
       bm_kildetittel, 
       bmkildtyp, 
       bm_kildeaar, 
       dybde_min, 
       dybde_max, 
       posisjon, 
       lokalid, 
       navnerom, 
       versjonid, 
       verifiseringsdato, 
       maalemetode, 
       noeyaktighet, 
       synbarhet, 
       maalemetodehoeyde, 
       h_noeyaktighet, 
       max_avvik, 
       medium,
       opphav, 
       noeyaktighetsklasse, 
       produkt,
       versjon,
       9999                   as k_kommuneid,
       'Uplassert-i-kommune'  as k_navn,
       99                     as f_fylkeid,
       'Uplassert-i-fylke'    as f_navn
  FROM korallrev.korallrev
 WHERE objid not in (select objid from korallrev.v_sp_korallrev);
 