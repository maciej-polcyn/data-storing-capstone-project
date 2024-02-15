USE warehousing_capstone;
# Removing brand name from Genmodel values
CREATE VIEW names AS
(
WITH multiple_words AS (SELECT Maker
                        FROM (SELECT DISTINCT Maker,
                                              (LENGTH(Maker) - LENGTH(REPLACE(Maker, ' ', '')) + 1) AS no_words
                              FROM sales) words
                        WHERE no_words > 1)
SELECT Maker,
       CASE
           WHEN Maker IN (SELECT Maker FROM multiple_words)
               THEN TRIM(TRIM(LEADING SUBSTRING_INDEX(Genmodel, " ", 2) FROM Genmodel))
           ELSE TRIM(TRIM(LEADING SUBSTRING_INDEX(Genmodel, " ", 1) FROM Genmodel))
           END AS Model
FROM sales
ORDER BY Maker
    );

# Helper query for checking the longest string in column
SELECT MAX(len) AS longest
FROM (SELECT LENGTH(Maker) AS len
FROM names) x;

# Creating Brands_DIM table
CREATE TABLE Brands_DIM (
    brand_key INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name NVARCHAR(25)
);

INSERT INTO Brands_DIM (name)
SELECT DISTINCT Maker
FROM names;

# Creating Models_DIM table
CREATE TABLE Models_DIM (
    model_key INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name NVARCHAR(30),
    brand_key INT NOT NULL,
    FOREIGN KEY (brand_key) REFERENCES Brands_DIM (brand_key)
);

INSERT INTO Models_DIM (name, brand_key)
SELECT
    DISTINCT Model,
    brand_key AS brand_key
FROM names n
JOIN Brands_DIM b ON b.name = n.Maker;

# Creating helper view for sales fact table
DROP VIEW IF EXISTS sales_update;
CREATE VIEW sales_update AS (
WITH multiple_words AS (SELECT Maker
                        FROM (SELECT DISTINCT Maker,
                                              (LENGTH(Maker) - LENGTH(REPLACE(Maker, " ", "")) + 1) AS no_words
                              FROM sales) words
                        WHERE no_words > 1)
SELECT
       CASE
           WHEN Maker IN (SELECT Maker FROM multiple_words)
               THEN TRIM(TRIM(LEADING SUBSTRING_INDEX(Genmodel, " ", 2) FROM Genmodel))
           ELSE TRIM(TRIM(LEADING SUBSTRING_INDEX(Genmodel, " ", 1) FROM Genmodel))
           END AS Model,
        sales.*
FROM sales
ORDER BY Maker
);

# Creating another helper view for sales fact table
DROP VIEW IF EXISTS sales_copy;
CREATE VIEW sales_copy AS (
    SELECT model_key,
       Year_2020,
       Year_2019,
       Year_2018,
       Year_2017,
       Year_2016,
       Year_2015,
       Year_2014,
       Year_2013,
       Year_2012,
       Year_2011,
       Year_2010,
       Year_2009,
       Year_2008,
       Year_2007,
       Year_2006,
       Year_2005,
       Year_2004,
       Year_2003,
       Year_2002,
       Year_2001
FROM sales_update s
JOIN Brands_DIM b ON b.name = s.Maker
JOIN Models_DIM m ON m.name = s.Model AND m.brand_key = b.brand_key
);

# Merging duplicates in sales_copy
CREATE VIEW duplicates AS (
SELECT model_key,
       SUM(Year_2020),
       SUM(Year_2019),
       SUM(Year_2018),
       SUM(Year_2017),
       SUM(Year_2016),
       SUM(Year_2015),
       SUM(Year_2014),
       SUM(Year_2013),
       SUM(Year_2012),
       SUM(Year_2011),
       SUM(Year_2010),
       SUM(Year_2009),
       SUM(Year_2008),
       SUM(Year_2007),
       SUM(Year_2006),
       SUM(Year_2005),
       SUM(Year_2004),
       SUM(Year_2003),
       SUM(Year_2002),
       SUM(Year_2001)
FROM sales_copy
WHERE model_key IN (SELECT model_key
                    FROM (SELECT model_key, COUNT(model_key) AS number
                          FROM sales_copy
                          GROUP BY model_key) x
                    WHERE number > 1)
GROUP BY model_key
);

# Creating the fact table
CREATE TABLE sales_FACT AS (
    SELECT * FROM sales_copy
);

# Deleting duplicates
DELETE FROM sales_FACT
WHERE model_key IN (SELECT model_key FROM duplicates);

# Inserting aggregated duplicates instead
INSERT INTO sales_FACT
SELECT * FROM duplicates;

# Un-pivoting table
CREATE TABLE sales_FACT_unpivot AS (
SELECT s.model_key, p.*
FROM sales_FACT s
CROSS JOIN LATERAL (
    SELECT Year_2020, 2020
    UNION ALL SELECT Year_2019, 2019
    UNION ALL SELECT Year_2018, 2018
    UNION ALL SELECT Year_2017, 2017
    UNION ALL SELECT Year_2016, 2016
    UNION ALL SELECT Year_2015, 2015
    UNION ALL SELECT Year_2014, 2014
    UNION ALL SELECT Year_2013, 2013
    UNION ALL SELECT Year_2012, 2012
    UNION ALL SELECT Year_2011, 2011
    UNION ALL SELECT Year_2010, 2010
    UNION ALL SELECT Year_2009, 2009
    UNION ALL SELECT Year_2008, 2008
    UNION ALL SELECT Year_2007, 2007
    UNION ALL SELECT Year_2006, 2006
    UNION ALL SELECT Year_2005, 2005
    UNION ALL SELECT Year_2004, 2004
    UNION ALL SELECT Year_2003, 2003
    UNION ALL SELECT Year_2002, 2002
    UNION ALL SELECT Year_2001, 2001
    ) AS p(number_sold, year)
);

CREATE TABLE sales_FACT_finished (
    model_key INT NOT NULL,
    year INT NOT NULL,
    number_sold INT,
    PRIMARY KEY (model_key, year),
    FOREIGN KEY (model_key) REFERENCES Models_DIM (model_key)
);

INSERT INTO sales_FACT_finished
SELECT model_key, year, number_sold
FROM sales_FACT_unpivot
ORDER BY model_key, year;

DROP TABLE sales_FACT_unpivot;

RENAME TABLE sales_FACT_finished TO sales_FACT_unpivot;


