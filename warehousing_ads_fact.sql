# Identifying new Brand names in ads table
USE capstone_extended;

SELECT DISTINCT Maker
FROM ads
WHERE Maker NOT IN (
    SELECT DISTINCT name
    FROM Brands_DIM);

# Inserting new names into Brands_DIM table
INSERT INTO Brands_DIM (name)
SELECT DISTINCT Maker
FROM ads
WHERE Maker NOT IN (
    SELECT DISTINCT name
    FROM Brands_DIM);

# Viewing data in preparation for inserting new model into Models_DIM
SELECT DISTINCT Maker, Genmodel, b.brand_key, model_key, a.Genmodel_ID
FROM ads a
JOIN Brands_DIM b ON a.Maker = b.name
LEFT JOIN Models_DIM m ON a.Genmodel = m.name AND m.brand_key = b.brand_key
ORDER BY Maker, Genmodel_ID;

# Inserting new records into Models_DIM
INSERT INTO Models_DIM (name, genmodel_ID, brand_key)
WITH joined AS (
SELECT DISTINCT Maker, Genmodel, b.brand_key, model_key, a.Genmodel_ID
FROM ads a
JOIN Brands_DIM b ON a.Maker = b.name
LEFT JOIN Models_DIM m ON a.Genmodel = m.name AND m.brand_key = b.brand_key
ORDER BY Maker, Genmodel_ID)
SELECT Genmodel, Genmodel_ID, brand_key
FROM joined
WHERE model_key IS NULL;

# Checking if there are any duplicated values in Models_DIM
SELECT
    name,
    genmodel_ID,
    brand_key,
    COUNT(DISTINCT model_key) AS count_it
FROM Models_DIM
GROUP BY name, genmodel_ID, brand_key
HAVING count_it > 1;

# Dates_DIM table
CREATE TABLE Dates_DIM(
    date_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    year INT NOT NULL,
    month_ID INT NOT NULL,
    month_name NVARCHAR(10),
    month_short_name NVARCHAR(3)
);

ALTER TABLE Dates_DIM
    AUTO_INCREMENT=10000;

    SELECT MIN(Adv_Year), MAX(Adv_Year), MIN(Reg_Year), MAX(Reg_Year)
FROM ads;

# Inserting values from a table prepared in python
LOAD DATA INFILE '/Users/mpolcyn/DataGripProjects/DW_Capstone/dates.csv'
INTO TABLE Dates_DIM
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(year, month_ID, month_name, month_short_name);

# Preparing Body_Types_DIM table
SELECT MAX(len) FROM (
    SELECT DISTINCT ads.Body_Type, Length(Body_Type) AS len
    FROM ads
    WHERE Body_Type IS NOT NULL
    ORDER BY Body_Type
                     ) x;

CREATE TABLE Body_Types_DIM(
    body_type_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    type NVARCHAR(30)
);

INSERT INTO Body_Types_DIM (type)
SELECT DISTINCT Body_Type
FROM ads
WHERE Body_Type IS NOT NULL
ORDER BY Body_Type;

# Preparing Fuel_Types_DIM table
SELECT MAX(len) FROM (
    SELECT DISTINCT ads.Fuel_Type, Length(ads.Fuel_Type) AS len
    FROM ads
    WHERE Fuel_Type IS NOT NULL
    ORDER BY Fuel_Type
                     ) x;

CREATE TABLE Fuel_Types_DIM(
    fuel_type_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    type NVARCHAR(50)
);

INSERT INTO Fuel_Types_DIM (type)
SELECT DISTINCT Fuel_Type
FROM ads
WHERE Fuel_Type IS NOT NULL
ORDER BY Fuel_Type;

# Preparing Gearbox_Types_DIM table
SELECT MAX(len) FROM (
    SELECT DISTINCT Gearbox_Type, Length(Gearbox_Type) AS len
    FROM ads
    WHERE Gearbox_Type IS NOT NULL
    ORDER BY Gearbox_Type
                     ) x;

CREATE TABLE Gearbox_Types_DIM(
    gearbox_type_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    type NVARCHAR(50)
);

INSERT INTO Gearbox_Types_DIM (type)
SELECT DISTINCT Gearbox_Type
FROM ads
WHERE Gearbox_Type IS NOT NULL
ORDER BY Gearbox_Type;

# Preparing Colors_DIM table
SELECT MAX(len) FROM (
    SELECT DISTINCT Color, Length(Color) AS len
    FROM ads
    WHERE Color IS NOT NULL
    ORDER BY Color
                     ) x;

CREATE TABLE Colors_DIM(
    color_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name NVARCHAR(25)
);

INSERT INTO Colors_DIM (name)
SELECT DISTINCT Color
FROM ads
WHERE Color IS NOT NULL
ORDER BY Color;

#Preparing Ads_FACT table
CREATE VIEW Ads_FACT_draft AS (
SELECT
    b.brand_key,
    m.model_key,
    d.date_ID,
    c.color_id,
    bt.body_type_id,
    gt.gearbox_type_id,
    ft.fuel_type_id,
    Reg_Year,
    Mileage,
    Engine_Size,
    Price,
    Engine_Power,
    Annual_Tax,
    Wheelbase,
    Height,
    Width,
    Length,
    Average_Mpg,
    Top_Speed,
    Seat_Num,
    Door_Num
FROM ads a
JOIN Brands_DIM b ON b.name = a.Maker
JOIN Models_DIM m ON m.brand_key = b.brand_key AND m.name = a.Genmodel
LEFT JOIN Dates_DIM d ON d.year = a.Adv_Year AND d.month_short_name = a.Adv_Month
LEFT JOIN Colors_DIM c ON c.name = a.Color
LEFT JOIN Body_Types_DIM bt ON bt.type = a.Body_Type
LEFT JOIN Gearbox_Types_DIM gt ON gt.type = a.Gearbox_Type
LEFT JOIN Fuel_Types_DIM ft ON ft.type = a.Fuel_Type);

# Creating Fact table
DROP TABLE IF EXISTS Ads_FACT;
CREATE TABLE Ads_FACT (
    adv_key INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    price INT,
    reg_year INT,
    mileage INT,
    engine_size FLOAT,
    engine_power INT,
    annual_tax INT,
    wheelbase INT,
    height INT,
    width INT,
    length INT,
    avg_mpg FLOAT,
    top_speed INT,
    seat_num INT,
    door_num INT,
    date_key INT,
    model_key INT,
    color_key INT,
    body_type_key INT,
    gearbox_type_key INT,
    fuel_type_key INT,
    FOREIGN KEY (date_key) REFERENCES Dates_DIM(date_ID),
    FOREIGN KEY (model_key) REFERENCES Models_DIM(model_key),
    FOREIGN KEY (color_key) REFERENCES Colors_DIM(color_id),
    FOREIGN KEY (body_type_key) REFERENCES Body_Types_DIM(body_type_id),
    FOREIGN KEY (gearbox_type_key) REFERENCES Gearbox_Types_DIM(gearbox_type_id),
    FOREIGN KEY (fuel_type_key) REFERENCES Fuel_Types_DIM(fuel_type_id)
);

INSERT INTO Ads_FACT (price, reg_year, mileage, engine_size, engine_power, annual_tax, wheelbase, height, width, length, avg_mpg, top_speed, seat_num, door_num, date_key, model_key, color_key, body_type_key, gearbox_type_key, fuel_type_key)
SELECT
    Price,
    Reg_Year,
    Mileage,
    Engine_Size,
    Engine_Power,
    Annual_Tax,
    Wheelbase,
    Height,
    Width,
    Length,
    Average_Mpg,
    Top_Speed,
    Seat_Num,
    Door_Num,
    date_ID,
    model_key,
    color_id,
    body_type_id,
    gearbox_type_id,
    fuel_type_id
FROM ads_fact_draft;

# Alternative method with direct update
UPDATE ads
SET Maker = (SELECT brand_key FROM Brands_DIM b WHERE ads.Maker = b.name),
    Color = (SELECT color_id FROM Colors_DIM c WHERE ads.Color = c.name),
    Body_Type = (SELECT body_type_id FROM Body_Types_DIM bt WHERE ads.Body_Type = bt.type),
    Gearbox_Type = (SELECT gearbox_type_id FROM Gearbox_Types_DIM gt WHERE ads.Gearbox_Type = gt.type),
    Fuel_Type = (SELECT fuel_type_id FROM Fuel_Types_DIM ft WHERE ads.Fuel_Type = ft.type);

ALTER TABLE ads
    ADD COLUMN Date INT;

UPDATE ads
SET
    Genmodel = (SELECT model_key FROM Models_DIM m WHERE ads.Genmodel = m.name AND ads.Maker = m.brand_key),
    Date = (SELECT date_ID FROM Dates_DIM d WHERE ads.Adv_Year = d.year AND ads.Adv_Month = d.month_short_name);
