SELECT 
    New_Date, 
    Total_Sales,
    (SELECT SUM(Total_Sales)
     FROM (
         SELECT DATE_FORMAT(order_date, '%Y-%m-01') AS New_Date,
                SUM(sales_amount) AS Total_Sales
         FROM Sales.`gold.fact_sales`
         WHERE order_date IS NOT NULL 
         GROUP BY New_Date
     ) AS sub
     WHERE sub.New_Date <= main.New_Date) AS Running_sales,
    (SELECT SUM(Total_Sales)
     FROM (
         SELECT DATE_FORMAT(order_date, '%Y-%m-01') AS New_Date,
                SUM(sales_amount) AS Total_Sales
         FROM Sales.`gold.fact_sales`
         WHERE order_date IS NOT NULL 
         GROUP BY New_Date
     ) AS sub
     WHERE YEAR(sub.New_Date) = YEAR(main.New_Date)
     AND sub.New_Date <= main.New_Date) AS Running_sales_yearly
FROM (
    SELECT DATE_FORMAT(order_date, '%Y-%m-01') AS New_Date,
           SUM(sales_amount) AS Total_Sales
    FROM Sales.`gold.fact_sales`
    WHERE order_date IS NOT NULL 
    GROUP BY New_Date
) AS main
ORDER BY New_Date;
