# Checking secure directory for LOAD DATA INFILE
# SHOW VARIABLES LIKE "secure_file_priv";

# Creating database
CREATE DATABASE IF NOT EXISTS DataStoringCapstone;

USE DataStoringCapstone;

# Creating ads table
DROP TABLE IF EXISTS ads;
CREATE TABLE ads (
    Maker NVARCHAR(255),
    Genmodel NVARCHAR(255),
    Genmodel_ID NVARCHAR(255),
    Adv_ID NVARCHAR(255),
    Adv_year NVARCHAR(255),
    Adv_month NVARCHAR(255),
    Color NVARCHAR(255),
    Reg_year NVARCHAR(255),
    Bodytype NVARCHAR(255),
    Runned_Miles NVARCHAR(255),
    Engin_size NVARCHAR(255),
    Gearbox NVARCHAR(255),
    Fuel_type NVARCHAR(255),
    Price NVARCHAR(255),
    Engine_power NVARCHAR(255),
    Annual_Tax NVARCHAR(255),
    Wheelbase NVARCHAR(255),
    Height NVARCHAR(255),
    Width NVARCHAR(255),
    Length NVARCHAR(255),
    Average_mpg NVARCHAR(255),
    Top_speed NVARCHAR(255),
    Seat_num NVARCHAR(255),
    Door_num NVARCHAR(255)
);

# Loading data into ads table
LOAD DATA INFILE '/Users/mpolcyn/DataGripProjects/DW_Capstone/Ad_table_extra.csv'
INTO TABLE  ads
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

# Creating basic table
DROP TABLE IF EXISTS basic;
CREATE TABLE basic (
    Automaker NVARCHAR(255),
    Automaker_ID NVARCHAR(10),
    Genmodel NVARCHAR(255),
    Genmodel_ID NVARCHAR(25)
);

# Loading data into basic table
LOAD DATA INFILE '/Users/mpolcyn/DataGripProjects/DW_Capstone/Basic_table.csv'
INTO TABLE  basic
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

# Creating image table
DROP TABLE IF EXISTS image;
CREATE TABLE image (
    Genmodel_ID NVARCHAR(255),
    Image_ID NVARCHAR(255),
    Image_name NVARCHAR(255),
    Predicted_viewpoint NVARCHAR(255),
    Quality_check NVARCHAR(255)
);

# Loading data into image table
LOAD DATA INFILE '/Users/mpolcyn/DataGripProjects/DW_Capstone/Image_table.csv'
INTO TABLE  image
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

# Creating price table
DROP TABLE IF EXISTS price;
CREATE TABLE price (
    Maker NVARCHAR(255),
    Genmodel NVARCHAR(255),
    Genmodel_ID NVARCHAR(255),
    Year NVARCHAR(255),
    Entry_price NVARCHAR(255)
);

LOAD DATA INFILE '/Users/mpolcyn/DataGripProjects/DW_Capstone/Price_table.csv'
INTO TABLE  price
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

# Creating sales table
DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
    Maker NVARCHAR(255),
    Genmodel NVARCHAR(255),
    Genmodel_ID NVARCHAR(255),
    Year_2020 NVARCHAR(255),
    Year_2019 NVARCHAR(255),
    Year_2018 NVARCHAR(255),
    Year_2017 NVARCHAR(255),
    Year_2016 NVARCHAR(255),
    Year_2015 NVARCHAR(255),
    Year_2014 NVARCHAR(255),
    Year_2013 NVARCHAR(255),
    Year_2012 NVARCHAR(255),
    Year_2011 NVARCHAR(255),
    Year_2010 NVARCHAR(255),
    Year_2009 NVARCHAR(255),
    Year_2008 NVARCHAR(255),
    Year_2007 NVARCHAR(255),
    Year_2006 NVARCHAR(255),
    Year_2005 NVARCHAR(255),
    Year_2004 NVARCHAR(255),
    Year_2003 NVARCHAR(255),
    Year_2002 NVARCHAR(255),
    Year_2001 NVARCHAR(255)
);

# Inserting values into sales table
LOAD DATA INFILE '/Users/mpolcyn/DataGripProjects/DW_Capstone/Sales_table.csv'
INTO TABLE  sales
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

# Creating trim table
DROP TABLE IF EXISTS trim;
CREATE TABLE trim (
    Genmodel_ID NVARCHAR(255),
    Maker NVARCHAR(255),
    Genmodel NVARCHAR(255),
    Trim NVARCHAR(255),
    Year NVARCHAR(255),
    Price NVARCHAR(255),
    Gas_emission NVARCHAR(255),
    Fuel_type NVARCHAR(255),
    Engine_size NVARCHAR(255)
);

LOAD DATA INFILE '/Users/mpolcyn/DataGripProjects/DW_Capstone/trim_table.csv'
INTO TABLE  trim
FIELDS TERMINATED BY ','
IGNORE 1 LINES;