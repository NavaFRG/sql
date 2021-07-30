CREATE DATABASE IF NOT EXISTS vignoble;

USE vignoble;

CREATE TABLE IF NOT EXISTS producteur(
    numProd int PRIMARY KEY AUTO_INCREMENT,
    nom varchar(255),
    domaine varchar(255),
    region varchar(255)
);

CREATE TABLE IF NOT EXISTS vin(
    numVin int PRIMARY KEY,
    appellation varchar(255),
    couleur varchar(255),
    annee year(4),
    degre int
);

CREATE TABLE IF NOT EXISTS recolte(
    nProd int,
    nVin int,
    quantite int,
    FOREIGN KEY (nProd) REFERENCES producteur(numProd),
    FOREIGN KEY (nVin) REFERENCES vin(numVin)
);

INSERT INTO producteur (nom, domaine, region) VALUES
('Producteur1', 'Graves', 'Bordeaux'),
('Producteur2', 'Domaine Roblet-Monnot', 'Bourgogne'),
('Producteur3', 'Domaine des Rouges', 'Bordeaux'),
('Dupont', 'Domaine Marcel Richaud', 'Côte Du Rhône'),
('Producteur5', 'La Grande Oncle', 'Alsace'),
('Producteur6', 'Domaine Pierre Labet', 'Bourgogne'),
('Dupond', 'Domaine Mikulski', 'Bourgogne'),
('Producteur8', 'Domaine Tissot', 'Jura'),
('Producteur9', 'Domaine Peyre Rose', 'Languedoc Roussillon'),
('Producteur10', 'Domaine Chapelas', 'Côte Du Rhône'),
('Producteur11', 'Domaine Pierre Labet', 'Côte Du Rhône');

INSERT INTO vin VALUES
(1, 'Château Villa Bel-Air', 'Rouge', 2014, 13),
(2, 'Domaine Roblet-Monnot', 'Rouge', 2017, 13),
(3, 'La Fussière', 'Rouge', 2017, 13),
(4, 'Mistral AOC', 'Rouge', 2004, 15),
(5, 'La Grange Oncle Charles', 'Blanc', 2018, 13),
(6, 'Vieilles Vignes', 'Blanc', 2017, 13),
(7, 'Genevrière', 'Blanc', 1999, 13),
(8, 'Cremant du Jura Blanc', 'Blanc', 2015, 15),
(9, 'Syrah Leone', 'Rosé', 1995, 15),
(10, 'Domaine Chapelas Rosé', 'Rosé', 2004, 14),
(20, 'Vieilles Vignes', 'Blanc', 2000, 15);

INSERT INTO recolte VALUES
(1, 1, 20),
(2, 2, 40),
(3, 3, 50),
(4, 4, 100),
(5, 5, 70),
(6, 6, 90),
(7, 7, 200),
(8, 8, 5),
(9, 9, 25),
(10, 10, 100),
(11, 20, 70);

-- NIVEAU FACILE --
-- 1 --
SELECT appellation FROM vin
WHERE annee = 1995;

-- 2 --
SELECT appellation, couleur, annee, degre FROM vin
WHERE annee > 2000;

-- 3 --
SELECT * FROM vin
WHERE annee BETWEEN 2000 AND 2009;

-- 4 --
SELECT * FROM vin
WHERE couleur = 'Blanc'
AND degre > 14;

-- 5 --
SELECT * FROM vin
WHERE appellation LIKE '%AOC%';

-- 6 --
SELECT domaine FROM producteur
WHERE region = 'Bordeaux';

-- 7 --
SELECT nom, region FROM producteur
WHERE numProd IN (
    SELECT nProd FROM recolte
    WHERE nVin = 5
);

-- 8 --
SELECT * FROM producteur
WHERE region = 'Beaujolais';

-- 9 --
SELECT * FROM producteur
WHERE nom = 'Dupon%';

-- 10 --
SELECT nom FROM producteur
ORDER BY nom;


-- NIVEAU MOYEN --
-- 1 --
SELECT annee FROM vin
WHERE degre IN (
    SELECT MAX(degre) FROM vin
    GROUP BY couleur
)
ORDER BY annee DESC;

-- 2 --
SELECT * FROM vin
WHERE degre > (
    SELECT AVG(degre) FROM vin
)
ORDER BY couleur, degre DESC;

-- 3 --
SELECT MIN(degre), MAX(degre) FROM vin
GROUP BY appellation, couleur;

-- JOINTURE --
-- 1 --
SELECT nom FROM producteur
JOIN recolte ON producteur.numProd = recolte.nProd
WHERE nVin = 20
AND quantite > 50;

-- 2 --
SELECT quantite FROM recolte
JOIN vin ON vin.numVin = recolte.nVin
WHERE couleur = 'Rouge'
AND annee = 2004;

-- 3 --
SELECT annee, quantite FROM vin
JOIN recolte ON vin.numVin = recolte.nVin
WHERE couleur = 'Blanc'
GROUP BY annee;

-- 4 --
SELECT annee, AVG(degre) FROM vin
WHERE couleur = 'Blanc'
GROUP BY annee;

-- 5 --
SELECT nom, domaine FROM producteur
JOIN recolte ON producteur.numProd = recolte.nProd
JOIN vin ON vin.numVin = recolte.nVin
WHERE couleur = 'Rouge';

-- 6 --
SELECT appellation, nProd, quantite FROM vin
JOIN recolte ON vin.numVin = recolte.nVin
WHERE annee = 1999
AND quantite = 200;
