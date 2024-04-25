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
		 WHEN  time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
         WHEN  time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
         
	  ELSE 'Evening'
	  END
      ) AS time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20); /*增加一列*/

UPDATE sales 
SET time_of_day = (
CASE
		 WHEN   time  BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
         WHEN   time  BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
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

-- -------------------------------------------------------------------------------------
-- ----------------------------------------Product----------------------------------------------
-- How many unique product lines does the data have?
SELECT 
     COUNT(distinct product_line)
From sales;

-- What is the most common payment method?-----------------
select payment_method, count(payment_method) as cnt from sales group by payment_method order by cnt desc;

-- what is the most selling product line?--------------------
select product_line, count(product_line) as cnt 
from sales 
group by product_line order by cnt desc;

-- What is the total revenue by month?----------------
select month_name as month, sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;


-- what month had the largest COGS?------------------
select month_name as month, sum(cogs)as cogs
from sales
group by month_name
order by cogs desc;


-- what product line had the largest revenue ? ------
select product_line, sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

-- what is the city with the largest revenue?------------
select 
branch,
city,
sum(total) as total_revenue
from sales
group by city,branch
order by total_revenue desc;


-- what product line had the largest VAT? 
select product_line, AVG(VAT) as avg_tax
from sales
group by product_line
order by avg_tax desc;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

--  Which branch sold more products than average product sold?
SELECT branch, SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING qty > (SELECT SUM(quantity) / 3 FROM sales);

-- What is the most common product line by gender?
select gender,product_line,count(gender) as total_Cnt
from sales
group by gender,product_line
order by total_cnt desc;


-- What is the average rating of each product line?
select 
     round(avg(ratting),2) as avg_rating,
     product_line
from sales
group by product_line
order by avg_rating desc;
     
-- -------------------------------------------------------
-- --------------------------------sales-------------------

-- Number of sales made in each time of the day per weekday
select time_of_day, count(*) as total_sales
from sales 
where day_name = "Sunday"

group by time_of_day order by total_sales desc;

-- which of the customer types brings the most revenue?-------------
select
      customer_type,
      sum(total) as total_revenue
from sales
group by customer_type
order by total_revenue desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select 
     city,
    avg(VAT) as VAT
from sales
group by city
order by VAT desc;

-- Which customer type pays the most in VAT?-----

select 
   customer_type,
   avg(VAT) as VAT
from sales 
group by customer_type
order by VAT desc;

-- -------------------------------------------------------
-- ---------------Customers --------------------------------
-- How many unique customer types does the data have?----
select 
     distinct customer_type
from sales;


-- How many unique payment methods does the data have?
select
     distinct payment_method
from sales;

-- What is the most common customer type?-------
select
    customer_type,
    count(customer_type) as total_customer_type
from sales
group by customer_type
order by total_customer_type desc;


-- Which customer type buys the most?---------
SELECT
   customer_type,
   SUM(total) AS cus_total /* 返回的结果是每个customer_type和每个customer_type对应的total */
FROM
   sales
GROUP BY
   customer_type
ORDER BY
   cus_total DESC;

-- What is the gender of most of the customers?--------
select 
    gender,
    count(*) as gender_cnt
from sales
group by gender
order by gender_cnt;

-- What is the gender distribution per branch?------------
select 
    gender,
    count(*) as gender_cnt
from sales
where branch = "C"
group by gender
order by gender_cnt;
   
select 
    gender,
    count(*) as gender_cnt
from sales
where branch = "B"
group by gender
order by gender_cnt;
      
select 
    gender,
    count(*) as gender_cnt
from sales
where branch = "A"
group by gender
order by gender_cnt;
   
-- Which time of the day do customers give most ratings?-------
select
     time_of_day,
     avg(ratting) as avg_rating
from sales
group by time_of_day
order by avg_rating desc;
     
-- Which time of the day do customers give most ratings per branch?	
select
     time_of_day,
     avg(ratting) as avg_rating
from sales
where branch = "A"
group by time_of_day
order by avg_rating desc;

select
     time_of_day,
     avg(ratting) as avg_rating
from sales
where branch = "B"
group by time_of_day
order by avg_rating desc;

select
     time_of_day,
     avg(ratting) as avg_rating
from sales
where branch = "C"
group by time_of_day
order by avg_rating desc;

-- Which day fo the week has the best avg ratings?---------------
select 
     day_name,
     avg(ratting) as avg_rating
from sales
group by day_name
order by avg_rating;     

-- Which day of the week has the best average ratings per branch?-----
select 
     day_name,
     avg(ratting) as avg_rating
from sales
where branch = "A"
group by day_name
order by avg_rating;  





