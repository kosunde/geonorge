--------------------------------------------------------------------------------
--                                                                            --
-- Fil      : TurOgFriluftsruter_v251_view.sql                                --
-- Funksjon : Oppretter views for basisdata for TurOgFriluftsruter basert på  --
--            PostgreSQL dump av QMS grunnlagsdatabase hos Kartverket.        --
--            Data opprettes med pg_restore og settes sammen til views        --
--            hvor datamodellen stemmer med UML-modellen fra produkt-         --
--            produktspesifikasjonen for Nasjonal database for tur- og        --
--            friluftsruter, versjon 2.5.1.                                   --
--                                                                            --
--            Alle view har fått kolonnenavn som stemmer overens med SOSI-    --
--            egenskapsnavn. Dette gjør mappingen i FME lettere.              --
--                                                                            --
-- Versjon  : 2.5.1_1                                                         --
-- Opprettet: Oktober 2015 av Morten Grimnes, Geodata AS                      --
-- Eier     : GeoNorge                                                        --
-- Endret   :                                                                 --
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--                                                                            --
-- Tabell : TMP_TFR_DUAL                                                      --
-- Vi må opprette en tabell med datatyper for tekst, hel- og flyttall og      --
-- "tomme" verdier (NULL). denne brukes for å definere datatyper for tomme    --
-- kolonner i viewet V_ANNENRUTE. Databasen inneholder ikke verdier, eller    --
-- kolonner for to datatyper og disse hentes herfra.                          --
--                                                                            --
--------------------------------------------------------------------------------
drop table if exists data.tmp_tfr_dual cascade;
create table data.tmp_tfr_dual (id          integer primary key,
                                tekst       varchar(10),
                                heltall     integer,
                                flyttall    double precision
                                );
insert into data.tmp_tfr_dual values(1,null, null, null);

--------------------------------------------------------------------------------
--                                                                            --
-- View : V_ANNENRUTE; View for objekttype AnnenRute.                         --
-- Kilde: Tabellene ANNENRUTE og RUTER_ANNENRUTE, koblet med KOBLING_ID       --
--                                                                            --
-- Viewet henter inn data for to "tomme" kolonner, ARUTETYPE og BELYSNING fra --
-- tabellen TMP_TFR_DUAL fordi kildetabellene ikke har disse attributtene.    --
-- Kolonnene som hentes, hentes med MAX() funksjonen for at vi bare skal      --
-- finne en verdi fra denne tabellen.                                         --
-- Det skal IKKE lages ekstra rader i viewet når vi laster inn disse dataene. --
--                                                                            --
--------------------------------------------------------------------------------
drop view if exists data.v_annenrute;
create or replace view data.v_annenrute as
select annenrute.objtype                     as objtype,
       dual.tekst                            as arutetype,
       ruter_annenrute.vedlikeholdsansvarlig as vedlikeh,
       annenrute.frilufteierforhold          as frilufteierforhold,
       dual.heltall                          as belysning,
       annenrute.rutemerking                 as rutemerking,
       annenrute.skilting                    as skilting,
       annenrute.rutefolger                  as rutefolger,
       annenrute.rutebredde                  as rutebredde,
       annenrute.opparbeiding                as opparbeiding,
       annenrute.rutebetydning               as rutebetydning,
       annenrute.rutevanskelighetsgrad       as rutevanskelighetsgrad,
       annenrute.underlagstype               as underlagstype,
       annenrute.lengde                      as lengde,
       annenrute.stigning                    as stigning,
       annenrute.tilgjengelighetsgruppe      as tilgjengelighetsgruppe,
       annenrute.rutetype                    as rutetype,
       ruter_annenrute.navn                  as navn,
       ruter_annenrute.rutenummer            as rutenr,
       annenrute.lokalid                     as lokalid,
       annenrute.datafangstdato              as datafangstdato,
       annenrute.oppdateringsdato            as oppdateringsdato,
       annenrute.malemetode                  as malemetode,
       annenrute.noyaktighet                 as noyaktighet,
       annenrute.synbarhet                   as synbarhet,
       annenrute.h_malemetode                as h_malemetode,
       annenrute.h_noyaktighet               as h_noyaktighet,
       annenrute.opphav                      as opphav,
       annenrute.kommune                     as komm,
       annenrute.informasjon                 as informasjon,
       annenrute.link                        as link,
       annenrute.geom                        as geom
  from data.annenrute as annenrute
  join data.ruter_annenrute as ruter_annenrute on annenrute.kobling_id = ruter_annenrute.kobling_id,
       data.tmp_tfr_dual as dual;
  
--------------------------------------------------------------------------------
--                                                                            --
-- View : V_FOTRUTE; View for objekttype Fotrute.                             --
-- Kilde: Tabellene FOTRUTE og RUTER_FOTRUTE, koblet med KOBLING_ID           --
--                                                                            --
-- Det er ingen spesielle hensyn å ta for dette viewet. Alle kolonner finnes  --
-- i kildetabellene.                                                          --
--                                                                            --
--------------------------------------------------------------------------------
drop view if exists data.v_fotrute;
create or replace view data.v_fotrute as
select fotrute.objekttype                    as objtype,
       fotrute.spesialfotrutetype            as sfotrutetype,
       fotrute.sesong                        as sesong,
       ruter_fotrute.vedlikeholdsansvarlig   as vedlikeh,
       fotrute.frilufteierforhold            as frilufteierforhold,
       fotrute.belysning                     as belysning,
       fotrute.rutemerking                   as rutemerking,
       fotrute.skilting                      as skilting,
       fotrute.rutefolger                    as rutefolger,
       fotrute.rutebredde                    as rutebredde,
       fotrute.opparbeiding                  as opparbeiding,
       fotrute.rutebetydning                 as rutebetydning,
       fotrute.rutevanskelighetsgrad         as rutevanskelighetsgrad,
       fotrute.underlagstype                 as underlagstype,
       fotrute.lengde                        as lengde,
       fotrute.stigning                      as stigning,
       fotrute.tilgjengelighetsgruppe        as tilgjengelighetsgruppe,
       fotrute.rutetype                      as rutetype,
       ruter_fotrute.navn                    as navn,
       ruter_fotrute.rutenummer              as rutenr,
       fotrute.lokalid                       as lokalid,
       fotrute.datafangstdato                as datafangstdato,
       fotrute.oppdateringsdato              as oppdateringsdato,
       fotrute.malemetode                    as malemetode,
       fotrute.noyaktighet                   as noyaktighet,
       fotrute.synbarhet                     as synbarhet,
       fotrute.h_malemetode                  as h_malemetode,
       fotrute.h_noyaktighet                 as h_noyaktighet,
       fotrute.opphav                        as opphav,
       fotrute.kommune                       as komm,
       fotrute.informasjon                   as informasjon,
       fotrute.link                          as link,
       fotrute.geom                          as geom
  from data.fotrute as fotrute
  join data.ruter_fotrute as ruter_fotrute on fotrute.kobling_id = ruter_fotrute.kobling_id;
  
--------------------------------------------------------------------------------
--                                                                            --
-- View : V_FRILUFTSLIVTILRETTELEGGING; View for objekttype                   --
--        FriluftslivTilrettelegging.                                         --
-- Kilde: Tabellen FRILUFTSLIVTILRETTELEGGING, ingen koblete tabeller.        --
--                                                                            --
-- Det er ingen spesielle hensyn å ta for dette viewet. Alle kolonner finnes  --
-- i kildetabellen.                                                          --
--                                                                            --
--------------------------------------------------------------------------------
drop view if exists data.v_friluftslivtilrettelegging;
create or replace view data.v_friluftslivtilrettelegging as
select friluftslivtilrettelegging.objtype                as objtype,
       friluftslivtilrettelegging.vedlikeholdsansvarlig  as vedlikeh,
       friluftslivtilrettelegging.fritilrettelegging     as fritilrettelegging,
       friluftslivtilrettelegging.lokalid                as lokalid,
       friluftslivtilrettelegging.datafangstdato         as datafangstdato,
       friluftslivtilrettelegging.oppdateringsdato       as oppdateringsdato,
       friluftslivtilrettelegging.malemetode             as malemetode,
       friluftslivtilrettelegging.noyaktighet            as noyaktighet,
       friluftslivtilrettelegging.synbarhet              as synbarhet,
       friluftslivtilrettelegging.h_malemetode           as h_malemetode,
       friluftslivtilrettelegging.h_noyaktighet          as h_noyaktighet,
       friluftslivtilrettelegging.opphav                 as opphav,
       friluftslivtilrettelegging.kommune                as komm,
       friluftslivtilrettelegging.informasjon            as informasjon,
       friluftslivtilrettelegging.link                   as link,
       friluftslivtilrettelegging.geom                   as geom
  from data.friluftslivtilrettelegging as friluftslivtilrettelegging;
  
--------------------------------------------------------------------------------
--                                                                            --
-- View : V_SKILOYPE; View for objekttype Skiløype.                           --
-- Kilde: Tabellene SKILOYPE og RUTER_SKILOYPE, koblet med KOBLING_ID         --
--                                                                            --
-- Det er ingen spesielle hensyn å ta for dette viewet. Alle kolonner finnes  --
-- i kildetabellene.                                                          --
--                                                                            --
--------------------------------------------------------------------------------
drop view if exists data.v_skiloype;
create or replace view data.v_skiloype as
select skiloype.objekttype                   as objtype,
       skiloype.spesialskiloypetype          as spes_skiloypetype,
       skiloype.preparering                  as preparering,
       skiloype.ryddebredde                  as ryddebredde,
       skiloype.antallskispor                as antallskispor,
       skiloype.skoytetrase                  as skoytetrase,
       ruter_skiloype.vedlikeholdsansvarlig  as vedlikeh,
       skiloype.frilufteierforhold           as frilufteierforhold,
       skiloype.belysning                    as belysning,
       skiloype.rutemerking                  as rutemerking,
       skiloype.skilting                     as skilting,
       skiloype.rutefolger                   as rutefolger,
       skiloype.rutebredde                   as rutebredde,
       skiloype.opparbeiding                 as opparbeiding,
       skiloype.rutebetydning                as rutebetydning,
       skiloype.rutevanskelighetsgrad        as rutevanskelighetsgrad,
       skiloype.underlagstype                as underlagstype,
       skiloype.lengde                       as lengde,
       skiloype.stigning                     as stigning,
       skiloype.tilgjengelighetsgruppe       as tilgjengelighetsgruppe,
       skiloype.rutetype                     as rutetype,
       ruter_skiloype.navn                   as navn,
       ruter_skiloype.rutenummer             as rutenr,
       skiloype.lokalid                      as lokalid,
       skiloype.datafangstdato               as datafangstdato,
       skiloype.oppdateringsdato             as oppdateringsdato,
       skiloype.malemetode                   as malemetode,
       skiloype.noyaktighet                  as noyaktighet,
       skiloype.synbarhet                    as synbarhet,
       skiloype.h_malemetode                 as h_malemetode,
       skiloype.h_noyaktighet                as h_noyaktighet,
       skiloype.opphav                       as opphav,
       skiloype.kommune                      as komm,
       skiloype.informasjon                  as informasjon,
       skiloype.link                         as link,
       skiloype.geom                         as geom
  from data.skiloype as skiloype
  join data.ruter_skiloype as ruter_skiloype on skiloype.kobling_id = ruter_skiloype.kobling_id;
  
--------------------------------------------------------------------------------
--                                                                            --
-- View : V_SYKKELRUTE; View for objekttype Sykkelrute.                       --
-- Kilde: Tabellene SYKKELRUTE og RUTER_SYKKELRUTE, koblet med KOBLING_ID     --
--                                                                            --
-- Det er ingen spesielle hensyn å ta for dette viewet. Alle kolonner finnes  --
-- i kildetabellene.                                                          --
--                                                                            --
--------------------------------------------------------------------------------
drop view if exists data.v_sykkelrute;
create or replace view data.v_sykkelrute as
select sykkelrute.objekttype                   as objtype,
       sykkelrute.spesialsykkelrutetype        as spesialsykkelrutetype,
       sykkelrute.trafikkbelastning            as trafikkbelastning,
       ruter_sykkelrute.vedlikeholdsansvarlig  as vedlikeh,
       sykkelrute.frilufteierforhold           as frilufteierforhold,
       sykkelrute.belysning                    as belysning,
       sykkelrute.rutemerking                  as rutemerking,
       sykkelrute.skilting                     as skilting,
       sykkelrute.rutefolger                   as rutefolger,
       sykkelrute.rutebredde                   as rutebredde,
       sykkelrute.opparbeiding                 as opparbeiding,
       sykkelrute.rutebetydning                as rutebetydning,
       sykkelrute.rutevanskelighetsgrad        as rutevanskelighetsgrad,
       sykkelrute.underlagstype                as underlagstype,
       sykkelrute.lengde                       as lengde,
       sykkelrute.stigning                     as stigning,
       sykkelrute.tilgjengelighetsgruppe       as tilgjengelighetsgruppe,
       sykkelrute.rutetype                     as rutetype,
       ruter_sykkelrute.navn                   as navn,
       ruter_sykkelrute.rutenummer             as rutenr,
       sykkelrute.lokalid                      as lokalid,
       sykkelrute.datafangstdato               as datafangstdato,
       sykkelrute.oppdateringsdato             as oppdateringsdato,
       sykkelrute.malemetode                   as malemetode,
       sykkelrute.noyaktighet                  as noyaktighet,
       sykkelrute.synbarhet                    as synbarhet,
       sykkelrute.h_malemetode                 as h_malemetode,
       sykkelrute.h_noyaktighet                as h_noyaktighet,
       sykkelrute.opphav                       as opphav,
       sykkelrute.kommune                      as komm,
       sykkelrute.informasjon                  as informasjon,
       sykkelrute.link                         as link,
       sykkelrute.geom                         as geom
  from data.sykkelrute as sykkelrute
  join data.ruter_sykkelrute as ruter_sykkelrute on sykkelrute.kobling_id = ruter_sykkelrute.kobling_id;

