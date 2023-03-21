--zad1
ALTER TABLE projekty
	ADD (
		CONSTRAINT pk_projekty PRIMARY KEY (id_projektu),
		CONSTRAINT uk_projekty UNIQUE (opis_projektu),
		CONSTRAINT chk_daty CHECK (data_rozpoczecia < data_zakonczenia),
		CONSTRAINT chk_funduszu CHECK (fundusz < 0 OR fundusz = NULL)
		)
	MODIFY 
		opis_projektu NOT NULL;

SELECT	
		b.CONSTRAINT_NAME,		
		CONSTRAINT_TYPE AS C_TYPE,
		SEARCH_CONDITION,
		COLUMN_NAME
FROM	
		USER_CONSTRAINTS a
	LEFT JOIN
		USER_CONS_COLUMNS b
	ON 
		a.CONSTRAINT_NAME = b.CONSTRAINT_NAME AND a.TABLE_NAME = b.TABLE_NAME;

--zad2
INSERT INTO PROJEKTY (
    OPIS_PROJEKTU,
    DATA_ROZPOCZECIA,
    DATA_ZAKONCZENIA,
    FUNDUSZ
) VALUES (
    'Indeksy bitmapowe',
    '2015-04-12',
    '2016-09-30',
    40000
);

--ORA-00001: naruszono więzy unikatowe (BIO130528.UK_PROJEKTU)

--zad3

CREATE TABLE przydzialy	
(						
	id_projektu 	NUMBER(4) NOT NULL,									
	
	nr_pracownika 	NUMBER(6) NOT NULL,
									
	od 				DATE DEFAULT SYSDATE,	

	do 				DATE,

	stawka 			NUMBER(7,2),								

	rola			VARCHAR(20CHAR),								
  	
	CONSTRAINT pk_przydzialy 			
  									PRIMARY KEY(id_projektu, nr_pracownika),
	CONSTRAINT chk_przydzialy_daty 		
  									CHECK(do > od),
  	CONSTRAINT chk_przydzialy_rola 
									CHECK(rola IN ("KIERUJĄCY", "ANALITYK", "PROGRAMISTA")),
  	CONSTRAINT chk_przydzialy_stawka 
									CHECK(stawka > 0),
	CONSTRAINT fk_przydzialy_01 
									FOREIGN KEY (id_projektu)
										REFERENCES projekty(id_projektu),											
  	CONSTRAINT fk_przydzialy_02
  									FOREIGN KEY (nr_pracownika)
  										REFERENCES pracownicy(id_prac)									
);

--zad4
INSERT INTO przydzialy (id_projektu, nr_pracownika, od, do, stawka, rola)
VALUES 
(
  (SELECT id_projektu FROM projekty WHERE opis_projektu IN ('Indeksy bitmapowe')),
  170,
  '1999-04-10',
  '1999-05-10',
  1000,
  'KIERUJĄCY'
);
INSERT INTO przydzialy (id_projektu, nr_pracownika, od, stawka, rola)
VALUES 
(
  (SELECT id_projektu FROM projekty WHERE opis_projektu IN ('Indeksy bitmapowe')),
  140,
  '2000-12-01',  
  1500,
  'ANALITYK'
);
INSERT INTO przydzialy (id_projektu, nr_pracownika, od, stawka, rola)
VALUES 
(
  (SELECT id_projektu FROM projekty WHERE opis_projektu IN ('Indeksy bitmapowe')),
  140,
  '2015-09-14',  
  2500,
  'KIERUJĄCY'
);

--zad5
ALTER TABLE przydzialy 
ADD godziny NUMBER(4) NOT NULL;
--ORA-01758: aby dodać obowiązkową kolumnę (NOT NULL) tabela musi być pusta

--zad6
ALTER TABLE przydzialy 
ADD godziny NUMBER(4);

UPDATE przydzialy
SET godziny = 420;

ALTER TABLE przydzialy 
MODIFY godziny NUMBER(4) NOT NULL;

--zad7
ALTER TABLE projekty 
DISABLE CONSTRAINT uk_projektu;

SELECT
    CONSTRAINT_NAME,
    STATUS
FROM
    USER_CONSTRAINTS
WHERE
    CONSTRAINT_NAME IN ( 'uk_projekty' );

 --zad8
 INSERT INTO projekty (
    opis_projektu,
    data_rozpoczecia,
    data_zakonczenia,
    fundusz
) VALUES (
    'Indeksy bitmapowe',
    '2015-04-12',
    '2016-09-30',
    40000
);
SELECT * FROM projekty;
--TAK

--zad9
ALTER TABLE projekty 
ENABLE CONSTRAINT uk_projekty;
--ORA-02299: nie można zweryfikować poprawności (BIO130528.UK_PROJEKTU) - znaleziono zduplikowane klucze

--zad10
UPDATE projekty
SET
    opis_projektu = 'inne indeksy'
WHERE
    fundusz IN ( 40000 );

ALTER TABLE projekty 
ENABLE CONSTRAINT uk_projekty;
--TAK

--zad11
ALTER TABLE projekty 
MODIFY
    opis_projektu VARCHAR(10char);
--NIE
--ORA-01441: nie można zmniejszyć długości kolumny, ponieważ niektóre wartości są zbyt duże

--zad12
DELETE FROM projekty
WHERE
    opis_projektu = 'Sieci kręgoslupowe';
--ORA-02292: naruszono więzy spójności (BIO130528.FK_PRZYDZIALY_01) - znaleziono rekord podrzędny

--zad13
ALTER TABLE przydzialy DROP CONSTRAINT fk_przydzialy_01;

ALTER TABLE przydzialy
    ADD CONSTRAINT fk_przydzialy_01 FOREIGN KEY ( id_projektu )
        REFERENCES projekty ( id_projektu ) ON DELETE CASCADE;

DELETE FROM projekty
WHERE
    opis_projektu = 'Sieci kręgoslupowe';

SELECT * FROM projekty;
SELECT * FROM przydzialy;

--zad14
DROP TABLE projekty CASCADE CONSTRAINTS;

--zad15 
DROP TABLE przydzialy;
DROP TABLE projekty_kopia;
SELECT
    TABLE_NAME
FROM
    USER_TABLES;