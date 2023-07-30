
--Customer Segmentation
--1. Create a “view” that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)



CREATE VIEW monthly_visit_log AS (
	SELECT Cust_ID, [Year], [Month]
	FROM (
		SELECT DISTINCT Ord_ID, Cust_ID, YEAR(Order_Date) [Year], MONTH(Order_Date) [Month]
		FROM e_commerce_data
		) subq
)
go

-- 2. Create a “view” that keeps the number of monthly visits by users. (Show separately all months from the beginning business) */
go
CREATE VIEW MonthlyVisits AS
SELECT 
    YEAR(Order_Date) AS [Year],
    MONTH(Order_Date) AS [Month],
    COUNT(*) AS [MonthlyVisits]
FROM
    e_commerce_data
GROUP BY
    YEAR(Order_Date),
    MONTH(Order_Date)
ORDER BY
    YEAR(Order_Date),
    MONTH(Order_Date);
go

-- 3. For each visit of customers, create the next month of the visit as a separate column

WITH next_month_visit AS(
	SELECT
		Cust_ID,
		Order_Date,
		LEAD(Order_Date) OVER (PARTITION BY Cust_ID
								ORDER BY Order_Date) AS next_visit_date
	FROM e_commerce_data
)

SELECT 
	e.Cust_ID,
	e.Order_Date,
	n.next_visit_date AS next_month_visit
FROM
	e_commerce_data e
LEFT JOIN 
	next_month_visit n ON e.Cust_ID = n.Cust_ID
	AND e.Order_Date = n.Order_Date

-- 4. Calculate the monthly time gap between two consecutive visits by each customer.

SELECT
	Cust_ID,
	Order_Date AS current_visit,
	LEAD(Order_Date) OVER (PARTITION BY Cust_ID
							ORDER BY Order_Date) AS next_visit,
	DATEDIFF(MONTH, Order_Date, LEAD(Order_Date) OVER (PARTITION BY Cust_Id
														ORDER BY Order_Date))
														AS monthly_time_gap
FROM e_commerce_data
go
-- 5. Categorise customers using average time gaps. Choose the most fitted labeling model for you.

WITH Time_Gap_CTE AS(
	SELECT
		Cust_ID,
		Order_Date,
		LEAD(Order_Date) OVER (PARTITION BY Cust_ID
								ORDER BY Order_Date) AS next_visit,
		DATEDIFF(MONTH, Order_Date, LEAD(Order_Date) OVER (PARTITION BY Cust_Id
															ORDER BY Order_Date))
															AS monthly_time_gap
	FROM e_commerce_data
)

SELECT
	Cust_ID,
	AVG(monthly_time_gap) AS avg_time_gap_months,
	CASE
		WHEN AVG(monthly_time_gap) <= 1 THEN 'Very Frequent'
        WHEN AVG(monthly_time_gap) <= 3 THEN 'Frequent'
        WHEN AVG(monthly_time_gap) <= 6 THEN 'Regular'
        WHEN AVG(monthly_time_gap) <= 12 THEN 'Infrequent' 
		ELSE 'Very Infrequent'
	END AS category
FROM Time_Gap_CTE
GROUP BY Cust_ID;
GO
--Month-Wise Retention Rate
--Find month-by-month customer retention rate since the start of the business.
GO
-- Unique customers each month

SELECT 
	YEAR(Order_Date) AS [Year],
	MONTH(Order_Date) AS [Month],
	COUNT(DISTINCT Cust_ID) AS [UniqueCustomers]
FROM e_commerce_data
GROUP BY
	YEAR(Order_Date),
	MONTH(Order_Date)
ORDER BY 
	YEAR(Order_Date),
	MONTH(Order_Date);

-- Retention rate for each month

WITH MonthlyCustomers AS(
	SELECT
		YEAR(Order_Date) AS [Year],
		MONTH(Order_Date) AS [Month],
		COUNT(DISTINCT Cust_ID) AS [UniqueCustomers]
	FROM e_commerce_data
	GROUP BY 
		YEAR(Order_Date),
		MONTH(Order_Date)
)
SELECT
	mc1.Year,
	mc1.Month,
	mc1.UniqueCustomers AS [CurrentCustomers],
	ISNULL(mc2.UniqueCustomers,0) AS [PreviousCustomers],
	ISNULL(mc2.UniqueCustomers,0) / CAST(mc1.UniqueCustomers AS float) AS [RetentionRate]
FROM MonthlyCustomers mc1
LEFT JOIN MonthlyCustomers mc2 ON mc1.Year = mc2.Year AND mc1.Month = mc2.Month + 1
ORDER BY
	mc1.Year,
	mc1.Month;