# ==============================================================================
# ESERCIZIO FINALE M2 — PROGETTAZIONE E INTERROGAZIONE DATABASE TOYSGROUP
# Studentessa: Carol Pagano
# Data: 08/06/2026
# ==============================================================================


# ==============================================================================
# TASK 2 — CREAZIONE DATABASE E TABELLE (DDL)
# ==============================================================================

# Elimino il database se già esistente per permettere esecuzioni ripetute
DROP DATABASE IF EXISTS ToysGroup;

# Creo il database
CREATE DATABASE ToysGroup;

# Seleziono il database
USE ToysGroup;


# ------------------------------------------------------------------------------
# Tabella Product (Tabella Anagrafica Forte)
# ------------------------------------------------------------------------------
# Contiene l’elenco dei prodotti e la loro categoria merceologica.
# La PK è ProductID (auto-incrementale).
# ------------------------------------------------------------------------------

CREATE TABLE Product (
     ProductID 			INT NOT NULL AUTO_INCREMENT PRIMARY KEY
    ,ProductName 		VARCHAR(100) NOT NULL
    ,Category 			VARCHAR(50) NOT NULL
);


# ------------------------------------------------------------------------------
# Tabella Region (Tabella Anagrafica Forte)
# ------------------------------------------------------------------------------
# Contiene gli stati e la regione geografica di appartenenza.
# La PK è RegionID (auto-incrementale).
# ------------------------------------------------------------------------------

CREATE TABLE Region (
	 RegionID 			INT NOT NULL AUTO_INCREMENT PRIMARY KEY
	,RegionName 		VARCHAR(100) NOT NULL
	,State 				VARCHAR(100) NOT NULL
);


# ------------------------------------------------------------------------------
# Tabella Sales (Tabella Debole / Transazionale)
# ------------------------------------------------------------------------------
# Registra ogni vendita effettuata.
# Contiene FK verso Product e Region.
# ------------------------------------------------------------------------------

CREATE TABLE Sales (
	 SalesID 					INT NOT NULL AUTO_INCREMENT PRIMARY KEY
    ,SalesCode 					VARCHAR(50) NOT NULL UNIQUE
    ,Quantity 					INT NOT NULL
    ,Price 						DECIMAL(18,2) NOT NULL
    ,SalesDate 					DATE NOT NULL
    ,ProductID 					INT NOT NULL
    ,RegionID 					INT NOT NULL
    ,FOREIGN KEY (ProductID)	REFERENCES Product(ProductID)
    ,FOREIGN KEY (RegionID) 	REFERENCES Region(RegionID)
);



# ==============================================================================
# TASK 3 — POPOLAMENTO DELLE TABELLE (INSERT)
# ==============================================================================

# ------------------------------------------------------------------------------
# Popolamento tabella Product
# ------------------------------------------------------------------------------

INSERT INTO Product 
(ProductName, Category) VALUES
('Buzz Lightyear Action Figure', 'Action Figures'),
('Sheriff Woody Doll', 'Dolls'),
('Lightning McQueen Vehicle', 'Vehicles'),
('Stitch Plush Toy', 'Plush Toys'),
('Shrek Action Figure', 'Action Figures'),
('Toothless Plush Toy', 'Plush Toys'),
('Po Kung Fu Panda Doll', 'Dolls'),
('Megamind Vehicle', 'Vehicles'),
('Elsa Frozen Doll', 'Dolls'),
('Alex the Lion Plush', 'Plush Toys');


# ------------------------------------------------------------------------------
# Popolamento tabella Region
# ------------------------------------------------------------------------------

INSERT INTO Region 
(RegionName, State) VALUES
('WestEurope', 'France'),
('WestEurope', 'Germany'),
('SouthEurope', 'Italy'),
('SouthEurope', 'Greece'),
('NorthAmerica', 'United States'),
('NorthAmerica', 'Canada'),
('Asia', 'Japan'),
('Asia', 'China');


# ------------------------------------------------------------------------------
# Popolamento tabella Sales
# ------------------------------------------------------------------------------

INSERT INTO Sales 
(SalesCode, Quantity, Price, SalesDate, ProductID, RegionID) VALUES
('ORD-0001', 5, 25.00, '2023-03-10', 1, 1),
('ORD-0002', 12, 15.50, '2023-06-15', 2, 3),
('ORD-0003', 2, 45.00, '2023-09-22', 3, 5),
('ORD-0004', 20, 10.00, '2023-12-05', 4, 7),
('ORD-0005', 7, 22.00, '2024-01-18', 5, 2),
('ORD-0006', 1, 35.00, '2024-04-22', 6, 4),
('ORD-0007', 15, 18.00, '2024-07-30', 7, 6),
('ORD-0008', 4, 50.00, '2024-11-12', 8, 8),
('ORD-0009', 3, 25.00, '2025-02-14', 1, 3),
('ORD-0010', 8, 15.50, '2025-04-19', 2, 6),
('ORD-0011', 10, 45.00, '2025-06-25', 3, 1),
('ORD-0012', 25, 10.00, '2025-08-05', 4, 5),
('ORD-0013', 6, 22.00, '2025-09-12', 5, 8),
('ORD-0014', 2, 35.00, '2025-10-20', 6, 2),
('ORD-0015', 30, 18.00, '2025-11-05', 7, 4),
('ORD-0016', 5, 50.00, '2025-11-28', 8, 7),
('ORD-0017', 14, 25.00, '2025-12-10', 1, 2),
('ORD-0018', 18, 15.50, '2025-12-18', 2, 4),
('ORD-0019', 1, 45.00, '2025-12-23', 3, 6),
('ORD-0020', 22, 10.00, '2025-12-30', 4, 8);



# ==============================================================================
# TASK 4 — QUERY DI ANALISI
# ==============================================================================


# ------------------------------------------------------------------------------
# Query 1 — Verifica univocità delle Primary Key
# ------------------------------------------------------------------------------

# Product
SELECT 		ProductID
FROM 		Product
GROUP BY 	ProductID
HAVING 		COUNT(*) > 1;	# --> 0 righe restituite = PK univoca

				# Ulteriore modo:
				SELECT 
					 COUNT(*) 					ConteggioRighe
					,COUNT(DISTINCT ProductID) 	Conteggio
				FROM Product;

# Region
SELECT RegionID
FROM Region
GROUP BY RegionID
HAVING COUNT(*) > 1;   # --> 0 righe restituite = PK univoca

# Sales
SELECT SalesID
FROM Sales
GROUP BY SalesID
HAVING COUNT(*) > 1;	# --> 0 righe restituite = PK univoca

				# Ulteriore modo:
				SELECT 
					 SalesID
					,COUNT(*) 			ConteggioRighe
				FROM Sales
				GROUP BY SalesID
				HAVING ConteggioRighe > 1;

# ------------------------------------------------------------------------------
# Query 2 — Elenco transazioni con flag > 180 giorni
# ------------------------------------------------------------------------------

SELECT
     S.SalesCode 			AS CodiceDocumento
    ,S.SalesDate 			AS DataVendita
    ,P.ProductName 			AS NomeProdotto
    ,P.Category				AS CategoriaProdotto
    ,R.State 				AS NomeStato
    ,R.RegionName 			AS NomeRegione
    ,CASE 
        WHEN DATEDIFF(CURDATE(), S.SalesDate) > 180 THEN 'True'
        ELSE 'False'
		END 				AS Flag180gg
FROM Sales S
JOIN Product P 		ON 		S.ProductID = P.ProductID
JOIN Region R 		ON 		S.RegionID = R.RegionID;



# ------------------------------------------------------------------------------
# Query 3 — Prodotti con totale venduto > media dell’ultimo anno censito
# ------------------------------------------------------------------------------

SELECT
			 ProductID
			,SUM(Quantity) 				AS TotaleVenduto
FROM Sales
GROUP BY ProductID
HAVING SUM(Quantity) > (
    SELECT AVG(Quantity)
    FROM Sales
    WHERE YEAR(SalesDate) = (SELECT MAX(YEAR(SalesDate)) FROM Sales)
);



# ------------------------------------------------------------------------------
# Query 4 — Fatturato totale per prodotto per anno
# ------------------------------------------------------------------------------

SELECT
     P.ProductID
    ,P.ProductName
    ,YEAR(S.SalesDate) 				AS Anno
    ,SUM(S.Price * S.Quantity) 		AS FatturatoTotale
FROM Sales S
JOIN Product P ON S.ProductID = P.ProductID
GROUP BY P.ProductID, P.ProductName, YEAR(S.SalesDate)
ORDER BY P.ProductID, Anno;



# ------------------------------------------------------------------------------
# Query 5 — Fatturato totale per stato per anno
# ------------------------------------------------------------------------------

SELECT
     R.State 					AS Stato
    ,YEAR(S.SalesDate) 			AS Anno
    ,SUM(S.Price * S.Quantity) 	AS FatturatoTotale
FROM Sales S
JOIN Region R ON S.RegionID = R.RegionID
GROUP BY R.State, YEAR(S.SalesDate)
ORDER BY Anno ASC, FatturatoTotale DESC;



# ------------------------------------------------------------------------------
# Query 6 — Categoria più richiesta dal mercato
# ------------------------------------------------------------------------------

SELECT
     P.Category 			AS Categoria
    ,SUM(S.Quantity) 		AS TotaleQuantitaVenduta
FROM Sales S
JOIN Product P ON S.ProductID = P.ProductID
GROUP BY P.Category
ORDER BY TotaleQuantitaVenduta DESC
LIMIT 1;



# ------------------------------------------------------------------------------
# Query 7 — Prodotti invenduti (due approcci)
# ------------------------------------------------------------------------------

# Approccio 1 — LEFT JOIN
SELECT
     P.ProductID
    ,P.ProductName
    ,P.Category
FROM Product P
LEFT JOIN Sales S ON P.ProductID = S.ProductID
WHERE S.SalesID IS NULL;

# Approccio 2 — Subquery NOT IN
SELECT
     P.ProductID
    ,P.ProductName
    ,P.Category
FROM Product P
WHERE P.ProductID NOT IN (
    SELECT ProductID FROM Sales
);



# ------------------------------------------------------------------------------
# Query 8 - Creazione Vista Prodotti Denormalizzata
# ------------------------------------------------------------------------------
CREATE OR REPLACE VIEW ProdottiDenormalizzati AS (
		SELECT 
			ProductID			CodiceProdotto 
			,ProductName		NomeProdotto
			,Category			NomeCategoria
		FROM Product
);
# ------------------------------------------------------------------------------
# Query 9 - Creazione Vista Informazioni Geografiche
# ------------------------------------------------------------------------------
CREATE OR REPLACE VIEW InformazioniGeografiche AS (
		SELECT 
			RegionID
			,RegionName			NomeRegione
			,State				NomeStato
		FROM Region
);
# ==============================================================================
# FINE SCRIPT SQL
# ==============================================================================
