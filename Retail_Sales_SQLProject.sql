--Data Cleaning

Select *
from Portfolio_Project.dbo.Retail_Sales_Analysis
Where transactions_id is NULL
or sale_date is NULL
or sale_time is NULL
or customer_id is NULL
or gender is NULL
or category is NULL
or quantiy is NULL
or price_per_unit is NULL
or cogs is NULL
or total_sale is NULL

DELETE from Portfolio_Project.dbo.Retail_Sales_Analysis
WHERE transactions_id is NULL
or sale_date is NULL
or sale_time is NULL
or customer_id is NULL
or gender is NULL
or category is NULL
or quantiy is NULL
or price_per_unit is NULL
or cogs is NULL
or total_sale is NULL

Select *
from Portfolio_Project.dbo.Retail_Sales_Analysis

--Data Exploration

--Unique customers

Select Count(Distinct(Customer_id)) as Total_Customers_Unique
from Portfolio_Project.dbo.Retail_Sales_Analysis

--Count of Categories
Select Count(Distinct(category)) as Total_Categories_Unique
from Portfolio_Project.dbo.Retail_Sales_Analysis

Select Distinct(category) as Total_Categories_Unique
from Portfolio_Project.dbo.Retail_Sales_Analysis

--Data Analysis and Business Problems

-- All Sales made on 5th November
Select * 
from Portfolio_Project.dbo.Retail_Sales_Analysis
Where sale_date = '2022-11-05'


---Adding Month to the table
Select sale_date, DATENAME(MONTH, sale_date)
from Portfolio_Project.dbo.Retail_Sales_Analysis

Alter Table Portfolio_Project.dbo.Retail_Sales_Analysis
Add Month_Sale varchar(20)

Update Portfolio_Project.dbo.Retail_Sales_Analysis
Set Month_Sale = DATENAME(MONTH, sale_date)


---Adding YEAR to the table
Select sale_date, DATENAME(YEAR, sale_date)
from Portfolio_Project.dbo.Retail_Sales_Analysis

Alter Table Portfolio_Project.dbo.Retail_Sales_Analysis
Add Year_Sale int

Update Portfolio_Project.dbo.Retail_Sales_Analysis
Set Year_Sale = DATENAME(YEAR, sale_date)

Select *
from Portfolio_Project.dbo.Retail_Sales_Analysis


---Adding WEEKDAY to the table
Select sale_date, DATENAME(WEEKDAY, sale_date)
from Portfolio_Project.dbo.Retail_Sales_Analysis

Alter Table Portfolio_Project.dbo.Retail_Sales_Analysis
Add Weekday_Sale varchar(20)

Update Portfolio_Project.dbo.Retail_Sales_Analysis
Set Weekday_Sale = DATENAME(WEEKDAY, sale_date)

Select *
from Portfolio_Project.dbo.Retail_Sales_Analysis


--Sales made in November 2022 under clothing category and >= 4 items
Select *
from Portfolio_Project.dbo.Retail_Sales_Analysis
WHERE category = 'Clothing'
	and quantiy >= 4
	and Month_Sale = 'November'
	and Year_Sale = 2022

--Total Sales of each category
Select category, SUM(total_sale), Count(*) as Total_Orders
from Portfolio_Project.dbo.Retail_Sales_Analysis
group by category
		
--Avg age of customers purchasing from Beauty category
Select ROUND(Avg(Age), +2)
from Portfolio_Project.dbo.Retail_Sales_Analysis
where category = 'Beauty'

--Total Sale > 1000
Select * 
from Portfolio_Project.dbo.Retail_Sales_Analysis
where total_sale > 1000

--Total transactions made by each gender in each category
Select Gender, Category, COUNT(*) as Total_Transactions
from Portfolio_Project.dbo.Retail_Sales_Analysis
Group By Gender, category
Order By 1

--Avg_Sale for each month with Month Rankings
With CTE_Monthly_Sale as (
Select 
	Year_Sale, 
	Month_Sale, 
	Round(Avg(total_sale), 3) as Average_Sale_per_Month,
	RANK() OVER(Partition By Year_Sale Order By Avg(total_sale) Desc) as MonthRank
from Portfolio_Project.dbo.Retail_Sales_Analysis
GROUP BY Year_Sale, Month_Sale
							)
Select * from 
CTE_Monthly_Sale where MonthRank = 1

--Top 5 customers based on highest total sales
Select TOP(5) customer_id, 
		sum(total_sale) as Sum
		from Portfolio_Project.dbo.Retail_Sales_Analysis
GROUP BY customer_id
Order By Sum desc

--No of unique customers who purchased items from each category
Select 
	category,
	Count(Distinct(Customer_id)) as Unique_Customers
from Portfolio_Project.dbo.Retail_Sales_Analysis
group By category

--Query to create each shift based on time of the day (Morning, Evening, Afternoon etc)
Select 
	* ,
	CASE When DATEPART(HOUR, sale_time) < 12 then 'Morning'
		When DATEPART(HOUR, sale_time) between 12 and 17 then 'Afternoon'
		Else 'Evening'
	END as Shifts
from Portfolio_Project.dbo.Retail_Sales_Analysis

--Since group by cannot be used on column created in select statement, we need to use a CTE to make it happen.
--Query to create number of orders in different time of the day	

Select *
from Portfolio_Project.dbo.Retail_Sales_Analysis

With CTE_Orders as (
				Select 	* ,
	CASE When DATEPART(HOUR, sale_time) < 12 then 'Morning'
		When DATEPART(HOUR, sale_time) between 12 and 17 then 'Afternoon'
		Else 'Evening'
	END as Shifts
from Portfolio_Project.dbo.Retail_Sales_Analysis
				)
Select Shifts, Count(*) as Orders_in_those_hours
from CTE_Orders
group By Shifts

--Select DATEPART(Hour, GETDATE())