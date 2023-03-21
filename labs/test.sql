--zad1
SELECT nazwisko, CONCAT(SUBSTR(etat,1,2),id_prac)AS kod FROM pracownicy
ORDER BY id_prac ASC;

--zad2
SELECT nazwisko, TRANSLATE(nazwisko, 'KLM', 'XXX') AS WOJNA_LITEROM
FROM pracownicy ORDER BY id_prac ASC;

--zad3
SELECT nazwisko FROM pracownicy
WHERE INSTR(SUBSTR(nazwisko,1,LENGTH(nazwisko)/2),'L',1)>0;

--zad4
SELECT nazwisko, ROUND(placa_pod + (placa_pod * 0.15), 0) AS PODWYZKA
FROM pracownicy ORDER BY id_prac ASC;

--zad5
SELECT nazwisko, placa_pod, (placa_pod * 0.2) AS inwestycja,
((placa_pod * 0.2) * (POWER(1 + 0.1, 10))) AS kapital,
((placa_pod * 0.2) * (POWER(1 + 0.1, 10)))-(placa_pod * 0.2) AS zysk
FROM pracownicy;

--zad6
SELECT nazwisko, TO_CHAR(zatrudniony, 'RR/MM/DD') AS zatrudniony,
EXTRACT(YEAR FROM (DATE '2000-01-01' - zatrudniony) YEAR TO MONTH) AS staz_w_2000
FROM pracownicy;

--zad7
SELECT nazwisko, TO_CHAR(zatrudniony, 'fmMONTH, DD YYYY') AS data_zatrudnienia FROM pracownicy WHERE id_zesp = 20;

--zad8
SELECT TO_CHAR(CURRENT_DATE, 'fmDAY') AS dzis FROM dual;

--zad9
SELECT nazwa, adres,
CASE WHEN adres LIKE 'PIOTROWO%' THEN 'NOWE MIASTO' WHEN adres LIKE 'STRZELECKA%' OR adres LIKE 'MIELZYNSKIEGO%' THEN 'STARE MIASTO'
WHEN adres LIKE 'WLODKOWICA%' THEN 'GRUNWALD' END AS DZIELNICA
FROM zespoly;

--zad10
SELECT nazwisko, placa_pod, CASE WHEN placa_pod > 480 THEN 'Powyżej 480' WHEN placa_pod = 480 THEN 'Dokładnie 480'
WHEN placa_pod < 480 THEN 'Poniżej 480' END AS próg FROM pracownicy ORDER BY placa_pod DESC;

--zad11
SELECT nazwisko, placa_pod, DECODE(SIGN((placa_pod - 480)), 1, 'Powyżej 480', 0, 'Dokładnie 480', -1, 'Poniżej 480') AS próg
FROM pracownicy ORDER BY placa_pod DESC;
