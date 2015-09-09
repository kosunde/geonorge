--------------------------------------------------------------------------------
-- Filnavn: FiksTurOgFriluftsliv.sql
-- Formål : Rydder i skjema generert fra Enterprise Architect. Antakelig ligger
--          dette i EA, og vi må "korrigere" for dette:
--           -> ÆØÅ "konverteres" litt anderledes enn vi og GeoSOSIPro
--              forventer.
--           -> Det opprettes kodetabeller med fremmednøkler mot kolonner der
--              SOSI UML sier at kolonneverdien er valgfri å bruke, altså der
--              multiplisiteten står til [0..1]
-- Forfatter: Morten Grimnes, Geodata AS
-- Opprettet: 03.09.2015
--------------------------------------------------------------------------------

/*
--
-- Fjerner fremmednøkler der SOSI UML definerer multiplisitet lik [0..1] (valgfri verdi)
--

-- Tabell: fotrute:
alter table turogfriluftsruter.fotrute drop constraint fotrute_sfotrutetype_fkey;
alter table turogfriluftsruter.fotrute drop constraint fotrute_sesong_fkey;
alter table turogfriluftsruter.fotrute drop constraint fotrute_frilufteierforhold_fkey;
alter table turogfriluftsruter.fotrute drop constraint fotrute_belysning_fkey;
alter table turogfriluftsruter.fotrute drop constraint fotrute_rutefoelger_fkey;
alter table turogfriluftsruter.fotrute drop constraint fotrute_rutebredde_fkey;
alter table turogfriluftsruter.fotrute drop constraint fotrute_opparbeiding_fkey;
alter table turogfriluftsruter.fotrute drop constraint fotrute_rutebetydning_fkey;
alter table turogfriluftsruter.fotrute drop constraint fotrute_rutevanskelighetsgrad_fkey;
alter table turogfriluftsruter.fotrute drop constraint fotrute_underlagstype_fkey;
alter table turogfriluftsruter.fotrute drop constraint fotrute_tilgjengelighetsgruppe_fkey;
alter table turogfriluftsruter.fotrute drop constraint fotrute_rutetype_fkey;
alter table turogfriluftsruter.fotrute drop constraint fotrute_synbarhet_fkey;
alter table turogfriluftsruter.fotrute drop constraint fotrute_maalemetodehoeyde_fkey;
alter table turogfriluftsruter.fotrute drop constraint fotrute_kommune_fkey;
-- Usikre FK'er å slette
alter table turogfriluftsruter.fotrute drop constraint fotrute_maalemetode_fkey;

-- Tabell: skiloeype:
alter table turogfriluftsruter.skiloeype drop constraint skiloeype_spes_skiloeypetype_fkey;
alter table turogfriluftsruter.skiloeype drop constraint skiloeype_preparering_fkey;
alter table turogfriluftsruter.skiloeype drop constraint skiloeype_ryddebredde_fkey;
alter table turogfriluftsruter.skiloeype drop constraint skiloeype_frilufteierforhold_fkey;
alter table turogfriluftsruter.skiloeype drop constraint skiloeype_belysning_fkey;
alter table turogfriluftsruter.skiloeype drop constraint skiloeype_rutefoelger_fkey;
alter table turogfriluftsruter.skiloeype drop constraint skiloeype_rutebredde_fkey;
alter table turogfriluftsruter.skiloeype drop constraint skiloeype_opparbeiding_fkey;
alter table turogfriluftsruter.skiloeype drop constraint skiloeype_rutebetydning_fkey;
alter table turogfriluftsruter.skiloeype drop constraint skiloeype_rutevanskelighetsgrad_fkey;
alter table turogfriluftsruter.skiloeype drop constraint skiloeype_underlagstype_fkey;
alter table turogfriluftsruter.skiloeype drop constraint skiloeype_tilgjengelighetsgruppe_fkey;
alter table turogfriluftsruter.skiloeype drop constraint skiloeype_rutetype_fkey;
alter table turogfriluftsruter.skiloeype drop constraint skiloeype_synbarhet_fkey;
alter table turogfriluftsruter.skiloeype drop constraint skiloeype_maalemetodehoeyde_fkey;
alter table turogfriluftsruter.skiloeype drop constraint skiloeype_kommune_fkey;

-- Tabell: sykkelrute:
alter table turogfriluftsruter.sykkelrute drop constraint sykkelrute_spesialsykkelrutetype_fkey;
alter table turogfriluftsruter.sykkelrute drop constraint sykkelrute_trafikkbelastning_fkey;
alter table turogfriluftsruter.sykkelrute drop constraint sykkelrute_frilufteierforhold_fkey;
alter table turogfriluftsruter.sykkelrute drop constraint sykkelrute_belysning_fkey;
alter table turogfriluftsruter.sykkelrute drop constraint sykkelrute_rutefoelger_fkey;
alter table turogfriluftsruter.sykkelrute drop constraint sykkelrute_rutebredde_fkey;
alter table turogfriluftsruter.sykkelrute drop constraint sykkelrute_opparbeiding_fkey;
alter table turogfriluftsruter.sykkelrute drop constraint sykkelrute_rutebetydning_fkey;
alter table turogfriluftsruter.sykkelrute drop constraint sykkelrute_rutevanskelighetsgrad_fkey;
alter table turogfriluftsruter.sykkelrute drop constraint sykkelrute_underlagstype_fkey;
alter table turogfriluftsruter.sykkelrute drop constraint sykkelrute_tilgjengelighetsgruppe_fkey;
alter table turogfriluftsruter.sykkelrute drop constraint sykkelrute_rutetype_fkey;
alter table turogfriluftsruter.sykkelrute drop constraint sykkelrute_synbarhet_fkey;
alter table turogfriluftsruter.sykkelrute drop constraint sykkelrute_maalemetodehoeyde_fkey;
alter table turogfriluftsruter.sykkelrute drop constraint sykkelrute_kommune_fkey;

-- Tabell: annenrute:
alter table turogfriluftsruter.annenrute drop constraint annenrute_frilufteierforhold_fkey;
alter table turogfriluftsruter.annenrute drop constraint annenrute_belysning_fkey;
alter table turogfriluftsruter.annenrute drop constraint annenrute_rutefoelger_fkey;
alter table turogfriluftsruter.annenrute drop constraint annenrute_rutebredde_fkey;
alter table turogfriluftsruter.annenrute drop constraint annenrute_opparbeiding_fkey;
alter table turogfriluftsruter.annenrute drop constraint annenrute_rutebetydning_fkey;
alter table turogfriluftsruter.annenrute drop constraint annenrute_rutevanskelighetsgrad_fkey;
alter table turogfriluftsruter.annenrute drop constraint annenrute_underlagstype_fkey;
alter table turogfriluftsruter.annenrute drop constraint annenrute_tilgjengelighetsgruppe_fkey;
alter table turogfriluftsruter.annenrute drop constraint annenrute_rutetype_fkey;
alter table turogfriluftsruter.annenrute drop constraint annenrute_synbarhet_fkey;
alter table turogfriluftsruter.annenrute drop constraint annenrute_maalemetodehoeyde_fkey;
alter table turogfriluftsruter.annenrute drop constraint annenrute_kommune_fkey;

-- Tabeller: friluftslivtilrettelegging:
alter table turogfriluftsruter.friluftslivtilrettelegging drop constraint friluftslivtilrettelegging_synbarhet_fkey;
alter table turogfriluftsruter.friluftslivtilrettelegging drop constraint friluftslivtilrettelegging_maalemetodehoeyde_fkey;
alter table turogfriluftsruter.friluftslivtilrettelegging drop constraint friluftslivtilrettelegging_kommune_fkey;
*/

--
-- Bytter ut alle tidligere "konverteringer" av ÆØÅ i kolonnenavn:
--  -> Æ satt til AE endres til E
--  -> Ø satt til OE endres til O
--  -> Å satt til AA endres til A
--

-- Tabell: annenrute
alter table turogfriluftsruter.annenrute rename column rutefoelger to rutefolger;
alter table turogfriluftsruter.annenrute rename column maalemetode to malemetode;
alter table turogfriluftsruter.annenrute rename column noeyaktighet to noyaktighet;
alter table turogfriluftsruter.annenrute rename column maalemetodehoeyde to malemetodehoyde;
alter table turogfriluftsruter.annenrute rename column h_noeyaktighet to h_noyaktighet;

-- Tabeller: friluftslivtilrettelegging:
alter table turogfriluftsruter.friluftslivtilrettelegging rename column maalemetode to malemetode;
alter table turogfriluftsruter.friluftslivtilrettelegging rename column noeyaktighet to noyaktighet;
alter table turogfriluftsruter.friluftslivtilrettelegging rename column maalemetodehoeyde to malemetodehoyde;
alter table turogfriluftsruter.friluftslivtilrettelegging rename column h_noeyaktighet to h_noyaktighet;

-- Tabell: fotrute:
alter table turogfriluftsruter.fotrute rename column rutefoelger to rutefolger;
alter table turogfriluftsruter.fotrute rename column maalemetode to malemetode;
alter table turogfriluftsruter.fotrute rename column noeyaktighet to noyaktighet;
alter table turogfriluftsruter.fotrute rename column maalemetodehoeyde to malemetodehoyde;
alter table turogfriluftsruter.fotrute rename column h_noeyaktighet to h_noyaktighet;

-- Tabell: skiloeype
alter table turogfriluftsruter.skiloeype rename column spes_skiloeypetype to spes_skiloypetype;
alter table turogfriluftsruter.skiloeype rename column skoeytetrase to skoytetrase;
alter table turogfriluftsruter.skiloeype rename column rutefoelger to rutefolger;
alter table turogfriluftsruter.skiloeype rename column maalemetode to malemetode;
alter table turogfriluftsruter.skiloeype rename column noeyaktighet to noyaktighet;
alter table turogfriluftsruter.skiloeype rename column maalemetodehoeyde to malemetodehoyde;
alter table turogfriluftsruter.skiloeype rename column h_noeyaktighet to h_noyaktighet;
alter table turogfriluftsruter.skiloeype rename to skiloype;

-- Tabell: sykkelrute
alter table turogfriluftsruter.sykkelrute rename column rutefoelger to rutefolger;
alter table turogfriluftsruter.sykkelrute rename column maalemetode to malemetode;
alter table turogfriluftsruter.sykkelrute rename column noeyaktighet to noyaktighet;
alter table turogfriluftsruter.sykkelrute rename column maalemetodehoeyde to malemetodehoyde;
alter table turogfriluftsruter.sykkelrute rename column h_noeyaktighet to h_noyaktighet;

--
-- Bytter datatype på kolonne rutenr. SOSI UML sier H6, kilde er T(ett-eller-annet)
-- Setter til T255
--

-- Tabell: annenrute
alter table turogfriluftsruter.annenrute alter column rutenr type character varying;

-- Tabell: fotrute:
alter table turogfriluftsruter.fotrute alter column rutenr type character varying;

-- Tabell: skiloype
alter table turogfriluftsruter.skiloype alter column rutenr type character varying;

-- Tabell: sykkelrute
alter table turogfriluftsruter.sykkelrute alter column rutenr type character varying;

--
-- Må legge inn ukjente koder i en del oppslagstabeller
--

-- Tabell: maalemetode
insert into turogfriluftsruter.maalemetode values ('19','Ukjent_1');
insert into turogfriluftsruter.maalemetode values ('25','Ukjent_2');
insert into turogfriluftsruter.maalemetode values ('47','Ukjent_3');
commit;

-- Tabell: maalemetodehoeyde
insert into turogfriluftsruter.maalemetodehoeyde values ('0','Ukjent_1');
commit;

-- Tabell: spesialfotrutetype
insert into turogfriluftsruter.spesialfotrutetype values ('PG','Ukjent_1');
commit;

-- tabell: rutefoelger
insert into turogfriluftsruter.rutefoelger values ('JA','Ukjent_1');
commit;

-- Tabell: rutemerking
insert into turogfriluftsruter.rutemerking values ('UKJ','Ukjent_1');
commit;

--
-- ..KVALITET egenskapen nøyaktighet er i produktspekken lagt inn med
-- multiplisitet lik [1..1]. Dette er feil, den generelle beskrivelsen
-- av denne SOSI-egenskapen sier at multiplisiteten skal være [0..1].
-- Vi må korrigere dette ved å fjerne NOT NULL på denne kolonnen.
--

-- Tabell: annenrute
alter table turogfriluftsruter.annenrute alter column noyaktighet drop not null;

-- Tabell: friluftslivtilrettelegging
alter table turogfriluftsruter.friluftslivtilrettelegging alter column noyaktighet drop not null;

-- Tabell: fotrute
alter table turogfriluftsruter.fotrute alter column noyaktighet drop not null;

-- Tabell: skiloype
alter table turogfriluftsruter.skiloype alter column noyaktighet drop not null;

-- Tabell: sykkelrute
alter table turogfriluftsruter.sykkelrute alter column noyaktighet drop not null;

--
-- Attributten ..LINK er definert i produktspekken men den utelates under
-- generering av databasen.
-- 

-- Tabell: annenrute
alter table turogfriluftsruter.annenrute add column link character varying;

-- Tabell: friluftslivtilrettelegging
alter table turogfriluftsruter.friluftslivtilrettelegging add column link character varying;

-- Tabell: fotrute
alter table turogfriluftsruter.fotrute add column link character varying;

-- Tabell: skiloype
alter table turogfriluftsruter.skiloype add column link character varying;

-- Tabell: sykkelrute
alter table turogfriluftsruter.sykkelrute add column link character varying;

--
-- En del attributter har multiplisitet [0..*]. Disse klarer vi ikke å
-- legge inn i databasen ved å følge SOSI-modellen. Her er det bare en
-- attributt og denne er ad den datatypen ett element i listen har.
-- Vi må lage egne koblingstabeller for disse attributtene.
--

-- Tabell   : annenrute
-- Attributt: ..OPPARBEIDING
create table turogfriluftsruter.annenrute_opparbeiding (
objid         integer,
opparbeiding  integer,
unique ( objid, opparbeiding)
);
-- Atributt: ..TILGJENGELIGHETSGRUPPE
create table turogfriluftsruter.annenrute_tilgjengelighetsgruppe (
objid                   integer,
tilgjengelighetsgruppe  integer,
unique ( objid, tilgjengelighetsgruppe)
);

-- Tabell   : fotrute
-- Attributt: ..SFOTRUTETYPE
create table turogfriluftsruter.fotrute_sfotrutetype (
objid          integer          ,
sfotrutetype   character varying,
unique ( objid, sfotrutetype)
);
-- Attributt: ..OPPARBEIDING
create table turogfriluftsruter.fotrute_opparbeiding (
objid         integer,
opparbeiding  integer,
unique ( objid, opparbeiding)
);
-- Atributt: ..TILGJENGELIGHETSGRUPPE
create table turogfriluftsruter.fotrute_tilgjengelighetsgruppe (
objid                   integer,
tilgjengelighetsgruppe  integer,
unique ( objid, tilgjengelighetsgruppe)
);

-- Tabell   : skiloype
-- Attributt: ..OPPARBEIDING
create table turogfriluftsruter.skiloype_opparbeiding (
objid         integer,
opparbeiding  integer,
unique ( objid, opparbeiding)
);
-- Atributt: ..TILGJENGELIGHETSGRUPPE
create table turogfriluftsruter.skiloype_tilgjengelighetsgruppe (
objid                   integer,
tilgjengelighetsgruppe  integer,
unique ( objid, tilgjengelighetsgruppe)
);

-- Tabell   : sykkelrute
-- Attributt: ..OPPARBEIDING
create table turogfriluftsruter.sykkelrute_opparbeiding (
objid         integer,
opparbeiding  integer,
unique ( objid, opparbeiding)
);
-- Atributt: ..TILGJENGELIGHETSGRUPPE
create table turogfriluftsruter.sykkelrute_tilgjengelighetsgruppe (
objid                   integer,
tilgjengelighetsgruppe  integer,
unique ( objid, tilgjengelighetsgruppe)
);
