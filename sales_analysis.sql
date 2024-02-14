USE DataStoringCapstone;

# Sales

# Are names unique for IDs? No, some IDs are assigned to multiple names
SELECT
    (SELECT COUNT(DISTINCT Genmodel) FROM sales) AS unique_names,
    (SELECT COUNT(DISTINCT Genmodel_ID) FROM sales) AS unique_ID;

# Which IDs have multiple names?
# Seems like IDs repeat for cars that are basically the same but are being sold under different names/brands
# in different parts of the world, such as Citroen DS3 and DS 3
SELECT Genmodel, Genmodel_ID
FROM sales
WHERE Genmodel_ID IN (SELECT Genmodel_ID
                   FROM (SELECT Genmodel_ID, COUNT(DISTINCT Genmodel) AS number
                         FROM sales
                         GROUP BY Genmodel_ID
                         HAVING number > 1) duplicates)
ORDER BY Genmodel_ID;

# To split or not to split?

# I think it depends on the particular case.
# Some models have up to 5 different names, that are slightly different subtypes of the same model.
# Others, on the other hand, have only 2 values and differences are irrelevant.

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




