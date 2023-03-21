CREATE TABLE klienci (
    id_klient          INTEGER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    haslo              CHAR(60)    NOT NULL,
    nazwisko           VARCHAR(20) NOT NULL,
    imie               VARCHAR(20) NOT NULL,
    ulica_lub_osiedle  VARCHAR(60) NOT NULL,
    nr_mieszkania      VARCHAR(10) NOT NULL,
    miejscowosc        VARCHAR(30) NOT NULL,
    telefon            VARCHAR(9)  NOT NULL,
    email              VARCHAR(30) NOT NULL,
    nazwa_firmy        VARCHAR(30),
    nip                VARCHAR(10)
);

CREATE TABLE pracownicy (
    id_pracownik       INTEGER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    imie               VARCHAR(20) NOT NULL,
    nazwisko           VARCHAR(20) NOT NULL,
    data_zatrudnienia  DATE DEFAULT sysdate NOT NULL,
    nazwa_dzialu       VARCHAR(20) NOT NULL,
    stanowisko         VARCHAR(20) NOT NULL
);


CREATE TABLE produkty (
    id_produktu  INTEGER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    opis         VARCHAR(200),
    cena_netto   DECIMAL(5, 2) NOT NULL,
    cena_brutto  DECIMAL(5, 2) NOT NULL,
    procent_vat  DECIMAL(4, 3) NOT NULL,
    nazwa VARCHAR(20) NOT NULL,
    constraint chk_ceny check (cena_netto < cena_brutto and cena_netto + (cena netto * procent_vat) = cena_brutto)

);

CREATE TABLE faktury ( id_faktury INTEGER
    GENERATED ALWAYS AS IDENTITY
PRIMARY KEY,
    kwota_netto   DECIMAL(5, 2) NOT NULL,
    kwota_brutto  DECIMAL(5, 2) NOT NULL,
    wartosc_vat   DECIMAL(5, 2) NOT NULL,
    constraint chk_faktury check (kwota_netto < kwota_brutto and kwota_netto + wartosc_vat = kwota_brutto)
);

CREATE TABLE zamowienia (
    id_zamowienia     INTEGER
        GENERATED ALWAYS AS IDENTITY
    PRIMARY KEY,
    data_zlozenia     DATE DEFAULT sysdate NOT NULL,
    czy_przyjete      boolean NOT NULL,
    data_przyjecia    DATE,
    czy_zaplacone     boolean,
    czy_zrealizowano  boolean NOT NULL,
    data_wyslania     DATE,
    data_realizacji   DATE,
    id_klient         INTEGER
        CONSTRAINT fk_klienci
            REFERENCES klienci ( id_klient )
    NOT NULL,
    id_pracownik      INTEGER
        CONSTRAINT fk_pracownicy
            REFERENCES pracownicy ( id_pracownik )
    NOT NULL,
    id_faktury        INTEGER
        CONSTRAINT fk_faktury
            REFERENCES faktury ( id_faktury )
    NOT NULL,
    id_produktu       INTEGER
        CONSTRAINT fk_produkty
            REFERENCES produkty ( id_produktu )
    NOT NULL,
    CONSTRAINT chk_daty check (data_zlozenia <= data_przyjecia and data_przyjecia <= data_wyslania and data_wyslania <= data_realizacji)
);




CREATE TABLE zamowione_produkty (
	id_zamowienia 	INTEGER 
		CONSTRAINT fk_zp_zamowienia REFERENCES zamowienia(id_zamowienia) NOT NULL,
	id_produktu 		INTEGER 
		CONSTRAINT fk_zp_produkty REFERENCES produkty(id_produktu) NOT NULL,

	CONSTRAINT pk_ zp PRIMARY KEY (zamowienia_id_zamowienia, produkty_id_produktu)
 
