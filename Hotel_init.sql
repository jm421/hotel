/*
Hotel_init.sql

RDBMS used: MySQL
*/

DROP 
  DATABASE IF EXISTS hoteldb;
CREATE DATABASE HotelDB;
USE HotelDB;

CREATE TABLE Customer (
  customerID INTEGER NOT NULL AUTO_INCREMENT, 
  title ENUM('Mr', 'Mrs', 'Miss', 'Master', 'Dr') NULL, 
  fName VARCHAR(30) NOT NULL, 
  lName VARCHAR(30) NULL, 
  telephone VARCHAR(11) NOT NULL, 
  street VARCHAR(50) NOT NULL, 
  city VARCHAR(30) NOT NULL, 
  postCode VARCHAR(8) NOT NULL, 
  cardNumber VARCHAR(16) NULL, 
  expirationDate VARCHAR(7) NULL, 
  email VARCHAR(100) NOT NULL, 
  PRIMARY KEY (customerID)
);

CREATE TABLE Hotel (
  hotelID INTEGER NOT NULL AUTO_INCREMENT, 
  name VARCHAR(30) NOT NULL, 
  street VARCHAR(30) NOT NULL, 
  city VARCHAR(30) NOT NULL, 
  postCode VARCHAR(8) NOT NULL, 
  telephone VARCHAR(11) NOT NULL, 
  publicRating DECIMAL(3, 1) NOT NULL, 
  singlePrice DECIMAL(10, 2) NOT NULL, 
  twinPrice DECIMAL(10, 2) NOT NULL, 
  doublePrice DECIMAL(10, 2) NOT NULL, 
  familyPrice DECIMAL(10, 2) NOT NULL, 
  singleDiscount DECIMAL(10, 2) NOT NULL, 
  twinDiscount DECIMAL(10, 2) NOT NULL, 
  doubleDiscount DECIMAL(10, 2) NOT NULL, 
  familyDiscount DECIMAL(10, 2) NOT NULL, 
  gracePeriod INTEGER NOT NULL, 
  breakfastPrice DECIMAL(10, 2) NOT NULL, 
  freeParking BOOLEAN NOT NULL, 
  freeWifi BOOLEAN NOT NULL, 
  airConditioning BOOLEAN NOT NULL, 
  liftAccess BOOLEAN NOT NULL, 
  breakfastOnly BOOLEAN NOT NULL, 
  restaurant BOOLEAN NOT NULL, 
  chargeableParking BOOLEAN NOT NULL, 
  PRIMARY KEY (hotelID)
);

CREATE TABLE Room (
  roomID INTEGER NOT NULL AUTO_INCREMENT, 
  hotelID INTEGER NOT NULL, 
  roomNumber INTEGER NOT NULL, 
  roomType ENUM('Single', 'Double', 'Twin', 'Family') NOT NULL, 
  FOREIGN KEY (hotelID) REFERENCES Hotel (hotelID), 
  PRIMARY KEY (roomID)
);

CREATE TABLE Booking (
  bookingID INTEGER NOT NULL AUTO_INCREMENT, 
  customerID INTEGER NOT NULL, 
  roomID INTEGER NOT NULL, 
  bookingDate DATE NOT NULL, 
  checkInDate DATE NOT NULL, 
  checkOutDate DATE NOT NULL, 
  adultNumber INTEGER NULL, 
  childrenNumber INTEGER NULL, 
  specialInstruction VARCHAR(100) NULL, 
  breakfast BOOLEAN NOT NULL, 
  paymentOption ENUM('pay on arrival', 'pay immediately') NULL, 
  FOREIGN KEY (customerID) REFERENCES Customer (customerID), 
  FOREIGN KEY (roomID) REFERENCES Room (roomID), 
  PRIMARY KEY (bookingID)
);

INSERT INTO Customer (
  customerID, title, fName, lName, telephone, 
  street, city, postCode, cardNumber, 
  expirationDate, email
) 
VALUES 
  (NULL, 'Mr', 'Ian', 'Cooper', '07454245098', '8 Grove Road', 'Exeter', 'EX4 6PN', '4546098711112340', '10/2020', 'i.cooper@gmail.com'), 
  (NULL, 'Mr', 'Joe', 'Smiths', '07123456778', '2 Park Road', 'Exeter', 'EX1 2AB', '3648756294756287', '04/2021', 'j.smiths@yahoo.com'), 
  (NULL, 'Mrs', 'Jane', 'Bloggs', '07364722837', '11 Mount Pleasant', 'Exeter', 'EX1 7XE', '9182736481027463', '01/2020', 'j.bloggs@hotmail.com'), 
  (NULL, 'Dr', 'William', 'Reynolds', '07916200182', '13 Union Road', 'Exeter', 'EX2 8ZB', '0982364721837510', '06/2022', 'w.reynolds@outlook.com'), 
  (NULL, 'Mr', 'John', 'Doe', '07192866938', '4 Pinhoe Road', 'Exeter', 'EX1 9YA', '6437548361529983', '09/2020', 'j.doe@gmail.com'), 
  (NULL, NULL, 'Refurbishment Company', NULL, '07153478452', '1 Broad Street', 'Bristol', 'BS1 5AB', NULL, NULL, 'refurbishment_company@gmail.com'
);
  
INSERT INTO Hotel (
  hotelID, name, street, city, postCode, 
  telephone, publicRating, singlePrice, 
  twinPrice, doublePrice, familyPrice, 
  singleDiscount, twinDiscount, doubleDiscount, 
  familyDiscount, gracePeriod, breakfastPrice, 
  freeParking, freeWifi, airConditioning, 
  liftAccess, breakfastOnly, restaurant, 
  chargeableParking
) 
VALUES 
  (NULL, 'Finzels Reach', 'Finzels Reach', 'Bristol', 'BS1 6BX', '08716222428', '7.5', '65', '70', '75', '85', '0.3', '0.2', '0.15', '0.15', '14', '10', TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE), 
  (NULL, 'HayMarket', 'The Haymarket', 'Bristol', 'BS1 3LP', '08715278156', '8.1', '70', '76', '82', '90', '0.25', '0.18', '0.15', '0.1', '10', '8.5', FALSE, TRUE, TRUE, FALSE, FALSE, TRUE, TRUE), 
  (NULL, 'King Street', 'Llandoger Trow, King Street', 'Bristol', 'BS1 3LP', '08715278158', '8.8', '90', '100', '120', '135', '0.15', '0.2', '0.2', '0.2', '14', '0', FALSE, TRUE, TRUE, TRUE, FALSE, TRUE, FALSE), 
  (NULL, 'The Globe', 'Fore Street, Topsham', 'Exeter', 'EX3 0HR', '0.4', '9.1', '59', '65', '68', '76', '0.4', '0.4', '0.4', '0.4', '21', '6', TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, TRUE), 
  (NULL, 'Hilton Garden Inn', 'Temple Way', 'Bristol', 'BS1 6BF', '01179247823', '8.9', '58', '59', '64', '67', '0.2', '0.25', '0.3', '0.3', '21', '6.59', TRUE, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE);

INSERT INTO Room (
  roomID, roomNumber, roomType, hotelID
) 
VALUES 
  (NULL, '204', 'Double', '1'), 
  (NULL, '205', 'Single', '1'), 
  (NULL, '206', 'Double', '1'), 
  (NULL, '101', 'Family', '1'), 
  (NULL, '102', 'Twin', '1'), 
  (NULL, '304', 'Single', '2'), 
  (NULL, '305', 'Double', '2'), 
  (NULL, '50', 'Family', '3'), 
  (NULL, '23', 'Twin', '3'), 
  (NULL, '70', 'Twin', '4'), 
  (NULL, '452', 'Family', '5');
  
INSERT INTO Booking (
  bookingID, customerID, roomID, bookingDate, 
  checkInDate, checkOutDate, adultNumber, 
  childrenNumber, specialInstruction, 
  breakfast, paymentOption
) 
VALUES 
  (NULL, '1', '1', '2018-11-20', '2018-12-26', '2018-12-28', '2', '0', 'Arrive around 10pm', TRUE, 'pay immediately'), 
  (NULL, '3', '6', '2018-11-28', '2018-12-29', '2018-12-30', '1', '0', NULL, TRUE, 'pay on arrival'), 
  (NULL, '4', '10', '2018-11-30', '2018-12-25', '2018-12-30', '2', '0', NULL, TRUE, 'pay immediately'), 
  (NULL, '5', '11', '2018-11-30', '2018-12-27', '2018-12-29', '2', '2', NULL, FALSE, 'pay immediately');
