--zad1
INSERT INTO pracownicy (id_prac, nazwisko, etat, id_szefa, zatrudniony, placa_pod, placa_dod, id_zesp)
SELECT 250, 'KOWALSKI', 'ASYSTENT', NULL, '2015-01-13', 1500, NULL, 10 FROM DUAL
UNION ALL
SELECT 260, 'ADAMSKI', 'ASYSTENT', NULL, '2014-09-10', 1500, NULL, 10 FROM DUAL
UNION ALL
SELECT 270, 'NOWAK', 'ADIUNKT', NULL, '1990-05-01', 2050, 540, 20 FROM DUAL;

SELECT 	* 
FROM 	pracownicy 
WHERE 	id_prac IN (250, 260, 270)

--zad2
UPDATE 	pracownicy
SET 	placa_pod = placa_pod * 1.1, 
		placa_dod = NVL2(placa_dod, placa_dod * 1.2, 100)
WHERE 	id_prac IN (250, 260, 270)

SELECT 	* 
FROM	pracownicy 
WHERE 	id_prac IN (250, 260, 270)

--zad3
INSERT INTO zespoly (id_zesp, nazwa, adres)
VALUES	(60, 'BAZY DANYCH', 'PIOTROWO 2');
SELECT 	* 
FROM 	zespoly 
WHERE 	id_zesp = 60;

--zad4
UPDATE 	pracownicy
SET 	id_zesp = 
(
	SELECT id_zesp
	FROM zespoly
	WHERE nazwa = 'BAZY DANYCH'
)
WHERE 	id_prac IN (250, 260, 270);

SELECT	*
FROM 	pracownicy 
WHERE 	id_zesp = 60;

--zad5
UPDATE 	pracownicy
SET 	id_szefa = 
(
	SELECT id_prac 
	FROM pracownicy 
	WHERE nazwisko = 'MORZY'
)
WHERE 	id_zesp = 60;

SELECT 	* 
FROM	pracownicy 
WHERE	id_szefa = 
(
	SELECT 	id_prac
	FROM 	pracownicy 
	WHERE 	nazwisko = 'MORZY'
);

--zad6
DELETE 
FROM	zespoly
WHERE 	nazwa = 'BAZY DANYCH';
--nie
--ORA-02292: naruszono więzy spójności 
--(BIO130528.FK_ID_ZESP) - znaleziono rekord podrzędny

--zad7
DELETE 
FROM 	pracownicy
WHERE 	id_zesp = 
(
	SELECT id_zesp 
	FROM zespoly
	WHERE nazwa = 'BAZY DANYCH'
);

DELETE 
FROM	zespoly
WHERE 	nazwa = 'BAZY DANYCH';

--zad8
SELECT 	nazwisko, 
		placa_pod, 
		(
			SELECT 0.1 * AVG(placa_pod) 
			FROM pracownicy x 
			WHERE x.id_zesp = y.id_zesp
		) 
		AS podwyzka 

FROM	pracownicy y 
ORDER BY 	nazwisko;


--zad9
UPDATE 	pracownicy y
SET 	placa_pod = placa_pod + 
(
	SELECT 	0.1 * AVG(placa_pod) 
	FROM	pracownicy x 
	WHERE	x.id_zesp = y.id_zesp
);

SELECT 	nazwisko,
 		placa_pod 
FROM 	pracownicy
ORDER BY 	nazwisko;


--zad10
SELECT 	* 
FROM 	pracownicy
WHERE 	placa_pod =
(
	SELECT 	MIN(placa_pod) 
	FROM 	pracownicy
);

--zad11
UPDATE	pracownicy
SELECT 	placa_pod = ROUND((SELECT AVG(praca_pod) FROM pracownicy),2)
WHERE 	placa_pod =
	(
		SELECT	 MIN(placa_pod) 
		FROM	 pracownicy
	);

--zad12
SELECT 	nazwisko, 
		placa_dod
FROM 	pracownicy
WHERE 	id_zesp = 20;

UPDATE	 pracownicy
SET 	placa_dod = 
	(
		SELECT 	AVG(placa_pod)
		FROM 	pracownicy
		WHERE 	id_szefa = 
		(
			SELECT	id_prac 
			FROM	pracownicy 
			WHERE 	nazwisko = 'MORZY'
		)
	)
WHERE 	id_zesp = 20;


SELECT	nazwisko,
		placa_dod
FROM 	pracownicy
WHERE	id_zesp = 20;

--zad13
UPDATE 
	(
		SELECT	nazwa,
				placa_pod 
		FROM 	pracownicy 
		JOIN 	zespoly 
			USING 	(id_zesp)
		WHERE 	nazwa = 'SYSTEMY ROZPROSZONE'
	)
SET		placa_pod = placa_pod * 1.25

--zad14
SELECT 	* 
FROM
	(
		SELECT 	p.nazwisko AS pracownik,
		 		s.nazwisko AS szef
		FROM 	pracownicy p 
		JOIN 	pracownicy s
			ON p.id_szefa = s.id_prac
	)
WHERE 	szef = 'MORZY';

DELETE
FROM
	(
		SELECT 	p.nazwisko AS pracownik,
				s.nazwisko AS szef
		FROM 	pracownicy p 
		JOIN 	pracownicy s
			ON 	p.id_szefa = s.id_prac
	)
WHERE 	szef = 'MORZY';

--zad15
SELECT 	* 
FROM	pracownicy

--zad16
CREATE SEQUENCE prac_seq START WITH 300 INCREMENT BY 10;

--zad17
INSERT INTO pracownicy (id_prac, nazwisko, etat, placa_pod)
VALUES 	(prac_seq.NEXTVAL,'Trabczynski', 'STAZYSTA', 1000);

SELECT	*
FROM	pracownicy 
WHERE 	nazwisko = 'Trabczynski';

--zad18
UPDATE 	pracownicy
SET 	placa_dod = prac_seq.CURRVAL
WHERE 	nazwisko = 'Trabczynski';

SELECT 	* 
FROM 	pracownicy
WHERE 	nazwisko = 'Trabczynski';

--zad19
DELETE 
FROM 	pracownicy
WHERE 	nazwisko = 'Trabczynski';

--zad20
CREATE SEQUENCE mala_seq START WITH 1 INCREMENT BY 1 MAXVALUE 10;
SELECT 	mala_seq.NEXTVAL 
FROM 	DUAL;
--ORA-02287: w tym miejscu numer sekwencji jest niedozwolony

--zad21 
DROP SEQUENCE 	mala_seq;