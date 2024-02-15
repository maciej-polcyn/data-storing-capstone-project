USE warehousing_capstone;

# Helper query for checking the longest string in column
SELECT MAX(len) AS longest
FROM (SELECT LENGTH(Maker) AS len
FROM sales) x;

# Creating Brands_DIM table
CREATE TABLE Brands_DIM (
    brand_key INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name NVARCHAR(25)
);

INSERT INTO Brands_DIM (name)
SELECT DISTINCT Maker
FROM sales;

# Creating Models_DIM table
CREATE TABLE Models_DIM (
    model_key INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name NVARCHAR(30),
    brand_key INT NOT NULL,
    FOREIGN KEY (brand_key) REFERENCES Brands_DIM (brand_key)
);

INSERT INTO Models_DIM (name, brand_key)
SELECT
    DISTINCT Genmodel,
    brand_key AS brand_key
FROM sales s
JOIN Brands_DIM b ON b.name = s.Maker;

# Inserting brand and model keys into sales
ALTER TABLE sales
    ADD COLUMN brand_key INT NOT NULL,
    ADD COLUMN model_key INT NOT NULL;

UPDATE sales
SET brand_key = (SELECT brand_key
                 FROM Brands_DIM
                 WHERE sales.Maker = Brands_DIM.name);

UPDATE sales
SET model_key = (SELECT model_key
                 FROM Models_DIM
                 WHERE sales.Genmodel = Models_DIM.name AND sales.brand_key = Models_DIM.brand_key);

# Finding duplicates in sales
SELECT * FROM sales
WHERE model_key IN (
SELECT model_key
FROM (SELECT model_key, COUNT(model_key) AS number
      FROM sales
      GROUP BY model_key) x
WHERE number > 1);

# Merging duplicates in a helper view
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
FROM sales
WHERE model_key IN (SELECT model_key
                    FROM (SELECT model_key, COUNT(model_key) AS number
                          FROM sales
                          GROUP BY model_key) x
                    WHERE number > 1)
GROUP BY model_key
);

# Creating sales_FACT table
CREATE TABLE Sales_FACT AS (
    SELECT
        model_key,
        Year_2020 AS year_2020,
        Year_2019 AS year_2019,
        Year_2018 AS year_2018,
        Year_2017 AS year_2017,
        Year_2016 AS year_2016,
        Year_2015 AS year_2015,
        Year_2014 AS year_2014,
        Year_2013 AS year_2013,
        Year_2012 AS year_2012,
        Year_2011 AS year_2011,
        Year_2010 AS year_2010,
        Year_2009 AS year_2009,
        Year_2008 AS year_2008,
        Year_2007 AS year_2007,
        Year_2006 AS year_2006,
        Year_2005 AS year_2005,
        Year_2004 AS year_2004,
        Year_2003 AS year_2003,
        Year_2002 AS year_2002,
        Year_2001 AS year_2001
FROM sales);

SELECT
    COUNT(DISTINCT model_key) AS unique_keys,
    COUNT(*) AS nr_rows
FROM Sales_FACT;

# Deleting duplicates
DELETE FROM Sales_FACT
WHERE model_key IN (SELECT model_key FROM duplicates);

# Inserting aggregated duplicates instead
INSERT INTO Sales_FACT
SELECT * FROM duplicates;

# Setting keys for Sales_FACT
ALTER TABLE Sales_FACT
    ADD CONSTRAINT PRIMARY KEY Sales_FACT (model_key),
    ADD CONSTRAINT FOREIGN KEY Sales_FACT (model_key) REFERENCES Models_DIM (model_key);

# Un-pivoting table
CREATE VIEW unpivot AS (
SELECT s.model_key, p.*
FROM Sales_FACT s
CROSS JOIN LATERAL (
    SELECT year_2020, 2020
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

CREATE TABLE Sales_FACT_unpivot (
    model_key INT NOT NULL,
    year INT NOT NULL,
    number_sold INT,
    PRIMARY KEY (model_key, year),
    FOREIGN KEY (model_key) REFERENCES Models_DIM (model_key)
);

INSERT INTO Sales_FACT_unpivot
SELECT model_key, year, number_sold
FROM unpivot
ORDER BY model_key, year;



