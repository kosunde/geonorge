CREATE OR REPLACE VIEW vertikalbilde.v_sp_bildedekningsgrense AS 
 SELECT grense.objid,
    grense.objtype,
    grense.malemetode,
    st_makevalid(grense.grense),
    dato.fotodato AS fotodato,
    dato.vertikalbildedekningfk AS vertikalbildedekningfk
   FROM vertikalbilde.bildedekningsgrense grense,
    vertikalbilde.vertikalbildedekning dekning,
    vertikalbilde.fotodato dato
  WHERE st_touches(grense.grense, dekning.omrade) and grense.objid = dato.vertikalbildedekningfk;