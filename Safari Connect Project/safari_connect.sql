CREATE SCHEMA safari_connect;

SELECT *
FROM safari_connect.safari_connect_dirty;

--Checking duplicates
--BK0005 has a duplicate
SELECT booking_id, count(*)
FROM safari_connect.safari_connect_dirty
GROUP BY booking_id
HAVING COUNT(*)>1;

--Checking row with duplicate
SELECT *
FROM safari_connect.safari_connect_dirty
WHERE booking_id='BK0005';


--creating temporary table that removes duplicate
WITH duplicate_check AS 
	  (SELECT *,
	  ROW_NUMBER() OVER (PARTITION BY booking_id) AS rn
FROM safari_connect.safari_connect_dirty)

SELECT *
FROM duplicate_check
WHERE rn=1;


--- Cleaning passenger phone column. Remove +254, '-', spaces and filling null
SELECT 
    passenger_phone,
    CASE WHEN passenger_phone IS NULL  OR TRIM(passenger_phone) = '' THEN NULL
        ELSE REPLACE(
                 REPLACE(TRIM(passenger_phone), '+254', '0'),'-', ''
                     )
    END AS passenger_phone_cleaned
FROM safari_connect.safari_connect_dirty;


--Cleaning passenger_gender
SELECT passenger_gender,
       CASE 
            WHEN UPPER(TRIM(passenger_gender)) IN ('M','MALE') THEN 'Male'
       	    WHEN UPPER(TRIM(passenger_gender)) IN ('F','FEMALE') THEN 'Female'
       	    ELSE NULL
       END AS passenger_gender
FROM safari_connect.safari_connect_dirty;


--Cleaning city column; removing nulls and capitalizing first letter
SELECT passenger_city,
	   CASE 
	   		WHEN passenger_city IS NULL OR TRIM(passenger_city) = '' THEN 'Unknown'
	   		ELSE INITCAP(passenger_city)
	   		END AS passenger_city
FROM safari_connect.safari_connect_dirty;


--Cleaning vehicle_type column;capitalizing first letter 
SELECT INITCAP(vehicle_type) AS vehicle_type
FROM safari_connect.safari_connect_dirty;


--Cleaning driver_name column;capitalizing first letter
SELECT 
		DISTINCT(TRIM(INITCAP(driver_name))) AS driver_name
FROM safari_connect.safari_connect_dirty;


--Cleaning departure_date column
SELECT 
    departure_date,

    CASE
        -- NULL or blank
        WHEN departure_date IS NULL
             OR TRIM(departure_date) = ''
        THEN NULL

        -- YYYY-MM-DD
        WHEN TRIM(departure_date) ~ '^\d{4}-\d{2}-\d{2}$'
        THEN TO_DATE(
            TRIM(departure_date),
            'YYYY-MM-DD'
        )

        -- DD/MM/YYYY
        WHEN TRIM(departure_date) ~ '^\d{2}/\d{2}/\d{4}$'
        THEN TO_DATE(
            TRIM(departure_date),
            'DD/MM/YYYY'
        )

        -- DD-MM-YYYY where day > 12
        WHEN TRIM(departure_date) ~ '^\d{2}-\d{2}-\d{4}$'
             AND SPLIT_PART(TRIM(departure_date), '-', 1)::INT > 12
        THEN TO_DATE(
            TRIM(departure_date),
            'DD-MM-YYYY'
        )

        -- MM-DD-YYYY where month > 12 is impossible,
        -- so second part > 12 identifies MM-DD-YYYY
        WHEN TRIM(departure_date) ~ '^\d{2}-\d{2}-\d{4}$'
             AND SPLIT_PART(TRIM(departure_date), '-', 2)::INT > 12
        THEN TO_DATE(
            TRIM(departure_date),
            'MM-DD-YYYY'
        )

        -- DD-MM-YYYY / MM-DD-YYYY ambiguous dates
        -- Assumes DD-MM-YYYY
        WHEN TRIM(departure_date) ~ '^\d{2}-\d{2}-\d{4}$'
        THEN TO_DATE(
            TRIM(departure_date),
            'DD-MM-YYYY'
        )

        -- DD-MM-YY
        WHEN TRIM(departure_date) ~ '^\d{2}-\d{2}-\d{2}$'
        THEN TO_DATE(
            TRIM(departure_date),
            'DD-MM-YY'
        )

        ELSE NULL
    END AS departure_date_clean
FROM safari_connect.safari_connect_dirty;


--Cleaning seat class column
SELECT seat_class, 
       CASE 
            WHEN TRIM(seat_class) IN ('BUS','BUSINESS CLASS','business') THEN 'Business'
       	    WHEN TRIM(seat_class) IN ('eco','economy class','economy', 'ECO') THEN 'Economy'
       	    ELSE seat_class
        END AS seat_class
FROM safari_connect.safari_connect_dirty;

--Deleting a row where column seat booked is -1
DELETE FROM safari_connect.safari_connect_dirty
WHERE seats_booked = -1;

SELECT distinct(fare_per_seat ),
	   CASE WHEN fare_per_seat 
FROM safari_connect.safari_connect_dirty;

--Cleaning total_fare column
SELECT
    total_fare,
    CAST(
        REGEXP_REPLACE(total_fare, '[^0-9.]', '', 'g')
        AS NUMERIC
    ) AS total_fare_clean
FROM safari_connect.safari_connect_dirty;


--Cleaning payment_method column
SELECT distinct
	    CASE 
            WHEN TRIM(payment_method) IN ('mpesa','m-pesa','MPESA') THEN 'M-Pesa'
       	    WHEN TRIM(payment_method) IN ('card','CARD') THEN 'Card'
       	    WHEN TRIM(payment_method) IN ('CASH','cash') THEN 'Cash'
       	    ELSE payment_method
        END AS payment_method
FROM safari_connect.safari_connect_dirty;


SELECT distinct(booking_status)
FROM safari_connect.safari_connect_dirty;



SELECT 
		distinct
	    CASE 
            WHEN TRIM(booking_status) IN ('CANCELLED') THEN 'Cancelled'
       	    WHEN TRIM(booking_status) IN ('no show','NO SHOW') THEN 'No Show'
       	    WHEN TRIM(booking_status) IN ('COMPLETED','completed') THEN 'Completed'
       	    ELSE booking_status
        END AS booking_status
FROM safari_connect.safari_connect_dirty;



--Data cleaning
SELECT  booking_id, 
		initcap(TRIM(passenger_name)) AS passenger_name,
		CASE WHEN passenger_phone IS NULL  OR TRIM(passenger_phone) = '' THEN NULL
        ELSE REPLACE(REPLACE(TRIM(passenger_phone), '+254', '0'),'-', '')
        END AS passenger_phone,
        CASE 
            WHEN UPPER(TRIM(passenger_gender)) IN ('M','MALE') THEN 'Male'
       	    WHEN UPPER(TRIM(passenger_gender)) IN ('F','FEMALE') THEN 'Female'
       	    ELSE NULL
        END AS passenger_gender, 
		CASE 
	   		WHEN passenger_city IS NULL OR TRIM(passenger_city) = '' THEN 'Unknown'
	   		ELSE INITCAP(passenger_city)
	   		END AS passenger_city,
		route_code, 
		route_from, 
		route_to, 
		vehicle_plate, 
		INITCAP(vehicle_type) AS vehicle_type,
		TRIM(INITCAP(driver_name)) AS driver_name,
		driver_rating, 
		CASE
	        WHEN departure_date IS NULL OR TRIM(departure_date) = '' THEN NULL
	        WHEN TRIM(departure_date) ~ '^\d{4}-\d{2}-\d{2}$' THEN TO_DATE(TRIM(departure_date),'YYYY-MM-DD')
	        WHEN TRIM(departure_date) ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE( TRIM(departure_date),'DD/MM/YYYY')
	        WHEN TRIM(departure_date) ~ '^\d{2}-\d{2}-\d{4}$'AND SPLIT_PART(TRIM(departure_date), '-', 1)::INT > 12 THEN TO_DATE(TRIM(departure_date),'DD-MM-YYYY')
	        WHEN TRIM(departure_date) ~ '^\d{2}-\d{2}-\d{4}$' AND SPLIT_PART(TRIM(departure_date), '-', 2)::INT > 12 THEN TO_DATE(TRIM(departure_date),'MM-DD-YYYY')
	        WHEN TRIM(departure_date) ~ '^\d{2}-\d{2}-\d{4}$'THEN TO_DATE(TRIM(departure_date), 'DD-MM-YYYY')
	        WHEN TRIM(departure_date) ~ '^\d{2}-\d{2}-\d{2}$' THEN TO_DATE( TRIM(departure_date),'DD-MM-YY')
	        ELSE NULL
        END AS departure_date,
		departure_time, 
		CASE 
            WHEN TRIM(seat_class) IN ('BUS','BUSINESS CLASS','business') THEN 'Business'
       	    WHEN TRIM(seat_class) IN ('eco','economy class','economy', 'ECO') THEN 'Economy'
       	    ELSE seat_class
        END AS seat_class,
		seats_booked, 
		CAST( REGEXP_REPLACE(fare_per_seat, '[^0-9.]', '', 'g')AS NUMERIC) AS fare_per_seat,
        CAST(REGEXP_REPLACE(total_fare,'[^0-9.]','','g') AS NUMERIC) AS total_fare,
		CASE 
            WHEN TRIM(payment_method) IN ('mpesa','m-pesa','MPESA') THEN 'M-Pesa'
       	    WHEN TRIM(payment_method) IN ('card','CARD') THEN 'Card'
       	    WHEN TRIM(payment_method) IN ('CASH','cash') THEN 'Cash'
       	    ELSE payment_method
        END AS payment_method, 
		CASE 
            WHEN TRIM(booking_status) IN ('CANCELLED') THEN 'Cancelled'
       	    WHEN TRIM(booking_status) IN ('no show','NO SHOW') THEN 'No Show'
       	    WHEN TRIM(booking_status) IN ('COMPLETED','completed') THEN 'Completed'
       	    ELSE booking_status
        END AS booking_status, 
		CASE
	        WHEN trip_rating IN (0, 6) THEN NULL
	        ELSE trip_rating
	        END AS trip_rating
FROM safari_connect.safari_connect_dirty;



-- CTA to create a new table
CREATE TABLE safari_connect_clean AS(
WITH duplicate_check AS 
	  (SELECT *,
	  ROW_NUMBER() OVER (PARTITION BY booking_id) AS rn
FROM safari_connect.safari_connect_dirty)

SELECT  booking_id, 
		initcap(TRIM(passenger_name)) AS passenger_name,
		CASE WHEN passenger_phone IS NULL  OR TRIM(passenger_phone) = '' THEN NULL
        ELSE REPLACE(REPLACE(TRIM(passenger_phone), '+254', '0'),'-', '')
        END AS passenger_phone,
        CASE 
            WHEN UPPER(TRIM(passenger_gender)) IN ('M','MALE') THEN 'Male'
       	    WHEN UPPER(TRIM(passenger_gender)) IN ('F','FEMALE') THEN 'Female'
       	    ELSE NULL
        END AS passenger_gender, 
		CASE 
	   		WHEN passenger_city IS NULL OR TRIM(passenger_city) = '' THEN 'Unknown'
	   		ELSE INITCAP(passenger_city)
	   		END AS passenger_city,
		route_code, 
		route_from, 
		route_to, 
		vehicle_plate, 
		INITCAP(vehicle_type) AS vehicle_type,
		TRIM(INITCAP(driver_name)) AS driver_name,
		driver_rating, 
		CASE
	        WHEN departure_date IS NULL OR TRIM(departure_date) = '' THEN NULL
	        WHEN TRIM(departure_date) ~ '^\d{4}-\d{2}-\d{2}$' THEN TO_DATE(TRIM(departure_date),'YYYY-MM-DD')
	        WHEN TRIM(departure_date) ~ '^\d{2}/\d{2}/\d{4}$' THEN TO_DATE( TRIM(departure_date),'DD/MM/YYYY')
	        WHEN TRIM(departure_date) ~ '^\d{2}-\d{2}-\d{4}$'AND SPLIT_PART(TRIM(departure_date), '-', 1)::INT > 12 THEN TO_DATE(TRIM(departure_date),'DD-MM-YYYY')
	        WHEN TRIM(departure_date) ~ '^\d{2}-\d{2}-\d{4}$' AND SPLIT_PART(TRIM(departure_date), '-', 2)::INT > 12 THEN TO_DATE(TRIM(departure_date),'MM-DD-YYYY')
	        WHEN TRIM(departure_date) ~ '^\d{2}-\d{2}-\d{4}$'THEN TO_DATE(TRIM(departure_date), 'DD-MM-YYYY')
	        WHEN TRIM(departure_date) ~ '^\d{2}-\d{2}-\d{2}$' THEN TO_DATE( TRIM(departure_date),'DD-MM-YY')
	        ELSE NULL
        END AS departure_date,
		departure_time, 
		CASE 
            WHEN TRIM(seat_class) IN ('BUS','BUSINESS CLASS','business') THEN 'Business'
       	    WHEN TRIM(seat_class) IN ('eco','economy class','economy', 'ECO') THEN 'Economy'
       	    ELSE seat_class
        END AS seat_class,
		seats_booked, 
		CAST( REGEXP_REPLACE(fare_per_seat, '[^0-9.]', '', 'g')AS NUMERIC) AS fare_per_seat,
        CAST(REGEXP_REPLACE(total_fare,'[^0-9.]','','g') AS NUMERIC) AS total_fare,
		CASE 
            WHEN TRIM(payment_method) IN ('mpesa','m-pesa','MPESA') THEN 'M-Pesa'
       	    WHEN TRIM(payment_method) IN ('card','CARD') THEN 'Card'
       	    WHEN TRIM(payment_method) IN ('CASH','cash') THEN 'Cash'
       	    ELSE payment_method
        END AS payment_method, 
		CASE 
            WHEN TRIM(booking_status) IN ('CANCELLED') THEN 'Cancelled'
       	    WHEN TRIM(booking_status) IN ('no show','NO SHOW') THEN 'No Show'
       	    WHEN TRIM(booking_status) IN ('COMPLETED','completed') THEN 'Completed'
       	    ELSE booking_status
        END AS booking_status, 
		CASE
	        WHEN trip_rating IN (0, 6) THEN NULL
	        ELSE trip_rating
	        END AS trip_rating
FROM duplicate_check
WHERE rn=1
);

--Selecting new created table
SELECT * 
FROM public.safari_connect_clean;









