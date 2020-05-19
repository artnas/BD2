CREATE DATABASE  IF NOT EXISTS mydb /*!40100 DEFAULT CHARACTER SET utf8 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE mydb;
-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: mydb
-- ------------------------------------------------------
-- Server version	8.0.19

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table addresses
--

DROP TABLE IF EXISTS addresses;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE addresses (
  id int NOT NULL AUTO_INCREMENT,
  street varchar(45) NOT NULL,
  street_number varchar(8) NOT NULL,
  locality varchar(45) NOT NULL,
  postal_code varchar(6) NOT NULL,
  country varchar(3) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=248 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table bills
--

DROP TABLE IF EXISTS bills;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE bills (
  id int NOT NULL AUTO_INCREMENT,
  total_cost decimal(5,2) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=35148 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table cameras
--

DROP TABLE IF EXISTS cameras;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE cameras (
  id int NOT NULL AUTO_INCREMENT,
  is_active tinyint DEFAULT NULL,
  parking_lot_id int NOT NULL,
  PRIMARY KEY (id),
  KEY fk_Camera_ParkingLot1_idx (parking_lot_id),
  CONSTRAINT fk_Camera_ParkingLot1 FOREIGN KEY (parking_lot_id) REFERENCES parkinglots (id)
) ENGINE=InnoDB AUTO_INCREMENT=351 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table controllers
--

DROP TABLE IF EXISTS controllers;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE controllers (
  id int NOT NULL AUTO_INCREMENT,
  name varchar(45) NOT NULL,
  surname varchar(45) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=144 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table eparkingtickets
--

DROP TABLE IF EXISTS eparkingtickets;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE eparkingtickets (
  id int NOT NULL AUTO_INCREMENT,
  start_date datetime NOT NULL,
  end_date datetime DEFAULT NULL,
  status enum('STARTED','ENDED','CANCELLED','PAID') NOT NULL,
  vehicle_id int NOT NULL,
  parking_lot_id int NOT NULL,
  bill_id int DEFAULT NULL,
  fine_id int DEFAULT NULL,
  PRIMARY KEY (id,parking_lot_id,vehicle_id),
  KEY fk_occupation_car1_idx (vehicle_id),
  KEY fk_VirtualOccupation_ParkingLot1_idx (parking_lot_id),
  KEY fk_EParkingTicket_Bill1_idx (bill_id),
  KEY fk_EParkingTicket_Fine1_idx (fine_id),
  CONSTRAINT fk_EParkingTicket_Bill1 FOREIGN KEY (bill_id) REFERENCES bills (id),
  CONSTRAINT fk_EParkingTicket_Fine1 FOREIGN KEY (fine_id) REFERENCES fines (id),
  CONSTRAINT fk_occupation_car1 FOREIGN KEY (vehicle_id) REFERENCES vehicles (id),
  CONSTRAINT fk_VirtualOccupation_ParkingLot1 FOREIGN KEY (parking_lot_id) REFERENCES parkinglots (id)
) ENGINE=InnoDB AUTO_INCREMENT=35148 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table fines
--

DROP TABLE IF EXISTS fines;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE fines (
  id int NOT NULL AUTO_INCREMENT,
  total_cost decimal(5,2) NOT NULL,
  controller_id int NOT NULL,
  PRIMARY KEY (id),
  KEY fk_Fine_Controller1_idx (controller_id),
  CONSTRAINT fk_Fine_Controller1 FOREIGN KEY (controller_id) REFERENCES controllers (id)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table parkinglots
--

DROP TABLE IF EXISTS parkinglots;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE parkinglots (
  id int NOT NULL AUTO_INCREMENT,
  name varchar(50) DEFAULT NULL,
  capacity int unsigned NOT NULL,
  occupied_spots int unsigned NOT NULL DEFAULT '0',
  address_id int NOT NULL,
  zone_id int NOT NULL,
  PRIMARY KEY (id),
  KEY fk_Street_Address1_idx (address_id),
  KEY fk_ParkingLot_Zone1_idx (zone_id),
  CONSTRAINT fk_ParkingLot_Zone1 FOREIGN KEY (zone_id) REFERENCES zones (id),
  CONSTRAINT fk_Street_Address1 FOREIGN KEY (address_id) REFERENCES addresses (id)
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;

DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table parkingmeters
--

DROP TABLE IF EXISTS parkingmeters;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE parkingmeters (
  id int NOT NULL AUTO_INCREMENT,
  nfc_tag_id varchar(6) NOT NULL,
  parking_lot_id int NOT NULL,
  PRIMARY KEY (id),
  KEY fk_ParkingMeter_ParkingLot1_idx (parking_lot_id),
  CONSTRAINT fk_ParkingMeter_ParkingLot1 FOREIGN KEY (parking_lot_id) REFERENCES parkinglots (id)
) ENGINE=InnoDB AUTO_INCREMENT=279 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table payments
--

DROP TABLE IF EXISTS payments;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE payments (
  id int NOT NULL AUTO_INCREMENT,
  date datetime NOT NULL,
  status enum('success','failure') NOT NULL,
  payment_reference int NOT NULL,
  bill_id int DEFAULT NULL,
  fine_id int DEFAULT NULL,
  PRIMARY KEY (id),
  KEY bill_id_idx (bill_id),
  KEY fine_id_idx (fine_id),
  CONSTRAINT bill_id FOREIGN KEY (bill_id) REFERENCES bills (id),
  CONSTRAINT fine_id FOREIGN KEY (fine_id) REFERENCES fines (id)
) ENGINE=InnoDB AUTO_INCREMENT=35289 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table users
--

DROP TABLE IF EXISTS users;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE users (
  id int NOT NULL AUTO_INCREMENT,
  login varchar(45) NOT NULL,
  password varchar(45) NOT NULL,
  is_admin tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (id),
  UNIQUE KEY login (login)
) ENGINE=InnoDB AUTO_INCREMENT=24463 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table vehicles
--

DROP TABLE IF EXISTS vehicles;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE vehicles (
  id int NOT NULL AUTO_INCREMENT,
  model_name varchar(40) NOT NULL,
  license_plate varchar(7) NOT NULL,
  user_id int DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY license_plate (license_plate),
  KEY fk_car_user1_idx (user_id),
  CONSTRAINT fk_car_user1 FOREIGN KEY (user_id) REFERENCES users (id)
) ENGINE=InnoDB AUTO_INCREMENT=24463 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table zones
--

DROP TABLE IF EXISTS zones;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE zones (
  id int NOT NULL AUTO_INCREMENT,
  cost_per_hour decimal(5,2) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'mydb'
--
/*!50003 DROP PROCEDURE IF EXISTS create_bills_for_all_tickets */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=root@localhost PROCEDURE create_bills_for_all_tickets()
BEGIN
	set @min_id = (select min(id) from eparkingtickets);
    set @max_id = (select max(id) from eparkingtickets);
	#set @min_id = 1;
	#set @max_id = 5;
    set @ticket_id = @min_id - 1;
    
	all_tickets: LOOP
		SET @ticket_id = @ticket_id + 1;
		IF @ticket_id <= @max_id THEN
			call create_bill_for_a_ticket(@ticket_id);
            #select @ticket_id;
            ITERATE all_tickets;
		END IF;
		LEAVE all_tickets;        
	END LOOP all_tickets;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS create_bill_for_a_ticket */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=root@localhost PROCEDURE create_bill_for_a_ticket(IN ticket_id int)
BEGIN
	set @cost_per_hour = (select z.cost_per_hour from eparkingtickets t left join parkinglots p on t.parking_lot_id = p.id
											left join zones z on z.id = p.zone_id
						   where t.id = ticket_id
						  );
    set @number_of_hours = (select TIMESTAMPDIFF(MINUTE,start_date, end_date)/60 from eparkingtickets where id = ticket_id);
    
    # create new bill on bills table
	insert into bills (total_cost) values(
			@cost_per_hour*@number_of_hours
            );
	# add id of the new bill as a foreign key of eparkingtickets table
    set @new_inserted_id = LAST_INSERT_ID();
    update eparkingtickets set Bill_id = @new_inserted_id where id = ticket_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS create_fines_for_few_tickets */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=root@localhost PROCEDURE create_fines_for_few_tickets(IN percent double, explode int)
BEGIN
    set @max_id = (select max(id) from eparkingtickets);
    #set @max_id = 200;
    set @no_fines = @max_id*percent/100;
    set @count = 0;
    
	examine_fines: LOOP
		set @count = @count + 1;
        set @ticket_id = floor(rand()*@max_id);
		IF @count <= @no_fines THEN
			call create_fine_for_a_ticket(@ticket_id, explode);
            #select @count;
            ITERATE examine_fines;
		END IF;
		LEAVE examine_fines;        
	END LOOP examine_fines;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS create_fine_for_a_ticket */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=root@localhost PROCEDURE create_fine_for_a_ticket(IN ticket_id int, explode int)
BEGIN
	set @cost_per_hour = (select z.cost_per_hour from eparkingtickets t left join parkinglots p on t.parking_lot_id = p.id
											left join zones z on z.id = p.zone_id
						   where t.id = ticket_id
						  );
    set @number_of_hours = (select TIMESTAMPDIFF(MINUTE,start_date, end_date)/60 from eparkingtickets where id = ticket_id);
    
    # create new fine
    set @random_controller_id = floor(rand()*(select max(id) from controllers));
	insert into fines (total_cost, controller_id) values(
			@cost_per_hour*@number_of_hours*explode, @random_controller_id
            );
	
    # add id of the new fine as a foreign key of eparkingtickets table
    set @new_inserted_id = LAST_INSERT_ID();
    # get bill_id of this ticket
    set @bill_id = (select bill_id from eparkingtickets where id = ticket_id);
    update eparkingtickets set fine_id = @new_inserted_id, bill_id = null where id = ticket_id;
    # remove bill of this ticket
    delete from bills where id = @bill_id;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS create_payments_for_all_bills */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=root@localhost PROCEDURE create_payments_for_all_bills()
BEGIN
	set @min_id = (select min(id) from bills);
    set @max_id = (select max(id) from bills);
	#set @min_id = 1;
	#set @max_id = 5;
    set @bill_id = @min_id - 1;
    
	all_bills: LOOP
		SET @bill_id = @bill_id + 1;
		IF @bill_id <= @max_id THEN
			set @bill_id_exist = (select count(*) from bills where id = @bill_id);
            if @bill_id_exist = 1 then
				call create_payment_for_a_bill(@bill_id);
				#select @bill_id;
            end if;
            ITERATE all_bills;
		END IF;
		LEAVE all_bills;        
	END LOOP all_bills;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS create_payments_for_all_fines */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=root@localhost PROCEDURE create_payments_for_all_fines()
BEGIN
	set @min_id = (select min(id) from fines);
    set @max_id = (select max(id) from fines);
	#set @min_id = 1;
	#set @max_id = 5;
    set @fine_id = @min_id - 1;
    
	all_fines: LOOP
		SET @fine_id = @fine_id + 1;
		IF @fine_id <= @max_id THEN
			set @fine_id_exist = (select count(*) from fines where id = @fine_id);
            if @fine_id_exist = 1 then
				call create_payment_for_a_fine(@fine_id);
				#select @fine_id;
            end if;
            ITERATE all_fines;
		END IF;
		LEAVE all_fines;        
	END LOOP all_fines;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS create_payment_for_a_bill */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=root@localhost PROCEDURE create_payment_for_a_bill(IN bill_id int)
BEGIN
	set @payment_date = date_add((select t.end_date from bills b join eparkingtickets t on b.id = t.bill_id where b.id = bill_id), 
									interval 5 SECOND);
    set @payment_reference_number = 1102000000 + bill_id;
    
    # create new payment 
	insert into payments (date, status, payment_reference, bill_id, fine_id) values(
			@payment_date, 'success', @payment_reference_number, bill_id, null
            );
	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS create_payment_for_a_fine */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=root@localhost PROCEDURE create_payment_for_a_fine(IN fine_id int)
BEGIN
	set @payment_date = date_add((select t.end_date from fines f join eparkingtickets t on f.id = t.fine_id where f.id = fine_id), 
									interval 7*24*rand()  HOUR);
    set @payment_reference_number = 1199000000 + fine_id;
    
    # create new payment 
	insert into payments (date, status, payment_reference, bill_id, fine_id) values(
			@payment_date, 'success', @payment_reference_number, null, fine_id
            );
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-05-18  1:47:56
