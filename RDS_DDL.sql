DROP SCHEMA Retail;
CREATE SCHEMA  Retail;

USE Retail;

DROP TABLE Fact_table;
DROP TABLE Customer_dim ;
DROP TABLE Store_dim ;
DROP TABLE Product_dim ;
DROP TABLE Date_dim ;

CREATE TABLE IF NOT EXISTS  Retail.Fact_table (
	order_id int NOT NULL PRIMARY KEY ,
	customer_id int NOT NULL,
	product_id int NOT NULL,
	date_id bigint NOT NULL,
	store_id int NOT NULL,
	quantity int NOT NULL,
	amount int NOT NULL
);
CREATE TABLE IF NOT EXISTS  Retail.Customer_dim(
      customer_id int NOT NULL Primary Key,
      first_name varchar(32) NOT NULL,
      last_name varchar(32) NOT NULL,
      email_address varchar(32),
      Address varchar(32),
      city varchar(32),
      state varchar(32),
      zipcode VARCHAR(10) NOT NULL,
      join_date DATE NOT NULL
      
);
CREATE TABLE IF NOT EXISTS Retail.Store_dim(
      store_id int NOT NULL Primary Key,
      store_name varchar(32) NOT NULL,
      manager_name varchar(32) NOT NULL,
      Address varchar(32),
      city varchar(32),
      state varchar(32),
      zipcode VARCHAR(10) NOT NULL
);


CREATE TABLE IF NOT EXISTS Retail.Product_dim(
		product_id int NOT NULL PRIMARY KEY,
		product_name varchar(32) NOT NULL ,
		product_category varchar(32) NOT NULL,
		manufacture_Name varchar(32),
		address varchar(32),
        city varchar(32),
        state varchar(32),
        zipcode VARCHAR(10) NOT NULL
);

-- ALTER TABLE Retail.Product_dim
-- RENAME COLUMN Category TO Product_category;


DROP TABLE IF EXISTS Retail.Date_dim;


-- Small-numbers table
DROP TABLE IF EXISTS numbers_small;
CREATE TABLE numbers_small (number INT);
INSERT INTO numbers_small VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

-- Main-numbers table
DROP TABLE IF EXISTS numbers;
CREATE TABLE numbers (number BIGINT);
INSERT INTO numbers
SELECT thousands.number * 1000 + hundreds.number * 100 + tens.number * 10 + ones.number
FROM numbers_small thousands, numbers_small hundreds, numbers_small tens, numbers_small ones
LIMIT 1000000;

-- Create Date Dimension table
DROP TABLE IF EXISTS Date_dim;
CREATE TABLE Date_dim (
date_id          BIGINT PRIMARY KEY,
date             DATE NOT NULL,
year             INT,
month            CHAR(10),
month_of_year    CHAR(2),
day_of_month     INT,
day              CHAR(10),
day_of_week      INT,
weekend          CHAR(10) NOT NULL DEFAULT "Weekday",
day_of_year      INT,
week_of_year     CHAR(2),
quarter  INT,
previous_day     date NOT NULL default '0000-00-00',
next_day         date NOT NULL default '0000-00-00',
UNIQUE KEY `date` (`date`));

-- First populate with ids and Date
-- Change year start and end to match your needs. The above sql creates records for year 2010.
INSERT INTO Date_dim (date_id, date)
SELECT number, DATE_ADD( '2010-01-01', INTERVAL number DAY )
FROM numbers
WHERE DATE_ADD( '2010-01-01', INTERVAL number DAY ) BETWEEN '2010-01-01' AND '2024-12-31'
ORDER BY number;

-- Update other columns based on the date.
UPDATE Date_dim SET
year            = DATE_FORMAT( date, "%Y" ),
month           = DATE_FORMAT( date, "%M"),
month_of_year   = DATE_FORMAT( date, "%m"),
day_of_month    = DATE_FORMAT( date, "%d" ),
day             = DATE_FORMAT( date, "%W" ),
day_of_week     = DAYOFWEEK(date),
weekend         = IF( DATE_FORMAT( date, "%W" ) IN ('Saturday','Sunday'), 'Weekend', 'Weekday'),
day_of_year     = DATE_FORMAT( date, "%j" ),
week_of_year    = DATE_FORMAT( date, "%V" ),
quarter         = QUARTER(date),
previous_day    = DATE_ADD(date, INTERVAL -1 DAY),
next_day        = DATE_ADD(date, INTERVAL 1 DAY);


UPDATE Date_dim
SET date_id = DATE_FORMAT(date, '%Y%m%d')
WHERE date IS NOT NULL;



ALTER TABLE Retail.Fact_table
ADD CONSTRAINT   Product_key_fk FOREIGN KEY (product_id) REFERENCES Product_dim (product_id);

ALTER TABLE Retail.Fact_table 
ADD CONSTRAINT   Customer_key_fk FOREIGN KEY (customer_id) REFERENCES Customer_dim (customer_id);


ALTER TABLE Retail.Fact_table 
ADD CONSTRAINT   Date_key_fk FOREIGN KEY (date_id) REFERENCES Date_dim (date_id);

ALTER TABLE Retail.Fact_table 
ADD CONSTRAINT   Store_key_fk FOREIGN KEY (store_id) REFERENCES Store_dim (store_id);
#
-- 
-- TRUNCATE TABLE Retail.Customer_dim ;
-- TRUNCATE TABLE Retail.Date_dim;
-- TRUNCATE TABLE Retail.Fact_table;
-- TRUNCATE TABLE Retail.Store_dim ;
-- TRUNCATE TABLE Retail.Product_dim;



