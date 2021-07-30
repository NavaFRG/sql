-- Création de la base de données --
CREATE DATABASE IF NOT EXISTS S6_MVC_BTP;

USE S6_MVC_BTP;

CREATE TABLE Client(
    id	int PRIMARY KEY AUTO_INCREMENT,
    nom varchar(255),
    anneeNaiss year(4),
    ville varchar(255)
);

CREATE TABLE Fournisseur(
    id int PRIMARY KEY AUTO_INCREMENT,
    nom varchar(255),
    age int,
    ville varchar(255)
);

CREATE TABLE Produit(
    label varchar(255),
    prix float,
    idF int,
    PRIMARY KEY (label, idF),
    FOREIGN KEY (idF) REFERENCES fournisseur(id)
);

CREATE TABLE Commande(
    num int,
    quantite int,
    labelP varchar(255),
    idC int,
    PRIMARY KEY (num, labelP, idC),
    FOREIGN KEY (labelP) REFERENCES produit(label),
    FOREIGN KEY (idC) REFERENCES client(id)
);

INSERT INTO client (nom, anneeNaiss, ville) VALUES 
('Jean', 1965, '75006 Paris'),
('Paul', 1958, '75003 Paris'),
('Vincent', 1954, '94200 Evry'),
('Pierre', 1950, '92400 Courbevoie'),
('Daniel', 1963, '44000 Nantes');

INSERT INTO fournisseur (nom, age, ville) VALUES
('Abounayan', 52, '92190 Meudon'),
('Cima', 37, '44510 Nantes'),
('Preblocs', 48, '92230 Gennevilliers'),
('Samaco', 61, '75018 Paris'),
('Damasco', 29, '49100 Angers');

INSERT INTO produit VALUES
('sable', 300, 1),
('briques', 1500, 1),
('parpaing', 1150, 1),
('sable', 350, 2),
('tuiles', 1200, 3),
('parpaing', 1300, 3),
('briques', 1500, 4),
('ciment', 1300, 4),
('parpaing', 1450, 4),
('briques', 1450, 5),
('tuiles', 1100, 5);

INSERT INTO commande (num, idC, labelP, quantite) VALUES 
(1, 1, 'briques', 5),
(1, 1, 'ciment', 10),
(2, 2, 'briques', 12),
(2, 2, 'sable', 9),
(2, 2, 'parpaing', 15),
(3, 3, 'sable', 17),
(4, 4, 'briques', 8),
(4, 4, 'tuiles', 17),
(5, 5, 'parpaing', 10),
(5, 5, 'ciment', 14),
(6, 5, 'briques', 21),
(7, 2, 'ciment', 12),
(8, 4, 'parpaing', 8),
(9, 1, 'tuiles', 15);

-- Question 1 --
SELECT * FROM client;

-- Question 2 --
SELECT nom, anneeNaiss, ville FROM client;

-- Question 3 --
SELECT * FROM Client
WHERE anneeNaiss < (YEAR(CURDATE()) - 50);

-- Question 4 --
SELECT DISTINCT label FROM Produit;

-- Question 5 --
SELECT DISTINCT label FROM Produit
ORDER BY label;

-- Question 6 --
-- a.
SELECT * FROM commande
WHERE quantite BETWEEN 8 AND 18;
-- b.
SELECT * FROM commande
WHERE quantite >= 8 AND quantite <= 18;

-- Question 7 --
SELECT nom, ville FROM client
WHERE nom LIKE 'P%';

-- Question 8 --
SELECT nom FROM fournisseur
WHERE ville LIKE '%Paris';

-- Question 9 --
-- a.
SELECT idF, prix FROM produit
WHERE label IN ('briques', 'parpaing');
-- b.
SELECT idF, prix FROM produit
WHERE label = 'briques' OR label = 'parpaing';

-- Question 10 --
SELECT nom, labelP, quantite FROM client
JOIN commande ON client.id = commande.idC;
-- 14 reponses

-- Question 11 --
SELECT nom, labelP
FROM client, commande
WHERE client.id = commande.idC;
-- 14 reponses

-- Question 12 --
SELECT nom FROM client
JOIN commande ON client.id = commande.idC
WHERE labelP = 'briques'
ORDER BY nom;

-- Question 13 --
-- a.
SELECT DISTINCT nom FROM fournisseur
JOIN produit ON fournisseur.id = produit.idF
WHERE label IN ('briques', 'parpaing');
-- b.
SELECT nom FROM fournisseur
WHERE id IN (
    SELECT idF FROM produit
    WHERE label IN ('briques', 'parpaing')
);

-- Question 13 -- Doublon du brief
-- 1. jointure
SELECT label FROM produit
JOIN fournisseur ON produit.idF = fournisseur.id
WHERE ville LIKE '%Paris';
-- 2. produit cartesien
SELECT label
FROM produit, fournisseur
WHERE produit.idF = fournisseur.id
AND ville LIKE '%Paris';
-- 3. requete imbriquee
SELECT label FROM produit
WHERE idF IN (
    SELECT id FROM fournisseur
    WHERE ville LIKE '%Paris'
);

-- Question 14 --
SELECT nom, ville FROM client
JOIN commande ON client.id = commande.idC
WHERE labelP = 'briques'
AND quantite BETWEEN 10 AND 15;

-- Question 15 --
-- Cross join
SELECT fournisseur.nom, label, prix
FROM client, commande, produit, fournisseur
WHERE client.id = commande.idC
AND commande.labelP = produit.label
AND fournisseur.id = produit.idF
AND client.nom = 'Jean';
-- Requete imbriquee
SELECT nom, label, prix FROM fournisseur
JOIN produit ON fournisseur.id = produit.idF
WHERE label IN (
    SELECT labelP FROM commande
    WHERE idC IN (
        SELECT id FROM client
        WHERE nom = 'Jean'
    )
);
-- Jointure
SELECT fournisseur.nom, label, prix FROM fournisseur
JOIN produit ON fournisseur.id = produit.idF
JOIN commande ON produit.label = commande.labelP
JOIN client ON client.id = commande.idC
WHERE client.nom = 'Jean';

-- Question 16 --
SELECT nom, label, prix FROM fournisseur
JOIN produit ON fournisseur.id = produit.idF
WHERE label IN (
    SELECT labelP FROM commande
    WHERE idC IN (
        SELECT id FROM client
        WHERE nom = 'Jean'
    )
)
ORDER BY nom DESC;

-- Question 17 --
SELECT label, AVG(prix) FROM produit
GROUP BY label;

-- Question 18 --
SELECT label, AVG(prix) FROM produit
GROUP BY label 
HAVING AVG(prix) >= 1200;

-- Question 20 --
SELECT DISTINCT abel FROM produit
WHERE prix < (
    SELECT AVG(prix) FROM produit
);

-- Question 21 --
SELECT label, AVG(prix) FROM produit
GROUP BY label
HAVING COUNT(idF) >= 3;