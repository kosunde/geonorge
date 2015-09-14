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

--
-- Bytter ut alle tidligere "konverteringer" av ÆØÅ i tabell- og kolonnenavn:
--  -> Æ satt til AE endres til E
--  -> Ø satt til OE endres til O
--  -> Å satt til AA endres til A
--
-- NB: Det gjøres ingen endring i eksisterende kodetabeller i forhold til dette,
--     kun for de tabellene det vil refereres til i bruk av FME.
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
-- alter table turogfriluftsruter.annenrute_opparbeiding
--   add constraint annenrute_opparbeiding_annenrute_fk foreign key (objid) references turogfriluftsruter.annenrute (objid)
--    on update no action on delete no action;
-- Atributt: ..TILGJENGELIGHETSGRUPPE
create table turogfriluftsruter.annenrute_tilgjengelighetsgruppe (
objid                   integer,
tilgjengelighetsgruppe  integer,
unique ( objid, tilgjengelighetsgruppe)
);
-- alter table turogfriluftsruter.annenrute_tilgjengelighetsgruppe
--   add constraint annenrute_tilgjengelighetsgruppe_annenrute_fk foreign key (objid) references turogfriluftsruter.annenrute (objid)
--    on update no action on delete no action;

-- Tabell   : fotrute
-- Attributt: ..SFOTRUTETYPE
create table turogfriluftsruter.fotrute_sfotrutetype (
objid          integer          ,
sfotrutetype   character varying,
unique ( objid, sfotrutetype)
);
-- alter table turogfriluftsruter.fotrute_sfotrutetype
--   add constraint fotrute_sfotrutetype_fotrute_fk foreign key (objid) references turogfriluftsruter.fotrute (objid)
--    on update no action on delete no action;
-- Attributt: ..OPPARBEIDING
create table turogfriluftsruter.fotrute_opparbeiding (
objid         integer,
opparbeiding  integer,
unique ( objid, opparbeiding)
);
-- alter table turogfriluftsruter.fotrute_opparbeiding
--   add constraint fotrute_opparbeiding_fotrute_fk foreign key (objid) references turogfriluftsruter.fotrute (objid)
--    on update no action on delete no action;
-- Atributt: ..TILGJENGELIGHETSGRUPPE
create table turogfriluftsruter.fotrute_tilgjengelighetsgruppe (
objid                   integer,
tilgjengelighetsgruppe  integer,
unique ( objid, tilgjengelighetsgruppe)
);
-- alter table turogfriluftsruter.fotrute_tilgjengelighetsgruppe
--   add constraint fotrute_tilgjengelighetsgruppe_fotrute_fk foreign key (objid) references turogfriluftsruter.fotrute (objid)
--    on update no action on delete no action;

-- Tabell   : skiloype
-- Attributt: ..OPPARBEIDING
create table turogfriluftsruter.skiloype_opparbeiding (
objid         integer,
opparbeiding  integer,
unique ( objid, opparbeiding)
);
-- alter table turogfriluftsruter.skiloype_opparbeiding
--   add constraint skiloype_opparbeiding_skiloype_fk foreign key (objid) references turogfriluftsruter.skiloype (objid)
--    on update no action on delete no action;
-- Atributt: ..TILGJENGELIGHETSGRUPPE
create table turogfriluftsruter.skiloype_tilgjengelighetsgruppe (
objid                   integer,
tilgjengelighetsgruppe  integer,
unique ( objid, tilgjengelighetsgruppe)
);
-- alter table turogfriluftsruter.skiloype_tilgjengelighetsgruppe
--   add constraint skiloype_tilgjengelighetsgruppe_skiloype_fk foreign key (objid) references turogfriluftsruter.skiloype (objid)
--    on update no action on delete no action;

-- Tabell   : sykkelrute
-- Attributt: ..OPPARBEIDING
create table turogfriluftsruter.sykkelrute_opparbeiding (
objid         integer,
opparbeiding  integer,
unique ( objid, opparbeiding)
);
-- alter table turogfriluftsruter.sykkelrute_opparbeiding
--   add constraint sykkelrute_opparbeiding_sykkelrute_fk foreign key (objid) references turogfriluftsruter.sykkelrute (objid)
--    on update no action on delete no action;
-- Atributt: ..TILGJENGELIGHETSGRUPPE
create table turogfriluftsruter.sykkelrute_tilgjengelighetsgruppe (
objid                   integer,
tilgjengelighetsgruppe  integer,
unique ( objid, tilgjengelighetsgruppe)
);
-- alter table turogfriluftsruter.sykkelrute_tilgjengelighetsgruppe
--   add constraint sykkelrute_tilgjengelighetsgruppe_sykkelrute_fk foreign key (objid) references turogfriluftsruter.sykkelrute (objid)
--    on update no action on delete no action;

--
-- Det genereres automatisk en verdi i kolonnene OBJID. Dett fungerer
-- ikke i de tilfellene hvor vi har relaterte tabeller. Da må OBJID
-- telles opp i FME-workbenchen slik at vi har kontrolllen og kan lage 
-- koblingene.
--

-- Tabell: annenrute
alter table turogfriluftsruter.annenrute alter column objid drop default;
drop sequence turogfriluftsruter.annenrute_objid_seq;

-- Tabell: fotrute
alter table turogfriluftsruter.fotrute alter column objid drop default;
drop sequence turogfriluftsruter.fotrute_objid_seq;

-- Tabell: friluftslivtilrettelegging
alter table turogfriluftsruter.friluftslivtilrettelegging alter column objid drop default;
drop sequence turogfriluftsruter.friluftslivtilrettelegging_objid_seq;

-- Tabell: skiloype
alter table turogfriluftsruter.skiloype alter column objid drop default;
drop sequence turogfriluftsruter.skiloeype_objid_seq;

-- Tabell: sykkelrute
alter table turogfriluftsruter.sykkelrute alter column objid drop default;
drop sequence turogfriluftsruter.sykkelrute_objid_seq;

--
-- Enterprise Architect genererer NOT NULL constraints på en del
-- kolonner som er definert med multiplisitet [0..1] i
-- produktspesifikasjonen. Dette skaper problemer når vi kjører
-- FME modeller der det ikke finnes data i kilden. Attributtverdien vil
-- da nødvendigvis bli <NULL>.
-- NOT NULL constrainter på disse kolonnene må fjernes.
--

-- Tabell: annenrute
alter table turogfriluftsruter.annenrute alter column arutetype drop not null;

-- Tabell: fotrute

-- Tabell: friluftslivtilrettelegging

-- Tabell: skiloype
alter table turogfriluftsruter.skiloype alter column preparering drop not null;

-- Tabell: sykkelrute

--