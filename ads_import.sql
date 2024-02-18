USE capstone_extended;

# Blanks filled with '\N' in python
DROP TABLE IF EXISTS ads;
CREATE TABLE ads (
    Maker NVARCHAR(255),
    Genmodel NVARCHAR(255),
    Genmodel_ID NVARCHAR(255),
    Adv_Year NVARCHAR(255),
    Adv_Month NVARCHAR(255),
    Color NVARCHAR(255),
    Body_Type NVARCHAR(255),
    Gearbox_Type NVARCHAR(255),
    Fuel_Type NVARCHAR(255),
    Reg_Year NVARCHAR(255),
    Mileage NVARCHAR(255),
    Engine_Size NVARCHAR(255),
    Price NVARCHAR(255),
    Engine_Power NVARCHAR(255),
    Annual_Tax NVARCHAR(255),
    Wheelbase NVARCHAR(255),
    Height NVARCHAR(255),
    Width NVARCHAR(255),
    Length NVARCHAR(255),
    Average_Mpg NVARCHAR(255),
    Top_Speed NVARCHAR(255),
    Seat_Num NVARCHAR(255),
    Door_Num NVARCHAR(255)
);

LOAD DATA INFILE '/Users/mpolcyn/DataGripProjects/DW_Capstone/capstone_data_NULL.csv'
INTO TABLE  ads
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

# Defining null constraints for each column
# DROP TABLE IF EXISTS ads;
# CREATE TABLE ads (
#     Maker NVARCHAR(255),
#     Genmodel NVARCHAR(255),
#     Genmodel_ID NVARCHAR(255),
#     Adv_Year NVARCHAR(255),
#     Adv_Month NVARCHAR(255),
#     Color NVARCHAR(255),
#     Body_Type NVARCHAR(255),
#     Gearbox_Type NVARCHAR(255),
#     Fuel_Type NVARCHAR(255),
#     Reg_Year NVARCHAR(255),
#     Mileage NVARCHAR(255),
#     Engine_Size NVARCHAR(255),
#     Price NVARCHAR(255),
#     Engine_Power NVARCHAR(255),
#     Annual_Tax NVARCHAR(255),
#     Wheelbase NVARCHAR(255),
#     Height NVARCHAR(255),
#     Width NVARCHAR(255),
#     Length NVARCHAR(255),
#     Average_Mpg NVARCHAR(255),
#     Top_Speed NVARCHAR(255),
#     Seat_Num NVARCHAR(255),
#     Door_Num NVARCHAR(255)
# );
#
# # Loading data into ads table
# LOAD DATA INFILE '/Users/mpolcyn/DataGripProjects/DW_Capstone/capstone_data_clean.csv'
# INTO TABLE  ads
# FIELDS TERMINATED BY ','
# LINES TERMINATED BY '\n'
# IGNORE 1 LINES
# SET
#     Color = NULLIF(Color, ''),
#     Body_Type = NULLIF(Body_Type, ''),
#     Gearbox_Type = NULLIF(Gearbox_Type, ''),
#     Fuel_Type = NULLIF(Fuel_Type, ''),
#     Reg_Year = NULLIF(Reg_Year, ''),
#     Mileage = NULLIF(Mileage, ''),
#     Engine_Size = NULLIF(Engine_Size, ''),
#     Price = NULLIF(Price, ''),
#     Engine_Power = NULLIF(Engine_Power, ''),
#     Annual_Tax = NULLIF(Annual_Tax, ''),
#     Wheelbase = NULLIF(Wheelbase, ''),
#     Height = NULLIF(Height, ''),
#     Width = NULLIF(Width, ''),
#     Length = NULLIF(Length, ''),
#     Average_Mpg = NULLIF(Average_Mpg, ''),
#     Top_Speed = NULLIF(Top_Speed, ''),
#     Seat_Num = NULLIF(Seat_Num, ''),
#     Door_Num = NULLIF(Door_Num, '');


