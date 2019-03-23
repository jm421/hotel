/*
Hotel_query.sql

RDBMS used: MySQL
*/

USE HotelDb;


-- Part A
SELECT 
  name, publicRating, freeParking 
FROM 
  Hotel 
WHERE 
  city = "Bristol" 
  AND publicRating > 8.5 
  AND freeParking = TRUE;
  
  
-- Part B
SELECT 
  roomNumber, 
  city, 
  roomType, 
  breakfastPrice,
  -- List the basic facilities  
  freeParking, 
  freeWifi, 
  airConditioning, 
  liftAccess, 
  breakfastOnly, 
  restaurant, 
  chargeableParking, 
  -- Check whether to apply discount or not
  CASE 
	WHEN ((DATEDIFF('2018-12-26', CURDATE()) > h.gracePeriod) AND (r.roomType = 'Double')) 
	THEN ROUND((h.doublePrice - (h.doublePrice * h.doubleDiscount)), 2) 
    
    WHEN ((DATEDIFF('2018-12-26', CURDATE()) <= h.gracePeriod) AND (r.roomType = 'Double'))
    THEN ROUND((h.doublePrice), 2) 
    
    END AS price
FROM 
  Room r 
  JOIN Hotel h ON r.hotelID = h.hotelID 
WHERE 
  h.city = 'Bristol' 
  AND r.roomType = 'Double' 
  AND r.roomID NOT IN(
    SELECT 
      r.roomID 
    FROM 
      Booking b 
      JOIN Room r ON b.roomID = r.roomID 
      JOIN Hotel h ON h.hotelID = R.hotelID 
    WHERE 
      '2018-12-26' BETWEEN checkInDate 
      AND checkOutDate 
      AND h.city = 'Bristol' 
      AND r.roomType = 'Double'
  ) 
ORDER BY 
  price;			-- Calculated with discount previously


-- Part C
SELECT 
  CONCAT(c.title, " ", c.fName, " ", c.lName) AS name, 
  b.bookingDate, 
  b.checkInDate, 
  b.checkOutDate, 
  h.name AS hotelName, 
  r.roomType, 
  b.adultNumber, 
  b.childrenNumber, 
  b.specialInstruction,
  -- Check room types, whether discount is applied and if breakfast has been ordered to find the total paid	
  CASE WHEN ((DATEDIFF(b.checkInDate, b.bookingDate) > h.gracePeriod) AND (r.roomType = 'Single')) 
	   THEN ROUND((h.singlePrice - (h.singlePrice * h.singleDiscount) + IF(b.breakfast = TRUE, (b.adultNumber + b.childrenNumber)* h.breakfastPrice, 0)), 2) 
		
	   WHEN ((DATEDIFF(b.checkInDate, b.bookingDate) <= h.gracePeriod) AND (r.roomType = 'Single')) 
       THEN ROUND((h.singlePrice) + IF(b.breakfast = TRUE, (b.adultNumber + b.childrenNumber)* h.breakfastPrice, 0), 2) 
       
       WHEN ((DATEDIFF(b.checkInDate, b.bookingDate) > h.gracePeriod) AND (r.roomType = 'Double')) 
       THEN ROUND((h.doublePrice - (h.doublePrice * h.doubleDiscount) + IF(b.breakfast = TRUE, (b.adultNumber + b.childrenNumber)* h.breakfastPrice, 0)), 2) 
       
       WHEN ((DATEDIFF(b.checkInDate, b.bookingDate) <= h.gracePeriod) AND (r.roomType = 'Double')) 
       THEN ROUND((h.doublePrice) + IF(b.breakfast = TRUE, (b.adultNumber + b.childrenNumber)* h.breakfastPrice, 0), 2) 
       
       WHEN ((DATEDIFF(b.checkInDate, b.bookingDate) > h.gracePeriod) AND (r.roomType = 'Twin')) 
       THEN ROUND((h.twinPrice - (h.twinPrice * h.twinDiscount) + IF(b.breakfast = TRUE, (b.adultNumber + b.childrenNumber)* h.breakfastPrice, 0)), 2) 
       
       WHEN ((DATEDIFF(b.checkInDate, b.bookingDate) <= h.gracePeriod) AND (r.roomType = 'Twin')) 
       THEN ROUND((h.twinPrice) + IF(b.breakfast = TRUE, (b.adultNumber + b.childrenNumber)* h.breakfastPrice, 0), 2)
       
       WHEN ((DATEDIFF(b.checkInDate, b.bookingDate) > h.gracePeriod) AND (r.roomType = 'Family')) 
       THEN ROUND((h.familyPrice - (h.familyPrice * h.familyDiscount) + IF(b.breakfast = TRUE, (b.adultNumber + b.childrenNumber)* h.breakfastPrice, 0)), 2)
       
       WHEN ((DATEDIFF(b.checkInDate, b.bookingDate) <= h.gracePeriod) AND (r.roomType = 'Family')) 
       THEN ROUND((h.familyPrice) + IF(b.breakfast = TRUE, (b.adultNumber + b.childrenNumber)* h.breakfastPrice, 0), 2) 
       
       END AS 'amount paid' 
FROM 
  Customer c 
  JOIN Booking b ON b.customerID = c.customerID 
  JOIN Room r ON r.roomID = b.roomID 
  JOIN Hotel h ON h.hotelID = r.hotelID 
WHERE 
  c.fName = "Ian" 
  AND c.lName = "Cooper";

  
-- Part D
SELECT 
  name,
  -- Calculate the discount for the double room  
  ROUND(IF(DATEDIFF('2018-12-26', CURDATE()) > gracePeriod, doublePrice - (doublePrice * doubleDiscount), doublePrice), 2) 
  AS 'Double bedroom price 26/12/18' 
FROM 
  Hotel 
WHERE
  -- Compare price with discount to the average 
  (IF(DATEDIFF('2018-12-26', CURDATE()) > gracePeriod, doublePrice - (doublePrice * doubleDiscount), doublePrice)) 
  > 
  (SELECT
	  -- Average double bedroom price on 26/12/2018
      AVG(IF(DATEDIFF('2018-12-26', CURDATE()) > gracePeriod, doublePrice - (doublePrice * doubleDiscount), doublePrice)) 
    FROM 
      Hotel
  );
  
  
-- Part E
SELECT 
  r.roomNumber AS 'Room Number', 
  h.name AS 'Hotel', 
  IF(r.roomId IN (
      SELECT 
        r.roomID 
      FROM 
        Booking b 
        JOIN Room r ON b.roomID = r.roomID 
        JOIN Hotel h ON h.hotelID = r.hotelID 
      WHERE 
        '2018-12-26' BETWEEN checkInDate 
        AND checkOutDate 
        AND h.name = 'Finzels Reach'
    ), 
    'booked', 
    'available'
  ) AS 'Booking Status on 26/12/18' 
FROM 
  Room r 
  JOIN Hotel h ON r.hotelID = h.hotelID 
WHERE 
  h.name = 'Finzels Reach';
  
  
-- Part F
SELECT
  roomType AS 'Room Type', 
  COUNT(*) AS 'Number of rooms' 
FROM 
  Room r 
  JOIN Hotel h ON h.hotelId = r.hotelId 
WHERE 
  h.name = 'Finzels Reach' 
GROUP BY 
  roomType;
  
  
-- Part G
SELECT 
  h.name AS 'Hotel', 
  '26/12/2018' AS 'Date', 
  SUM(b.adultNumber) AS 'Total Adult Guests' 
FROM 
  Booking b 
  JOIN Room r ON r.roomId = b.roomId 
  JOIN Hotel h ON h.hotelId = r.hotelId 
WHERE 
  h.name = 'Finzels Reach' 
  AND '2018-12-26' BETWEEN b.checkInDate 
  AND b.checkOutDate;
  
  
-- Part H
SELECT 
  r.roomnumber AS 'Room Number', 
  h.name AS 'Hotel',
  -- Check booking status on each day  
  IF(r.roomid IN (
      SELECT 
        r.roomid 
      FROM 
        booking b 
        JOIN room r ON b.roomid = r.roomid 
        JOIN hotel h ON h.hotelid = r.hotelid 
      WHERE 
        '2018-12-25' BETWEEN checkindate 
        AND checkoutdate 
        AND h.name = 'Finzels Reach' 
        AND r.roomNumber = '204'
    ),
    -- If room booked, show name of customer 	
    Concat(
      'booked by ', 
      (
        SELECT 
          Concat(
            c.title, ' ', c.fname, ' ', c.lname
          ) 
        FROM 
          customer c 
          JOIN booking b ON b.customerid = c.customerid 
          JOIN room r ON r.roomid = b.roomid 
          JOIN hotel h ON h.hotelid = r.hotelid 
        WHERE 
          '2018-12-25' BETWEEN b.checkindate 
          AND b.checkoutdate 
          AND r.roomnumber = '204' 
          AND h.name = 'Finzels Reach'
      )
    ), 
    'available'
  ) AS 'status on 25/12/18', 
  
  IF(r.roomid IN (
      SELECT 
        r.roomid 
      FROM 
        booking b 
        JOIN room r ON b.roomid = r.roomid 
        JOIN hotel h ON h.hotelid = r.hotelid 
      WHERE 
        '2018-12-26' BETWEEN checkindate 
        AND checkoutdate 
        AND h.name = 'Finzels Reach' 
        AND r.roomNumber = '204'
    ), 
    Concat(
      'booked by ', 
      (
        SELECT 
          Concat(
            c.title, ' ', c.fname, ' ', c.lname
          ) 
        FROM 
          customer c 
          JOIN booking b ON b.customerid = c.customerid 
          JOIN room r ON r.roomid = b.roomid 
          JOIN hotel h ON h.hotelid = r.hotelid 
        WHERE 
          '2018-12-26' BETWEEN b.checkindate 
          AND b.checkoutdate 
          AND r.roomnumber = '204' 
          AND h.name = 'Finzels Reach'
      )
    ), 
    'available'
  ) AS 'status on 26/12/18',
  
  IF(r.roomid IN (
      SELECT 
        r.roomid 
      FROM 
        booking b 
        JOIN room r ON b.roomid = r.roomid 
        JOIN hotel h ON h.hotelid = r.hotelid 
      WHERE 
        '2018-12-27' BETWEEN checkindate 
        AND checkoutdate 
        AND h.name = 'Finzels Reach' 
        AND r.roomNumber = '204'
    ), 
    Concat(
      'booked by ', 
      (
        SELECT 
          Concat(
            c.title, ' ', c.fname, ' ', c.lname
          ) 
        FROM 
          customer c 
          JOIN booking b ON b.customerid = c.customerid 
          JOIN room r ON r.roomid = b.roomid 
          JOIN hotel h ON h.hotelid = r.hotelid 
        WHERE 
          '2018-12-27' BETWEEN b.checkindate 
          AND b.checkoutdate 
          AND r.roomnumber = '204' 
          AND h.name = 'Finzels Reach'
      )
    ), 
    'available'
  ) AS 'status on 27/12/18', 
  
  IF(
    r.roomid IN (
      SELECT 
        r.roomid 
      FROM 
        booking b 
        JOIN room r ON b.roomid = r.roomid 
        JOIN hotel h ON h.hotelid = r.hotelid 
      WHERE 
        '2018-12-28' BETWEEN checkindate 
        AND checkoutdate 
        AND h.name = 'Finzels Reach' 
        AND r.roomNumber = '204'
    ), 
    Concat(
      'booked by ', 
      (
        SELECT 
          Concat(
            c.title, ' ', c.fname, ' ', c.lname
          ) 
        FROM 
          customer c 
          JOIN booking b ON b.customerid = c.customerid 
          JOIN room r ON r.roomid = b.roomid 
          JOIN hotel h ON h.hotelid = r.hotelid 
        WHERE 
          '2018-12-28' BETWEEN b.checkindate 
          AND b.checkoutdate 
          AND r.roomnumber = '204' 
          AND h.name = 'Finzels Reach'
      )
    ), 
    'available'
  ) AS 'status on 28/12/18', 
  
  IF(
    r.roomid IN (
      SELECT 
        r.roomid 
      FROM 
        booking b 
        JOIN room r ON b.roomid = r.roomid 
        JOIN hotel h ON h.hotelid = r.hotelid 
      WHERE 
        '2018-12-29' BETWEEN checkindate 
        AND checkoutdate 
        AND h.name = 'Finzels Reach' 
        AND r.roomNumber = '204'
    ), 
    Concat(
      'booked by ', 
      (
        SELECT 
          Concat(
            c.title, ' ', c.fname, ' ', c.lname
          ) 
        FROM 
          customer c 
          JOIN booking b ON b.customerid = c.customerid 
          JOIN room r ON r.roomid = b.roomid 
          JOIN hotel h ON h.hotelid = r.hotelid 
        WHERE 
          '2018-12-29' BETWEEN b.checkindate 
          AND b.checkoutdate 
          AND r.roomnumber = '204' 
          AND h.name = 'Finzels Reach'
      )
    ), 
    'available'
  ) AS 'status on 29/12/18', 
  
  IF(
    r.roomid IN (
      SELECT 
        r.roomid 
      FROM 
        booking b 
        JOIN room r ON b.roomid = r.roomid 
        JOIN hotel h ON h.hotelid = r.hotelid 
      WHERE 
        '2018-12-30' BETWEEN checkindate 
        AND checkoutdate 
        AND h.name = 'Finzels Reach' 
        AND r.roomNumber = '204'
    ), 
    Concat(
      'booked by ', 
      (
        SELECT 
          Concat(
            c.title, ' ', c.fname, ' ', c.lname
          ) 
        FROM 
          customer c 
          JOIN booking b ON b.customerid = c.customerid 
          JOIN room r ON r.roomid = b.roomid 
          JOIN hotel h ON h.hotelid = r.hotelid 
        WHERE 
          '2018-12-30' BETWEEN b.checkindate 
          AND b.checkoutdate 
          AND r.roomnumber = '204' 
          AND h.name = 'Finzels Reach'
      )
    ), 
    'available'
  ) AS 'status on 30/12/18' 
  
FROM 
  room r 
  JOIN hotel h ON r.hotelid = h.hotelid 
WHERE 
  h.name = 'Finzels Reach' 
  AND r.roomnumber = '204';
  
  
-- Part I
SELECT 
  h.name AS 'Hotel', 
  '26/12/2018' AS 'Date', 
  SUM(b.adultNumber) + SUM(b.childrenNumber) AS 'Total Breakfasts' 
FROM 
  Booking b 
  JOIN Room r ON r.roomId = b.roomId 
  JOIN Hotel h ON h.hotelId = r.hotelId 
WHERE 
  h.name = 'Finzels Reach' 
  AND '2018-12-26' BETWEEN b.checkInDate 
  AND b.checkOutDate 
  AND breakfast = TRUE;
