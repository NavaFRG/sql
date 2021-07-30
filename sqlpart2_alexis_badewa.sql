CREATE DATABASE IF NOT EXISTS musique;

USE musique;

CREATE TABLE orchestre(
    nom varchar(255) PRIMARY KEY,
    style varchar(255),
    chef varchar(255)
);

CREATE TABLE musicien(
    nom varchar(255) PRIMARY KEY,
    instrument varchar(255),
    anneesExperience int,
    nomOrchestre varchar(255),
    FOREIGN KEY (nomOrchestre) REFERENCES orchestre(nom)
);

CREATE TABLE concert(
    nom varchar(255) PRIMARY KEY,
    nomOrchestre varchar(255),
    date_ date,
    lieu varchar(255),
    prix float,
    FOREIGN KEY (nomOrchestre) REFERENCES orchestre(nom)
);

INSERT INTO orchestre VALUES
('orchestre1', 'jazz', 'leonardo'),
('orchestre2', 'pop', 'michaelgelo'),
('orchestre3', 'rnb', 'raphael'),
('orchestre4', 'house', 'donatello'),
('orchestre5', 'classic', 'Smith'),
('orchestre6', 'classic', 'Smith'),
('orchestre7', 'blues', 'Ray');

INSERT INTO concert VALUES
('Ultrall', 'orchestre1', '2021-06-15', 'Stade de France', 500),
('Die rich or trie dying', 'orchestre2', '2004-09-03', 'Zenith', 100),
('Ultral', 'orchestre1', '2014-09-05', 'NY', 600),
('Life', 'orchestre3', '2020-11-22', 'Dubai', 400),
('Fiestea', 'orchestre3', '2010-07-12', 'Miami', 50),
('Power', 'orchestre2', '1997-08-16', 'Douala', 1000),
('Mozart', 'orchestre5', '2019-04-20', 'Opéra Bastille', 10),
('Zen', 'orchestre7', '2015-02-22', 'LA', 50),
('Relax', 'orchestre6', '2016-01-01', 'PARIS', 200);

INSERT INTO musicien VALUES 
('Yannick', 'guitare', 10, 'orchestre1'),
('Patrick', 'piano', 10, 'orchestre1'),
('Cedric', 'violon', 10, 'orchestre1'),
('Jordan', 'batterie', 2, 'orchestre2'),
('Gaelle', 'saxophone', 4, 'orchestre3'),
('Georges', 'harmonica', 20, 'orchestre6');


-- NIVEAU FACILE --

-- 1 --
SELECT nom, instrument FROM musicien
WHERE anneesExperience < 5;

-- 2 --
SELECT instrument FROM musicien
WHERE nomOrchestre = 'Jazz92';

-- 3 --
SELECT * FROM musicien
WHERE instrument = 'violon';

-- 4 --
SELECT instrument FROM musicien
WHERE anneesExperience >= 20;

-- 5 --
SELECT nom FROM musicien
WHERE anneesExperience BETWEEN 5 AND 10;

-- 6 --
SELECT instrument FROM musicien
WHERE instrument LIKE 'vio%';

-- 7 --
SELECT nom FROM orchestre
WHERE style = 'jazz';

-- 8 --
SELECT nom FROM orchestre
WHERE chef = 'Smith';

-- 9 --
SELECT * FROM concert
ORDER BY nom;

-- 10 --
SELECT * FROM concert
WHERE date_ = '2015-12-31'
AND lieu = 'Versailles';

-- 11 --
SELECT lieu FROM concert
WHERE prix > 150;

-- 12 --
SELECT * FROM concert
WHERE lieu = 'Opéra Bastille'
AND prix < 50;

-- 13 --
SELECT * FROM concert
WHERE YEAR(date_) = 2014;


-- NIVEAU MOYEN --

-- 1 --
SELECT musicien.nom, instrument FROM musicien
JOIN orchestre  ON musicien.nomOrchestre = orchestre.nom
WHERE anneesExperience > 3
AND style = 'jazz';

-- 2 --
SELECT lieu FROM concert
JOIN orchestre ON concert.nomOrchestre = orchestre.nom
WHERE chef = 'Smith'
AND prix < 20
ORDER BY lieu;

-- 3 --
SELECT COUNT(*) as count FROM concert
JOIN orchestre ON concert.nomOrchestre = orchestre.nom
WHERE style = 'blues'
AND YEAR(date_) = 2015;

-- 4 --
SELECT lieu, AVG(prix) FROM concert
JOIN orchestre ON concert.nomOrchestre = orchestre.nom
WHERE style = 'jazz'
GROUP BY lieu;

-- 5 --
SELECT instrument FROM orchestre
JOIN musicien ON musicien.nomOrchestre = orchestre.nom
JOIN concert ON concert.nomOrchestre = orchestre.nom
WHERE chef = 'Smith'
AND date_ = '2016-01-01';

-- 6 --
SELECT AVG(anneesExperience)as average FROM musicien
JOIN orchestre ON musicien.nomOrchestre = orchestre.nom
WHERE instrument = 'trompette'
GROUP BY style;

-- Requete imbriquee --
-- 1 --
SELECT nom, instrument FROM musicien
WHERE anneesExperience > 3
AND nomOrchestre IN(
    SELECT nom FROM orchestre
    WHERE style = 'jazz'
)
ORDER BY nom;

-- 2 --
SELECT lieu FROM concert
WHERE prix < 20
AND nomOrchestre IN(
    SELECT nom FROM orchestre
    WHERE chef = 'Smith'
);

-- 3 --
SELECT * FROM concert
WHERE YEAR(date_) = 2015
AND nomOrchestre IN(
    SELECT nom FROM orchestre
    WHERE style = 'blues'
);

-- 4 --
SELECT lieu, AVG(prix) FROM concert
WHERE nomOrchestre IN(
    SELECT nom FROM orchestre
    WHERE style = 'jazz'
)
GROUP BY lieu;

-- 5 --
SELECT instrument FROM musicien
WHERE nomOrchestre IN (
    SELECT nom FROM orchestre
    WHERE chef = 'Smith'
    AND nom IN (
        SELECT nomOrchestre FROM concert
        WHERE date_ = '2016-01-01'
    )
);