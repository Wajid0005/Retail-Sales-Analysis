CREATE SCHEMA sql_p1;

#MADE THE SCEHMA AND CREATED A TABLE
DROP TABLE IF EXISTS sql_p1.retail_sales;
create table 	sql_p1.retail_sales
	(
		transaction_id INT PRIMARY KEY,
        sale_date DATE,
        sale_time TIME,
        customer_id INT,
        gender VARCHAR(15),
        age INT,
        category VARCHAR(15),
        quantity INT,
        price_per_unit FLOAT,
        cogs FLOAT,
        total_sales float
    );
    
 select * from sql_p1.retail_sales_data;
select count(customer_id) from sql_p1.retail_sales_data;
#IMPORTED THE CSV FILE IN THE TABLE

# DATA CLEANINIG (removing the nulls)
select count(*) from sql_p1.retail_sales_data
WHERE transaction_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sales IS NULL;
   
#CHECKED IF ANY CELL IS NULL OR NOT
#AS THERE IS NO NULL IN ANY OF THE CELL SO NO DELETION REQUIRE

SELECT count(*) FROM sql_p1.retail_sales_data
where cogs is null;

#EXPLORITORY DATA ANALYSIS

#1. Sales per gender and category
select 
	gender,
    category,
    count(*) as NUM_OF_PURCHASED
from sql_p1.retail_sales_data
group by 
	gender, 
    category
order by
	gender,
    category
;

#2 All sales on 5th NOV 2025

select * 
from sql_p1.retail_sales_data
where sale_date = '2022-11-05';

select sum(total_sales) as TOTAL_SALES
from sql_p1.retail_sales_data
where sale_date =  '2022-11-05';

#3 Find all transactions from November 2022 in the 'clothing' category where the quantity sold was greater than or equal to three.

select *
from sql_p1.retail_sales_data
where 
	month(sale_date) = 11
    and
    category = 'clothing'
    and
    quantiy >= 3 #spelling mistake
 order by quantiy;
 
    
#4 Calculate the total sales for each product category.

select
	category as CATEGORY,
    sum(total_sale) as TOTAL_SALES
from sql_p1.retail_sales_data
group by category
order by CATEGORY desc;

#5 Find the agerage of cust who buys beaty products

select 
	avg(age) as AVERAGE_AGE
from sql_p1.retail_sales_data
where category = 'Beauty';

#6 Transaction where total sales > 1000

select * 
from sql_p1.retail_sales_data
where total_sale > 1000
order by total_sale;

#7.1 Calculate the average sale for each month of each year.

select
	extract(year from sale_date) as sale_year,
    extract(month from sale_date) as sale_month,
    avg(total_sale) as avg_sales
    
from sql_p1.retail_sales_data

group by
	sale_year,
    sale_month
order by
	sale_year,
    sale_month;

# 7.2 he best-selling month (highest avg_sales) for each year?
# I find top 10 so it works

select
	extract(year from sale_date) as YEAR,
    extract(month from sale_date) as MONTH,
    extract(day from sale_date) as DAY,
    total_sale as SALES_GREATER_THAN_AVG
from sql_p1.retail_sales_data
where 
	total_sale > (
		select avg(total_sale)
        from sql_p1.retail_sales_data
        )
order by
	SALES_GREATER_THAN_AVG desc
    limit  10;
        
#8 Find the top five customers based on their total sales volume.

select
	ï»¿transactions_id as TRANSACTION_ID,
    sum(total_sale) as TOTAL_SPENT
from
	sql_p1.retail_sales_data
group by ï»¿transactions_id
order by TOTAL_SPENT desc
limit 5;

#9 the number of unique customers who have made purchases in each product category

select
	category,
    count(distinct ï»¿transactions_id) as UNIQUE_CUSTOMER
    
from 
	sql_p1.retail_sales_data
group by
	category;
    
select * from sql_p1.retail_sales_data
;
    
#10 Create time-based shifts (e.g., Morning, Afternoon, Evening) and find the number of orders (transactions) that fall into each shift.


select
	case
		when sale_time between '06:00:00' and '11:59:59' then 'MORNING'
        when sale_time between '12:00:00' and '17:59:59' then 'NOON'
        when sale_time between '18:00:00' and '20:59:59' then 'EVENING'
		else 'NIGHT'
	end as sales_shift ,
    count(*) as Transaction
from 
sql_p1.retail_sales_data
group by sales_shift
order by Transaction desc
;
