USE DataStoringCapstone;

# Basic

# Is Automaker_ID unique for each Automaker name? Yes
SELECT
    (SELECT COUNT(DISTINCT Automaker) FROM basic) AS unique_names,
    (SELECT COUNT(DISTINCT Automaker_ID) FROM basic) AS unique_ID;

# Is Genmodel_ID unique for each Genmodel name? No
SELECT
    (SELECT COUNT(DISTINCT Genmodel) FROM basic) AS unique_names,
    (SELECT COUNT(DISTINCT Genmodel_ID) FROM basic) AS unique_ID;

# Which models have multiple IDs? Some models form different brands have the same name.
SELECT Automaker, Genmodel, Genmodel_ID
FROM basic
WHERE Genmodel IN (SELECT Genmodel
                   FROM (SELECT Genmodel, COUNT(DISTINCT Genmodel_ID) AS number
                         FROM basic
                         GROUP BY Genmodel
                         HAVING number > 1) x)
ORDER BY Genmodel;

# Are some IDs assigned to multiple names? No
SELECT Genmodel, Genmodel_ID
FROM basic
WHERE Genmodel_ID IN (SELECT Genmodel_ID
                   FROM (SELECT Genmodel_ID, COUNT(DISTINCT Genmodel) AS number
                         FROM basic
                         GROUP BY Genmodel_ID
                         HAVING number > 1) x)
ORDER BY Genmodel_ID;

# Is Genmodel_ID unique for each row? Yes
SELECT
    (SELECT COUNT(*) FROM basic) AS length,
    (SELECT COUNT(DISTINCT Genmodel_ID) FROM basic) AS unique_ID;

# Genmodel_ID is suitable for table primary key
