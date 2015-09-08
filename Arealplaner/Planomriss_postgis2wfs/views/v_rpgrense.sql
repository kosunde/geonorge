create or replace view planomriss.v_rpgrense as
select rpgrense.objtype,
    rpgrense.grense,
    sosi_objekt_planlinjer_rp.forstedigitaliseringsdato,
    sosi_objekt_planlinjer_rp.noyaktighet,
    sosi_objekt_planlinjer_rp.malemetode,
    sosi_objekt_planlinjer_rp.synbarhet,
    sosi_objekt_planlinjer_rp.oppdateringsdato
   from planomriss.rpgrense
     join planomriss.sosi_objekt_planlinjer_rp on rpgrense.objid = sosi_objekt_planlinjer_rp.rpgrense_fk;