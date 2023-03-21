--zad1
SELECT * FROM zespoly ORDER BY id_zesp;

--zad2
SELECT * FROM pracownicy ORDER BY id_prac;

--zad3
SELECT nazwisko, placa_pod * 12 AS roczna_praca
FROM pracownicy
ORDER BY nazwisko;

--zad4
SELECT nazwisko, etat, placa_pod + nvl(placa_dod, 0) AS miesieczne_zarobki 
FROM pracownicy
ORDER BY miesieczne_zarobki DESC;

--zad5
SELECT * FROM zespoly ORDER BY nazwa;

--zad6
SELECT UNIQUE etat FROM pracownicy;

--zad7
SELECT * FROM pracownicy WHERE etat = 'ASYSTENT' ORDER BY nazwisko;

--zad8
SELECT id_prac, nazwisko, etat, placa_pod, id_zesp
FROM pracownicy
WHERE id_zesp = 30 OR id_zesp = 40
ORDER BY placa_pod DESC;

--zad9
SELECT nazwisko, id_zesp, placa_pod
FROM pracownicy 
WHERE placa_pod BETWEEN 300 AND 800
ORDER BY nazwisko;

--zad10
SELECT nazwisko, etat, id_zesp
FROM pracownicy
WHERE nazwisko LIKE '%SKI';

--zad11
SELECT id_prac, id_szefa, nazwisko, placa_pod
FROM PRACOWNICY
WHERE placa_pod > 1000 AND id_szefa IS NOT NULL
ORDER BY nazwisko ASC

-- zad. 12
SELECT nazwisko, id_zesp FROM PRACOWNICY
WHERE id_zesp = 20 AND (nazwisko LIKE 'M%' OR nazwisko LIKE '%SKI')
ORDER BY nazwisko ASC

-- zad. 13
SELECT nazwisko, etat, placa_pod / 20 / 8 AS stawka
FROM PRACOWNICY
WHERE etat NOT IN ('ADIUNKT', 'ASYSTENT', 'STAZYSTA') AND placa_pod NOT BETWEEN 400 AND 800
ORDER BY stawka ASC

-- zad. 14
SELECT nazwisko, etat, placa_pod, placa_dod
FROM PRACOWNICY
WHERE placa_pod + COALESCE(placa_dod, 0) > 1000
ORDER BY etat ASC, nazwisko ASC

-- zad. 15
SELECT nazwisko || ' pracuje od ' || zatrudniony || ' i zarabia ' || placa_pod AS profesorowie
FROM PRACOWNICY
WHERE etat = 'PROFESOR'
ORDER BY placa_pod DESC
