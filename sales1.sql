SELECT 
    Years, 
    product_name, 
    Total_Sales,
    AVG(Total_Sales) OVER (PARTITION BY product_name) AS Avg_sales,
    CASE 
        WHEN Total_Sales - AVG(Total_Sales) OVER (PARTITION BY product_name) > 0 THEN 'Above AVG'
        WHEN Total_Sales - AVG(Total_Sales) OVER (PARTITION BY product_name) < 0 THEN 'Below AVG'
        ELSE 'IN AVG'
    END AS Sales_Status,
    LAG(Total_Sales) OVER (PARTITION BY product_name ORDER BY Years) AS Yearly_Sales,
    CASE 
        WHEN Total_Sales - LAG(Total_Sales) OVER (PARTITION BY product_name ORDER BY Years) > 0 THEN 'Increase'
        WHEN Total_Sales - LAG(Total_Sales) OVER (PARTITION BY product_name ORDER BY Years) < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS Yearly_Progress
FROM (
    SELECT 
        YEAR(f.order_date) AS Years,
        p.product_name, 
        SUM(f.sales_amount) AS Total_Sales
    FROM Sales.`gold.fact_sales` AS f 
    LEFT JOIN Sales.`gold.dim_products` AS p 
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL 
    GROUP BY YEAR(f.order_date), p.product_name
) AS main;