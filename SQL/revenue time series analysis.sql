-- Aggregate revenue by Year-Month.
-- Business Use: Month-over-Month revenue analysis.
SELECT 
    FORMAT(Booking_Date, 'yyyy-MM') AS YearMonth,
    SUM(revenue_realized) AS Monthly_Revenue
FROM fact_bookings
GROUP BY FORMAT(Booking_Date, 'yyyy-MM')
ORDER BY YearMonth;

-- Aggregate revenue by Week.
-- Business Use: Weekly monitoring for operations.
SELECT 
    DATEPART(YEAR, Booking_Date) AS Y,
    DATEPART(WEEK, Booking_Date) AS WeekNo,
    SUM(revenue_realized) AS Weekly_Revenue
FROM fact_bookings
GROUP BY DATEPART(YEAR, Booking_Date), DATEPART(WEEK, Booking_Date)
ORDER BY Y, WeekNo;
select booking_status from fact_bookings;


-- Calculate total revenue for each city
SELECT 
    h.City,
    SUM(revenue_realized) AS Total_Revenue
FROM fact_bookings b join dim_hotels h on h.property_id=b.property_id
GROUP BY City
ORDER BY Total_Revenue DESC;


-- Calculate total revenue per property
SELECT 
    Property_ID,
    SUM(revenue_realized) AS Total_Revenue
FROM fact_bookings
GROUP BY Property_ID
ORDER BY Total_Revenue DESC;



-- Calculate revenue based on the weekday of booking
SELECT 
    DATENAME(WEEKDAY, Booking_Date) AS Weekday_Name,
    SUM(revenue_realized) AS Total_Revenue
FROM fact_bookings
GROUP BY DATENAME(WEEKDAY, Booking_Date)
ORDER BY Total_Revenue DESC;


-- Calculate revenue grouped by room category
SELECT 
    Room_Category,
    SUM(revenue_generated) AS Total_Revenue
FROM fact_bookings
GROUP BY Room_Category
ORDER BY Total_Revenue DESC;





