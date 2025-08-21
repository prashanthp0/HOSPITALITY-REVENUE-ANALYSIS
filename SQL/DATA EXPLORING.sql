use prashanth;

SELECT TOP 5 *
FROM fact_bookings
ORDER BY NEWID();

SELECT TOP 5 *
FROM dim_date
ORDER BY NEWID();

SELECT TOP 5 *
FROM dim_rooms
ORDER BY NEWID();

SELECT TOP 5 *
FROM dim_hotels
ORDER BY NEWID();

SELECT 'fact_bookings' AS TableName, COUNT(*) AS TotalRows FROM fact_bookings

SELECT 
    SUM(CASE WHEN Booking_Date IS NULL THEN 1 ELSE 0 END) AS MissingBookingDate,
    SUM(CASE WHEN  revenue_generated  IS NULL THEN 1 ELSE 0 END) AS MissingRevenue,
    SUM(CASE WHEN property_id IS NULL THEN 1 ELSE 0 END) AS MissingHotelID
FROM fact_bookings;

SELECT Booking_Date, COUNT(*) AS TotalBookings
FROM fact_bookings
GROUP BY Booking_Date
ORDER BY Booking_Date;


with booking_details as
(
select property_id,revenue_generated, ROW_NUMBER() over(order by revenue_generated desc) as list
from fact_bookings
)
select property_id,revenue_generated from booking_details where list =1;
--Business Insight:

--Short lead time → Last-minute bookings (OTAs)

--Long lead time → Corporate bookings
select booking_id,DATEDIFF(day,check_in_date , checkout_date ) as no_of_days from fact_bookings;


select booking_id,booking_date,
case 
when datepart(weekday,booking_date) in(1,7) then 'weekday'
else 'weekend'

end as daytype
from fact_bookings;


select  format(Booking_date,'mm-yyy') as monthyear,count(*) as no_of_bookings
from fact_bookings
group by  format(booking_date,'mm-yyy') 
order by monthyear
;

select count(*) as no_of_bookings,datename(weekday,booking_date) as day_name from fact_bookings
group by  datename(weekday,booking_date)
;
-- to find days between bookings
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



select (cast(sum(case when booking_status ='cancelled' then 1 else 0 end)as float)/ 
count(*))* 100 as cancellation_rate from fact_bookings
 ;