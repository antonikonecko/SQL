--zad1

-- FETCH FIRST	--
SELECT	nazwisko, 
       	placa_pod
FROM	pracownicy
ORDER BY placa_pod DESC
FETCH FIRST 3 ROWS ONLY;

-- ROWNUM --
SELECT	nazwisko,
       	placa_pod
FROM 
(
	SELECT	nazwisko,
	      	placa_pod
    FROM 	pracownicy
    ORDER BY placa_pod DESC
)
WHERE ROWNUM <=3;

--zad2

-- OFFSET --
SELECT 	nazwisko,
		placa_pod
FROM 	pracownicy
ORDER BY placa_pod DESC
OFFSET 5 ROWS;


-- ROWNUM --
SELECT 	nazwisko, 
		placa_pod
FROM 
(
	SELECT 	nazwisko,
			placa_pod 
	FROM 	pracownicy
	ORDER BY placa_pod DESC
) 
WHERE ROWNUM >=6

--zad3

WITH srednia_placa AS 
(
	SELECT 	id_zesp, 
			avg(placa_pod) AS srednia 
	FROM 	pracownicy 
	GROUP BY 	id_zesp
)	
SELECT 	nazwisko,
		placa_pod, 
		(placa_pod - srednia) AS roznica
FROM 	pracownicy 
	NATURAL JOIN srednia_placa 
WHERE 	(placa_pod - srednia) > 0 
ORDER BY 	nazwisko;

--zad4

WITH lata AS 
(
	SELECT 	 EXTRACT(YEAR FROM zatrudniony) AS rok,
	 		 COUNT(*) AS liczba
	FROM 	 pracownicy 
	GROUP BY EXTRACT(YEAR FROM zatrudniony)
)
SELECT 	 * 
FROM 	 lata 
ORDER BY liczba DESC;

--zad5
WITH lata AS
(
	SELECT extract(year FROM zatrudniony) AS rok, 
	COUNT(*) AS liczba 
	FROM pracownicy 
	GROUP BY EXTRACT(YEAR FROM zatrudniony)
) 
SELECT 	 * 
FROM 	 lata 
ORDER BY liczba DESC;

--zad6
WITH asystenci AS 
(
	SELECT nazwisko, etat, id_zesp 
	FROM pracownicy 
	WHERE etat = 'ASYSTENT'
), 
	piotrowo AS 
(
	SELECT nazwa, adres, id_zesp 
	FROM zespoly 
	WHERE adres = 'PIOTROWO 3A'
) 

SELECT x.nazwisko, x.etat, y.nazwa, y.adres  
FROM asystenci x 
	NATURAL JOIN piotrowo y;

--zad7

WITH suma AS 
(
	SELECT 	 id_zesp, 
			 sum(placa_pod) AS maks_suma_plac 
	FROM 	 pracownicy 
	GROUP BY id_zesp
) 

SELECT 	nazwa, 
		maks_suma_plac
FROM 	suma 
	NATURAL JOIN  zespoly 
FETCH FIRST 1 ROW ONLY;

--zad8.1
WITH podwladny
(
	id_prac, 
	id_szefa, 
	nazwisko,
	pozycja_w_hierarchii
) 
AS 
(
	SELECT 	id_prac,
			id_szefa, 
			nazwisko, 1 AS pozycja_w_hierarchii
	FROM 	pracownicy 
	WHERE 	nazwisko = 'BRZEZINSKI' 
	UNION ALL SELECT x.id_prac,
					 x.id_szefa,
					 x.nazwisko,
					 pozycja_w_hierarchii+1 
	FROM 		podwladny y 
		JOIN 	pracownicy x 
			ON 	y.id_prac = x.id_szefa
)
SEARCH DEPTH FIRST BY nazwisko 
SET 	 MERGED 
SELECT 	 nazwisko,
		 pozycja_w_hierarchii 
FROM 	 podwladny 
ORDER BY MERGED;

--zad8.2
SELECT 	nazwisko,
	 	level AS pozycja_w_hierarchii 
FROM pracownicy 
CONNECT BY id_szefa = PRIOR id_prac 
	START WITH nazwisko = 'BRZEZINSKI' 
ORDER SIBLINGS BY nazwisko;

--zad9.1
WITH podwladny
(
	id_prac,
	id_szefa,
    nazwisko, 
    pozycja_w_hierarchii
) 
AS
(
 	SELECT 	id_prac,
 			id_szefa,
 			nazwisko,
 			1 AS pozycja_w_hierarchii
 	FROM 	pracownicy 
 	WHERE 	nazwisko = 'BRZEZINSKI' 
 	UNION ALL SELECT x.id_prac, 
 					x.id_szefa,
 					LPAD
 						(x.nazwisko, LENGTH(x.nazwisko) + 4 * (pozycja_w_hierarchii -1), '_'),
 					pozycja_w_hierarchii + 1 
 	FROM podwladny x 
 		JOIN pracownicy y 
 			ON y.id_prac = x.id_szefa
) 
SEARCH DEPTH FIRST BY nazwisko 

SET 	  MERGED 
SELECT   LPAD(nazwisko, LENGTH(nazwisko)+ 4 * (pozycja_w_hierarchii -1), '_') AS nazwisko,
 		  pozycja_w_hierarchii 
FROM 	  podwladny 
ORDER BY merged;

--zad9.2
SELECT  LPAD(nazwisko, length(nazwisko)+4*(LEVEL-1), '_') AS nazwisko,
 		LEVEL AS POZYCJA_W_HIERARCHII 
FROM 	pracownicy 

CONNECT BY 			id_szefa = PRIOR id_prac 
START WITH 			nazwisko = 'BRZEZINSKI' 
ORDER SIBLINGS BY 	nazwisko;