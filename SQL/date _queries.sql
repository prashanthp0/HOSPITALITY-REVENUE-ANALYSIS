SELECT 
    Booking_ID,
    Booking_Date,
    CASE 
        WHEN DATEPART(WEEKDAY, Booking_Date) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Type
FROM fact_bookings;


SELECT 
    Booking_ID,
    DATEPART(WEEK, Booking_Date) AS Week_Number,
    DATEPART(QUARTER, Booking_Date) AS Quarter
FROM fact_bookings;


SELECT 
    FORMAT(Booking_Date, 'yyyy-MM') AS YearMonth,
    COUNT(*) AS Total_Bookings
FROM fact_bookings
GROUP BY FORMAT(Booking_Date, 'yyyy-MM')

ORDER BY YearMonth;

SELECT 
    DATENAME(WEEKDAY, Booking_Date) AS Day_Name,
    COUNT(*) AS Total_Bookings
FROM fact_bookings
GROUP BY DATENAME(WEEKDAY, Booking_Date);
--booking frequency per property
WITH LagExample AS (
    SELECT 
        property_id,
        Booking_ID,
        Booking_Date,
        LAG(Booking_Date) OVER (PARTITION BY property_id ORDER BY Booking_Date) AS Prev_Booking_Date
    FROM fact_bookings
)
SELECT 
    property_id,
    Booking_ID,
    DATEDIFF(DAY, Prev_Booking_Date, Booking_Date) AS Days_Between_Bookings
FROM LagExample
WHERE Prev_Booking_Date IS NOT NULL;

