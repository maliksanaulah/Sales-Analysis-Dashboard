use Coffee_Sales_DB
select * from Coffee_sales


-- Converting columns datatype
Select Column_Name,Data_type from INFORMATION_SCHEMA.Columns
where TABLE_NAME= 'Coffee_sales'


Update Coffee_sales
set transaction_date = CONVERT(DATE,transaction_date, 105)
select Column_Name , DATA_TYPE from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAme='Coffee_sales'

update Coffee_sales
set transaction_time = CONVERT(time,transaction_time,108)

select * from Coffee_sales

select * from Coffee_sales

-- Add New column "sales" and Calculate total sales
select SUM(transaction_qty * unit_price) 
from Coffee_sales

ALTER TABLE coffee_sales
add sales DECIMAL(10,1)

update Coffee_sales
set sales = ROUND((transaction_qty * unit_price),1)

select * from Coffee_sales

-- Total Sales for each month

select  DATENAME(MONTH,transaction_date) as Months, SUM(sales) as Total_sales 
from Coffee_sales
group by DATENAME(MONTH,transaction_date)
order by Total_sales  desc

-- Month on Month sales percentage

SELECT Month(transaction_date) as Month_Name,
SUM(sales) as Total_Sales,
((SUM(sales)-LAG(SUM(sales),1) Over(ORDER BY MONTH(transaction_date))) / LAG(SUM(sales),1) 
OVER(ORDER BY MONTH(transaction_date))) *100 as 'Month_On_Month_%'

from Coffee_sales
WHERE MONTH(transaction_date) IN (4, 5)
GROUP BY Month(transaction_date)
ORDER BY Month(transaction_date)

-- Total total orders count and Total Quanitity Sold

select count(transaction_id) as Total_Orders
from Coffee_sales

select SUM(transaction_qty) as Total_Quantity_Sold
from Coffee_sales

-- Month on month total Quantity Sold percentage

Select Month,
Total_Quantity_Sold,
(Total_Quantity_Sold - LAG(Total_Quantity_Sold,1) OVER(ORDER BY Month))*100.0 / LAG(Total_Quantity_Sold,1) Over(ORDER BY Month)  as 'MOM_Percentage_%'
from 
(
select  DATENAME(MONTH,transaction_date) as Month,
SUM(transaction_qty) as Total_Quantity_Sold
from Coffee_sales
where MONTH(transaction_date) IN (4,5)
GROUP BY DATENAME(MONTH,transaction_date)
) as Monthly_sales
order by Month

-- Total Sales total Quantity and Total Orders
SELECT 
CONCAT(ROUND(SUM(sales) / 1000,1),'K') as Total_Sales , 
SUM(transaction_qty) as Total_Quantity_Sold, 
COUNT(transaction_id) as Total_Orders
from Coffee_sales


-- Weekend vs Weekday sales comparision

-- saturday 7
-- sunday 1 

SELECT 
CASE when Datepart (WEEKDAY,transaction_date) IN (1,7) Then 'Weekends'
ELSE 'Weekdays'
END as day_type,
SUM(sales) as Total_Sales
from coffee_sales
where month(transaction_date) = 5
GROUP BY
CASE when Datepart (WEEKDAY,transaction_date) IN (1,7) THEN 'Weekends'
Else 'Weekdays'
END

select * from Coffee_sales

-- Sales Comparison by stores Location
select store_location,
SUM(sales) as Total_sales
from Coffee_sales
where MONTH(transaction_date) = 5
GROUP BY store_location
Order BY Total_sales desc

-- Average Sales with respect to Date

Select AVG(Total_sales) as AVG_Sales
from
(
SELECT SUM(sales) as Total_sales
from
Coffee_sales
where MONTH(transaction_date)=5
Group BY transaction_date
)
as Internal_guery

-- Total Sales with respect to days

Select DAY(transaction_date) as Day_of_Month,
SUM(transaction_qty * unit_price) as Total_sales
from Coffee_sales
where Month(transaction_date) = 5
Group by DAY(transaction_date)
Order BY DAY(transaction_date)

-- Top 10 highest Product Category sales

SELECT TOP 10
product_category,
SUM(transaction_qty * unit_price) as Total_sales
from Coffee_sales
Group by product_category
order by Total_sales desc


select 
SUM(unit_price * transaction_qty) as Total_sales,
SUM(transaction_qty) as Total_QTY_Sold,
COUNT(*) as Total_Orders
FROM Coffee_sales
where MONTH(transaction_date)=5
AND DATEPART(WEEKDAY,transaction_date)=2
AND DATEPART(HOUR,transaction_time)=8


SELECT 
DATEPART(HOUR,transaction_time) as Hours,
ROUND(SUM(transaction_qty * unit_price),2) as Total_sales
from Coffee_sales
where MONTH(transaction_date)=5
Group by DATEPART(HOUR,transaction_time)
ORDER BY DATEPART(HOUR,transaction_time)



WITH Ordered_sales as(
SELECT 
CASE
when DATEPART(WEEKDAY,transaction_date)=2 then 'Monday'
when DATEPART(WEEKDAY,transaction_date)=3 then 'Tuesday'
when DATEPART(WEEKDAY,transaction_date)=4 then 'Wednesday'
when DATEPART(WEEKDAY,transaction_date)=4 then 'Thursday'
when DATEPART(WEEKDAY,transaction_date)=5 then 'Friday'
when DATEPART(WEEKDAY,transaction_date)=6 then 'Saturday'

else 'Sunday'
END as DAY_Of_Week,

SUM(transaction_qty*unit_price) as Total_sales,

CASE
when DATEPART(WEEKDAY,transaction_date)=2 then 1
when DATEPART(WEEKDAY,transaction_date)=3 then 2
when DATEPART(WEEKDAY,transaction_date)=4 then 3
when DATEPART(WEEKDAY,transaction_date)=4 then 4
when DATEPART(WEEKDAY,transaction_date)=5 then 5
when DATEPART(WEEKDAY,transaction_date)=6 then 6

else 7
END as Week_Order
from Coffee_sales

where MONTH(transaction_date)=5

Group BY 
CASE
when DATEPART(WEEKDAY,transaction_date)=2 then 'Monday'
when DATEPART(WEEKDAY,transaction_date)=3 then 'Tuesday'
when DATEPART(WEEKDAY,transaction_date)=4 then 'Wednesday'
when DATEPART(WEEKDAY,transaction_date)=4 then 'Thursday'
when DATEPART(WEEKDAY,transaction_date)=5 then 'Friday'
when DATEPART(WEEKDAY,transaction_date)=6 then 'Saturday'

else 'Sunday'
END,
CASE
when DATEPART(WEEKDAY,transaction_date)=2 then 1
when DATEPART(WEEKDAY,transaction_date)=3 then 2
when DATEPART(WEEKDAY,transaction_date)=4 then 3
when DATEPART(WEEKDAY,transaction_date)=4 then 4
when DATEPART(WEEKDAY,transaction_date)=5 then 5
when DATEPART(WEEKDAY,transaction_date)=6 then 6

else 7
END

)
select 
DAY_Of_Week,
Total_sales
from Ordered_sales
ORDER BY Week_Order













