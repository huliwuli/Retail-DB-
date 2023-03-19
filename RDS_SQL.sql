USE Retail;

# a)	Display customer information

SELECT *
FROM Customer_dim;


#b)	Display stores information

SELECT *
FROM Store_dim;

#c)	Display Sales amount by store

SELECT ft.Store_id, Store_name,SUM(amount) AS Tt_Sales
FROM Fact_table ft
INNER JOIN Store_dim sd 
ON ft.Store_id =sd.Store_id 
GROUP BY 1,2;

# d)	Display sales amount by category, product

SELECT Product_dim.Product_name ,Product_dim.Product_category  , SUM(amount) AS Tt_Sales
FROM Fact_table 
INNER JOIN Product_dim  
ON Fact_table.Product_id = Product_dim.Product_id
GROUP BY 1,2
ORDER BY 3 DESC;

# e)	Display total sales amount report by sales transaction year

SELECT Date_dim.`year`, SUM(amount) AS Tt_Sales
FROM Fact_table
INNER JOIN Date_dim  
ON Fact_table.Date_id = Date_dim.date_id 
GROUP BY 1;

# f)	Display total sales amount report by sales transaction year, month
SELECT Date_dim.`year`, Date_dim.`month` , SUM(amount) AS Tt_Sales
FROM Fact_table
INNER JOIN Date_dim  
ON Fact_table.Date_id = Date_dim.date_id 
GROUP BY 1,2;

#g)	Top 3 selling products
SELECT ft.Product_id ,pd.Product_name ,SUM(ft.Quantity) as TT_quantity
FROM Fact_table ft 
INNER JOIN Product_dim pd 
ON pd.Product_id = ft.Product_id 
GROUP BY 1,2
ORDER BY 3 DESC ,pd.Product_name ASC
LIMIT 3;

#h)	Top 3 customers who paid highest sales amount

SELECT ft.Customer_id  ,cd.First_Name ,cd.Last_Name  ,SUM(ft.amount) as TT_quantity
FROM Fact_table ft 
INNER JOIN Customer_dim cd 
ON cd.Customer_id  = ft.Customer_id  
GROUP BY 1
ORDER BY 4 DESC
LIMIT 3;





