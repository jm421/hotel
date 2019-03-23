/*
Hotel_update.sql

RDBMS used: MySQL
*/

USE HotelDb;

SET SQL_SAFE_UPDATES = 0;

-- Part A
UPDATE 
  Hotel 
SET 
  publicRating = '8.0' 
WHERE 
  name = 'Finzels Reach';
  
  
-- Part B
-- Hotel search query finds the price of the room before he books
INSERT INTO Booking ( 		-- Make the booking
  bookingID, customerID, roomID, bookingDate, 
  checkInDate, checkOutDate, adultNumber, 
  childrenNumber, specialInstruction, 
  breakfast, paymentOption
) VALUE (
  NULL, 
  (
    -- Find customer ID for Joe Smiths
    SELECT 
      customerID 
    FROM 
      Customer 
    WHERE 
      fName = 'Joe' 
      AND lName = 'Smiths'
  ), 
  (
    -- Find available double room
    SELECT 
      roomID 
    FROM 
      Room r 
      JOIN Hotel h ON r.hotelID = h.hotelID 
    WHERE 
      h.name = 'Finzels Reach' 
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
          AND h.name = 'Finzels Reach' 
          AND r.roomType = 'Double'
      )
    -- Select only one room	  
    LIMIT 
      1
  ), 
  CURDATE(), 
  '2018-12-26', 
  '2018-12-29', 
  '1', 
  '1', 
  NULL, 
  TRUE, 
  'pay on arrival'
);


-- Part C, Part 1: Produce refund amount for booking cancellation
SELECT 
  CONCAT(c.title, " ", c.fName, " ", c.lName) AS name, 
  b.bookingID AS 'Booking Reference', 
  IF(
    -- Check that it is over 1 day before check in date for a refund
    DATEDIFF(b.checkInDate, CURDATE()) > 1,
    -- Check room type, if discount had been applied and whether they ordered breakfast	
    CASE WHEN ((DATEDIFF(b.checkInDate, b.bookingDate) > h.gracePeriod) AND (r.roomType = 'Single'))
		 THEN ROUND((IF(b.breakfast = TRUE, (b.adultNumber + b.childrenNumber)* h.breakfastPrice, 0) + h.singlePrice - (h.singlePrice * h.singleDiscount)) * DATEDIFF(b.checkOutDate, b.checkInDate), 2) 
    
		 WHEN ((DATEDIFF(b.checkInDate, b.bookingDate) <= h.gracePeriod) AND (r.roomType = 'Single')) 
         THEN ROUND((IF(b.breakfast = TRUE, (b.adultNumber + b.childrenNumber)* h.breakfastPrice, 0) + h.singlePrice)* DATEDIFF(b.checkOutDate, b.checkInDate), 2)
         
         WHEN ((DATEDIFF(b.checkInDate, b.bookingDate) > h.gracePeriod) AND (r.roomType = 'Double')) 
         THEN ROUND((IF(b.breakfast = TRUE, (b.adultNumber + b.childrenNumber)* h.breakfastPrice, 0) + h.doublePrice - (h.doublePrice * h.doubleDiscount))* DATEDIFF(b.checkOutDate, b.checkInDate), 2) 
         
         WHEN ((DATEDIFF(b.checkInDate, b.bookingDate) <= h.gracePeriod) AND (r.roomType = 'Double')) 
         THEN ROUND((IF(b.breakfast = TRUE, (b.adultNumber + b.childrenNumber)* h.breakfastPrice, 0) + h.doublePrice)* DATEDIFF(b.checkOutDate, b.checkInDate), 2) 
         
         WHEN ((DATEDIFF(b.checkInDate, b.bookingDate) > h.gracePeriod) AND (r.roomType = 'Twin')) 
         THEN ROUND((IF(b.breakfast = TRUE, (b.adultNumber + b.childrenNumber)* h.breakfastPrice, 0) + h.twinPrice - (h.twinPrice * h.twinDiscount))* DATEDIFF(b.checkOutDate, b.checkInDate), 2) 
         
         WHEN ((DATEDIFF(b.checkInDate, b.bookingDate) <= h.gracePeriod) AND (r.roomType = 'Twin')) 
         THEN ROUND((IF(b.breakfast = TRUE, (b.adultNumber + b.childrenNumber)* h.breakfastPrice, 0) + h.twinPrice)* DATEDIFF(b.checkOutDate, b.checkInDate), 2) 
         
         WHEN ((DATEDIFF(b.checkInDate, b.bookingDate) > h.gracePeriod) AND (r.roomType = 'Family')) 
         THEN ROUND((IF(b.breakfast = TRUE, (b.adultNumber + b.childrenNumber)* h.breakfastPrice, 0) + h.familyPrice - (h.familyPrice * h.familyDiscount))* DATEDIFF(b.checkOutDate, b.checkInDate), 2) 
         
         WHEN ((DATEDIFF(b.checkInDate, b.bookingDate) <= h.gracePeriod) AND (r.roomType = 'Family')) 
         THEN ROUND((IF(b.breakfast = TRUE, (b.adultNumber + b.childrenNumber)* h.breakfastPrice, 0) + h.familyPrice)* DATEDIFF(b.checkOutDate, b.checkInDate), 2) 
         
         END, 'No refund'
  ) AS 'Refund Amount' 
FROM 
  Customer c 
  JOIN Booking b ON b.customerID = c.customerID 
  JOIN Room r ON r.roomID = b.roomID 
  JOIN Hotel h ON h.hotelID = r.hotelID 
WHERE 
  b.bookingID = '1'; 			-- Ian Cooper's Booking ID
  
  
-- Part C, Part 2: Remove booking from Booking table
DELETE FROM 
  Booking 
WHERE 
  bookingID = '1';
  
  
-- Part D
UPDATE 
  Hotel 
SET 
  familyDiscount = '0.05' 
WHERE 
  name = 'Finzels Reach';
  
  
-- Part E
-- Maintenance company books out the rooms making them unavailable, but does not affect the number of guests or breakfasts etc.  
INSERT INTO Booking (
  bookingID, customerID, roomID, bookingDate, 
  checkInDate, checkOutDate, adultNumber, 
  childrenNumber, specialInstruction, 
  breakfast, paymentOption
) 
SELECT 
  NULL, 
  '6', 			-- ID of maintenance company 
  roomID, 
  CURDATE(), 
  '2019-06-01', 
  '2019-06-10',
  '0',				-- No adults or children, so won't affect total guest numbers  
  '0', 
  NULL, 
  FALSE, 		-- No breakfast, so won't affect total breakfasts
  NULL 
FROM 
  Room r 
  JOIN Hotel h ON r.hotelID = h.hotelID 
WHERE 
  h.name = 'Finzels Reach'
  -- All rooms on first floor  
  AND r.roomNumber BETWEEN '100' 
  AND '199';
