--zad1
CREATE VIEW asystenci (
    nazwisko,
    placa,
    staz
) AS
    SELECT
        nazwisko,
        placa_pod + placa_dod,
        ( DATE '2021-01-01' - zatrudniony ) YEAR TO MONTH
    FROM
        pracownicy;

SELECT
    nazwisko,
    placa,
    staz
FROM
    asystenci
ORDER BY
    nazwisko;

 --zad2
CREATE VIEW place (
    id_zesp,
    srednia,
    minimum,
    maximum,
    fundusz,
    l_pensji,
    l_dodatkow
) AS
    SELECT
        id_zesp,
        AVG(placa_pod + placa_dod),
        MIN(placa_pod + placa_dod),
        MAX(placa_pod + placa_dod),
		SUM(placa_pod + placa_dod),
        COUNT(placa_pod),
        COUNT(placa_dod)
    FROM
        pracownicy
    GROUP BY
        id_zesp
	ORDER BY 
		id_zesp;

SELECT * FROM place;

--zad3
SELECT
    nazwisko,
    placa_pod,
    p.id_zesp
FROM
    pracownicy p
    JOIN place l ON p.id_zesp = l.id_zesp
WHERE
    p.placa_pod < ( l.srednia );

SELECT * FROM place;

--zad4
CREATE VIEW place_minimalne (
    id_prac,
    nazwisko,
    etat,
    placa_pod
) AS
    SELECT
        id_prac,
       	nazwisko,
		etat,
		placa_pod
    FROM
        pracownicy
	WHERE
		placa_pod < 700
	WITH CHECK OPTION CONSTRAINT za_wysoka_placa;

--zad5
UPDATE place_minimalne
SET placa_pod = 800 WHERE nazwisko = 'HAPKE';
--ORA-01402: naruszenie klauzuli WHERE dla perspektywy z WITH CHECK OPTION

--zad6
CREATE VIEW prac_szef (
    id_prac,
    id_szefa,
    pracownik,
    etat,
    szef
) AS
    SELECT
        p.id_prac,
        p.id_szefa,
        p.nazwisko,
        p.etat,
        q.nazwisko
    FROM
        pracownicy  p
        LEFT OUTER JOIN pracownicy q ON p.id_szefa = q.id_prac;

--zad7
CREATE VIEW zarobki (
    id_prac,
    nazwisko,
    etat,
    placa_pod
) AS
    SELECT
        p.id_prac,
        p.nazwisko,
        p.etat,
        p.placa_pod
    FROM
        pracownicy  p
        LEFT OUTER JOIN pracownicy  q ON p.id_szefa = q.id_prac
    WHERE
        p.placa_pod < q.placa_pod
WITH CHECK OPTION CONSTRAINT mniej_niz_szef;

--zad8
SELECT
    *
FROM
    USER_UPDATABLE_COLUMNS
WHERE
    TABLE_NAME = 'PRAC_SZEF';