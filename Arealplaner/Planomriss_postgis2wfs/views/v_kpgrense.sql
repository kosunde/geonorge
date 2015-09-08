create or replace view planomriss.v_kpgrense as
select kpgrense.objtype,
    kpgrense.grense,
    sosi_objekt_planlinjer_kp.forstedigitaliseringsdato,
    sosi_objekt_planlinjer_kp.noyaktighet,
    sosi_objekt_planlinjer_kp.malemetode,
    sosi_objekt_planlinjer_kp.synbarhet,
    sosi_objekt_planlinjer_kp.oppdateringsdato
   from planomriss.kpgrense
     join planomriss.sosi_objekt_planlinjer_kp on kpgrense.objid = sosi_objekt_planlinjer_kp.kpgrense_fk;