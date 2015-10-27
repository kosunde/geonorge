CREATE OR REPLACE VIEW vertikalbilde.v_sp_bildedekningsgrense AS 
 SELECT bildedekningsgrense.objid,
    bildedekningsgrense.objtype,
    bildedekningsgrense.malemetode,
    bildedekningsgrense.grense,
    vertikalbidedekning.fotodato AS fotodato
   FROM vertikalbilde.bildedekningsgrense grense,
    vertikalbilde.vertikalbidedekning dekning
  WHERE st_touches(grense.grense, dekning.omrade);