-- View som legger fotodato på vertikalbildedekning
-- En tilfeldig dato hvis dekningen har flere fotodatoer
-- Nødvendig for å kunne velge vertikalbildedekning på fotodato 

CREATE OR REPLACE VIEW vertikalbilde.v_vertikalbildedekning AS 
 SELECT dekning.objid,
  dekning.objtype,
  dekning.oppdragsnavn,
  dekning.dekningsnummer,
  dekning.bakkeopplosning,
  dekning.bildefilformat,
  dekning.bildemalestokk,
  dekning.bitsprpixel,
  dekning.flyfirma,
  dekning.oppdragsgiver,
  dekning.aerotriangulering,
  dekning.orienteringsdata,
  dekning.orienteringsmetode,
  dekning.lengdeoverlapp,
  dekning.sideoverlapp,
  dekning.prosjektrapportlink,
  dekning.skanneropplosning,
  dekning.omrade,  
  fotodato.fotodato,
  fotodato.vertikalbildedekningfk
FROM 
  vertikalbilde.vertikalbildedekning dekning, 
  (SELECT DISTINCT ON (vertikalbildedekningfk) * FROM vertikalbilde.fotodato) fotodato
WHERE fotodato.vertikalbildedekningfk = dekning.objid;
