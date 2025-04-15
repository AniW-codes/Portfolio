select *
from Portfolio_Project.dbo.Restaurant_menu_items

select COUNT (*)
from Portfolio_Project.dbo.Restaurant_menu_items

select *
from Portfolio_Project.dbo.Restaurant_menu_items
Order By price desc

--Filter by Italian Dishes 
Select Count(*)
from Portfolio_Project.dbo.Restaurant_menu_items
where category = 'Italian'

--Most expensive and cheapest Italian dishes
Select *
from Portfolio_Project.dbo.Restaurant_menu_items
where category = 'Italian'
Order By price desc

Select *
from Portfolio_Project.dbo.Restaurant_menu_items
where category = 'Italian'
Order By price 

--Total Number of Categories
Select category, COUNT(category) as Total_Count
from Portfolio_Project.dbo.Restaurant_menu_items
group by category


--Average Price of Item in each category
Select category,COUNT(menu_item_id) as Total_Items, AVG(Price) as Average_Price
from Portfolio_Project.dbo.Restaurant_menu_items
Group By category


Select min(order_date), max(order_date)
from Portfolio_Project.dbo.Restaurant_order_details

Select *
from Portfolio_Project.dbo.Restaurant_order_details

--No of Orders made in date range
Select Count(Distinct(Order_id))
from Portfolio_Project.dbo.Restaurant_order_details

--Numbers of Items ordered in the date range
Select Count(*)
from Portfolio_Project.dbo.Restaurant_order_details

--Orders with most Items
Select order_id, count(item_id) as Total_Items_in_Order
from Portfolio_Project.dbo.Restaurant_order_details
Group By order_id
Order By Total_Items_in_Order desc

--Orders more than 12 items
--(In SSMS, we cannot filter from the column created in select statement, hence we must create a CTE)
With CTE_Restaurant as (
Select order_id, COUNT(item_id) as Total_Items_in_Order
from Portfolio_Project.dbo.Restaurant_order_details
Group By order_id
)
Select Count(*)
from CTE_Restaurant
where Total_Items_in_Order > 12

----------

select *
from Portfolio_Project.dbo.Restaurant_menu_items

Select *
from Portfolio_Project.dbo.Restaurant_order_details

--JOIN both tables
Select *
from Portfolio_Project.dbo.Restaurant_order_details 
left join Portfolio_Project.dbo.Restaurant_menu_items 
	on Portfolio_Project.dbo.Restaurant_menu_items.menu_item_id = Portfolio_Project.dbo.Restaurant_order_details.item_id
	
--Least and the most ordered items
Select item_name, count(item_name) as num_ordered, category
from Portfolio_Project.dbo.Restaurant_order_details 
left join Portfolio_Project.dbo.Restaurant_menu_items 
	on Portfolio_Project.dbo.Restaurant_menu_items.menu_item_id = Portfolio_Project.dbo.Restaurant_order_details.item_id
	GROUP BY item_name, category
	ORDER BY num_ordered desc

--Top 5 most spent orders 
Select TOP (5) order_id, sum(price) as Tot_Spent_Per_Order
from Portfolio_Project.dbo.Restaurant_order_details 
left join Portfolio_Project.dbo.Restaurant_menu_items 
	on Portfolio_Project.dbo.Restaurant_menu_items.menu_item_id = Portfolio_Project.dbo.Restaurant_order_details.item_id
	GROUP BY order_id
	ORDER BY Tot_Spent_Per_Order DESC

--Details of Higest spent order = order#440
Select *
from Portfolio_Project.dbo.Restaurant_order_details 
left join Portfolio_Project.dbo.Restaurant_menu_items 
	on Portfolio_Project.dbo.Restaurant_menu_items.menu_item_id = Portfolio_Project.dbo.Restaurant_order_details.item_id
	where order_id = 440

--Insights of Order#440
Select category, count(item_id) as Num_Items, sum(price) as Total_Cost
from Portfolio_Project.dbo.Restaurant_order_details 
left join Portfolio_Project.dbo.Restaurant_menu_items 
	on Portfolio_Project.dbo.Restaurant_menu_items.menu_item_id = Portfolio_Project.dbo.Restaurant_order_details.item_id
	where order_id = 440
	group By category

--Insights of all TOP 5 Orders
Select order_id, category, count(item_id) as Num_Items, sum(price) as Total_Cost
from Portfolio_Project.dbo.Restaurant_order_details 
left join Portfolio_Project.dbo.Restaurant_menu_items 
	on Portfolio_Project.dbo.Restaurant_menu_items.menu_item_id = Portfolio_Project.dbo.Restaurant_order_details.item_id
	where order_id in (440, 2075, 1957, 330, 2675)
	group By category, order_id