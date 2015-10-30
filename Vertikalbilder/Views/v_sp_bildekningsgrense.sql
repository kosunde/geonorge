-- View som parer begrensninglinjene med polygonene de begrenser ut fra topologi
-- Gir også mulighet til å velge begrensningslinjer ut fra fotodato

CREATE OR REPLACE VIEW vertikalbilde.v_sp_bildedekningsgrense AS 
 SELECT grense.objid,
    grense.objtype,
    grense.malemetode,
    grense.grense,
    dato.fotodato AS fotodato,
    dato.vertikalbildedekningfk AS vertikalbildedekningfk
   FROM vertikalbilde.bildedekningsgrense grense,
    vertikalbilde.vertikalbildedekning dekning,
    vertikalbilde.fotodato dato
  WHERE st_touches(grense.grense, dekning.omrade) and dekning.objid = dato.vertikalbildedekningfk;