Select * from workspace.default.bright_coffee_shop_analysis
limit 10;

--------The start date and end date of data collection----

SELECT MIN (transaction_date) AS Start_Date,
MAX (transaction_date) AS End_Date
from workspace.default.bright_coffee_shop_analysis;


-------The open and close time of the coffee shop---


SELECT MIN (transaction_time) AS Opening_Time,
MAX (transaction_time) AS Closing_Time
from workspace.default.bright_coffee_shop_analysis;


---------------------------------------------------------------------------------------------------------
----Dates---

SELECT transaction_date,
Dayname(transaction_date) as Day_name,
Monthname(transaction_date) as Month_name,
Dayofmonth(transaction_date) as day_of_month,
CASE 
WHEN Dayname(transaction_date) IN ('Sun','Sat') THEN 'Weekend'
ELSE 'Weekday'
END as day_classification,

---Time---

CASE 
WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '06:00:00' AND '11:59:59' THEN '01. Morning'
WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '12:00:00' AND '17:59:59' THEN '02. Afternoon'
WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '18:00:00' AND '20:59:59' THEN '03. Evening'
ELSE 'Store is closed'
END as time_buckets,

--Counts
COUNT(DISTINCT transaction_id) as Number_of_Sales,
COUNT(DISTINCT store_id) as Number_of_Stores,
COUNT(DISTINCT product_id) as Number_of_Products,

---Revenue
SUM(transaction_qty*unit_price) as Revenue_per_Day,

CASE 
  WHEN Revenue_per_Day <=50 then '01.Low Spend'
  WHEN Revenue_per_Day between 51 and 100 then '02.Medium Spend'
  ELSE '03.High Spend'
END as Spend_Bucket,


--Categorical columns
store_location,
product_category,
product_detail
FROM workspace.default.bright_coffee_shop_analysis

GROUP BY 
transaction_date,
 Dayname(transaction_date), 
 store_location,
 product_category,
 product_detail,
 Monthname(transaction_date),
 Dayofmonth(transaction_date),
 CASE 
 WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '06:00:00' AND '11:59:59' THEN '01. Morning'
 WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '12:00:00' AND '17:59:59' THEN '02. Afternoon'
 WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '18:00:00' AND '20:59:59' THEN '03. Evening'
 ELSE 'Store is closed'
 END,
 CASE 
 WHEN Dayname(transaction_date) IN ('Sun','Sat') THEN 'Weekend'
 ELSE 'Weekday'
 END;
