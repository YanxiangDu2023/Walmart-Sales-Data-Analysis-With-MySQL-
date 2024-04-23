CREATE DATABASE IF NOT EXISTS walmart;

CREATE TABLE IF NOT EXISTS sales(
     invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
     branch VARCHAR(5) NOT NULL,
     city VARCHAR(30) NOT NULL,
     customer_type VARCHAR(30) NOT NULL,
     gender VARCHAR(30) NOT NULL,
     product_line VARCHAR(100) NOT NULL,
     unit_price DECIMAL(10,2) NOT NULL,
     quantity INT NOT NULL,
     VAT FLOAT(6,4) NOT NULL,
     total DECIMAL(12,4) NOT NULL,
     data DATETIME NOT NULL,
     time TIME NOT NULL,
     payment_method VARCHAR(15) NOT NULL,
     cogs DECIMAL(10,2) NOT NULL,
     gross_margin_pct FLOAT(11,9),
     gross_income DECIMAL(12,4) NOT NULL,
     ratting FLOAT(2,1) 
);



-- ------------------------------------------------------------------------------------
-- ----------------------------Feature Engineering-------------------------------------

-- time_of_day

SELECT 
     time, /*注意,*/
     (CASE
		 WHEN  'time' BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
         WHEN  'time' BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
         ELSE "Evening"
	  END
      ) AS time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20); /*增加一列*/

UPDATE sales 
SET time_of_day = (
CASE
		 WHEN  'time' BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
         WHEN  'time' BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
         ELSE "Evening"
END
);

-- -----------------------------------------------
-- day_name

SELECT
    data,
    DAYNAME(data) AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10); /*增加一列*/

UPDATE sales
SET day_name = DAYNAME(data);


-- -------------------------------------------------------

-- month_name

SELECT 
     date,
     MONTHNAME(data)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(data);

-- -----------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------
-- ----------------------------------Generic-------------------------------------------

-- How many unique cities does the data have?
SELECT 
     DISTINCT city 
FROM sales;

SELECT 
     DISTINCT branch
FROM sales;


-- In which city is each branch?
SELECT 
     DISTINCT city, branch
     /* DISTINCT 关键字用于从结果集中消除重复的行，
     确保返回的结果集中每一行都是唯一的。在 SELECT 查询中，可以将 DISTINCT 放置在列名之前，以指示数据库检索唯一的值，并排除重复项。*/
FROM sales;









