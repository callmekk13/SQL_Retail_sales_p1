-- SQL Retial Sales Analyst - P1
create database sql_project_p2 ;

create table if not exists retail_sales
(
		transactions_id INT primary key,
		sale_date DATE,
		sale_time TIME,
		customer_id INT,
		gender VARCHAR(15),
		age	INT,
		category VARCHAR(15),
		quantiy INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale FLOAT
);

select current_database();

SELECT *
FROM information_schema.tables
WHERE table_name ILIKE '%retail%';

SELECT *
FROM information_schema.tables
WHERE table_name = 'retail_sales';

SELECT current_database();

SELECT schemaname, tablename
FROM pg_tables
WHERE tablename = 'retail_sales';

select * from retail_sales111 rs 
limit 10

select
	count(*)
from retail_sales111 rs 
limit 10


select * from retail_sales111 rs 
where
	rs.transactions_id is null
	or
	customer_id is null
	or
	sale_time is null
	or
	sale_date is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or 
	quantiy is null 
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

SELECT AVG(age)
FROM retail_sales111;

update retail_sales111
set age =(
	select round(avg(age))
	from retail_sales111
)
where age is null;

-- DATA CLEANING

DELETE FROM retail_sales111 rs
WHERE transactions_id IS NULL
   OR customer_id IS NULL
   OR sale_time IS NULL
   OR sale_date IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantiy IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- DATA EXPLORATION

-- How many sales do we have ?
select COUNT(*) as total_sale from retail_sales111 rs 

-- How many customers do we have ?
select COUNT(*) as customer_id from retail_sales111 rs

-- How many unique customers do we have ?
select count(distinct customer_id) as total_sales from retail_sales111 rs

-- How many unique cateogry do we have ?
select count(distinct category) from retail_sales111 rs

-- Data Analysis & Business Key problems and Answers

--Q1) Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retail_sales111 rs 
where sale_date = '2022-11-05';

--Q2) Write a SQL query to retrieve all transactions where the category is 
--'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
select
	*
from retail_sales111 rs 
where 
	category = 'Clothing'
	and
	to_char(sale_date, 'YYYY-MM') = '2022-11'
	and 
	quantiy >= 4;

select category from retail_sales111 rs 

--Q3) Write a SQL query to calculate the total sales (total_sale) for each category.
select
	category,
	sum(total_sale) as net_sale
from retail_sales111 rs
group by 1;


select
	category,
	sum(total_sale)as net_sale,
	count(*) as total_orders
from retail_sales111 rs 
group by 1

--Q4) Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select
	round(avg(age),2) as avg_age
from retail_sales111 rs 
where category = 'Beauty'

--Q5) Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales111 rs 
where total_sale > 1000

--Q6) Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select
	category,
	gender,
	count(*) as total_transactions
from retail_sales111 rs 
group by
	category,
	gender
order by 1
--Q7) Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select 
	year,
	month,
	avg_sale
from
(
select 
	extract (YEAR from sale_date) as year,
	extract (month from sale_date) as month,
	avg(total_sale)as avg_sale,
	rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
from retail_sales111 rs
group by 1,2
--order by 1,3 desc
) as t1
where rank = 1

--Q8) Write a SQL query to find the top 5 customers based on the highest total sales 
select
	customer_id,
	sum(total_sale) as total_sales
from retail_sales111
group by 1
order by 1,2 desc
limit 5
--Q9) Write a SQL query to find the number of unique customers who purchased items from each category.
select 
	category,
	count(distinct customer_id) as count_unique_customer
from retail_sales111
group by category
--Q10) Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
with hourly_sale
as
(
select *,
	case
		when extract(hour from sale_time) < 12 then 'morning'
		when extract(hour from sale_time) between 12 and 17 then 'afternoon'
		else 'evening'
	end as shift
from retail_sales111
)
select
	shift,
	count(*) as total_orders
from hourly_sale
group by shift

--END OF PROJECT
