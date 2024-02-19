# Checking secure directory for LOAD DATA INFILE
# SHOW VARIABLES LIKE "secure_file_priv";

# Creating database
CREATE DATABASE IF NOT EXISTS capstone_extended;
USE capstone_extended;

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
LOAD DATA INFILE 'Sales_table.csv'
INTO TABLE  sales
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

ALTER TABLE sales
ADD COLUMN Row_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY;