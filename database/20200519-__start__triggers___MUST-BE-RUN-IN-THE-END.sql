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

DELIMITER ;;
CREATE DEFINER=`root`@`localhost` TRIGGER `validate_insert_data` BEFORE INSERT ON `eparkingtickets` FOR EACH ROW BEGIN
    if (new.end_date < new.start_date) then
		signal sqlstate '45000' set MESSAGE_TEXT = "End_date must be later than start_date.";
	else if (new.end_date is not null and new.status <> 'END') then
		signal sqlstate '45000' set MESSAGE_TEXT = "Ticket must be ended due to end_date given.";
	else if (new.end_date is null and new.status <> 'STARTED') then
		signal sqlstate '45000' set MESSAGE_TEXT = "Ticket must be only started due to end_date not given.";
	end if; 
    end if;
    end if;
END
;;

DELIMITER ;;
CREATE DEFINER=`root`@`localhost` TRIGGER `validate_update_data` BEFORE UPDATE ON `eparkingtickets` FOR EACH ROW BEGIN
	if (new.start_date is null) then
		signal sqlstate '45000' set MESSAGE_TEXT = "Start_date can not be updated.";
	else if (new.end_date < old.start_date) then
		signal sqlstate '45000' set MESSAGE_TEXT = "End_date must be later than start_date.";
	else if (new.vehicle_id <> old.vehicle_id OR 
             new.parking_lot_id <> old.parking_lot_id
             ) then 
		signal sqlstate '45000' set MESSAGE_TEXT = "Vehicle and Parkinglot can not be changed.";
	end if;
    end if;
    end if;
END
;;

DELIMITER ;;
CREATE DEFINER=`root`@`localhost` TRIGGER `block_invalid_name_capacity_occupied_spots` BEFORE INSERT ON `parkinglots` FOR EACH ROW BEGIN
	if ( trim(new.name) = '' OR
         new.capacity <= 0 OR  
         (new.occupied_spots <> 0)
	    ) then
			signal sqlstate '45000' set MESSAGE_TEXT = "Name must not be empty, capacity must be positive, and occupied spots must be zero.";
    end if;
END
;;

DELIMITER ;;
CREATE DEFINER=`root`@`localhost` TRIGGER `block_invalid_changes` BEFORE UPDATE ON `parkinglots` FOR EACH ROW BEGIN
	if ( trim(new.name) = '' OR
         new.capacity <= 0
	    ) then
			signal sqlstate '45000' set MESSAGE_TEXT = "Name must not be empty, capacity must be positive.";
	else if (new.address_id <> old.address_id OR new.zone_id <> old.zone_id) then
			signal sqlstate '45000' set MESSAGE_TEXT = "Address and Zone can not be changed.";
	else if ((new.capacity < new.occupied_spots) OR  
             (new.capacity < old.occupied_spots) OR
			 (old.capacity < new.occupied_spots) 
             ) then
			signal sqlstate '45000' set MESSAGE_TEXT = "Capacity must greater or equal to occupied spots.";		
	end if;
    end if;
    end if;
END
;;