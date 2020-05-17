SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- create database schema in case it doesn't exist
CREATE SCHEMA IF NOT EXISTS mydb DEFAULT CHARACTER SET utf8 ;
USE mydb;

-- delete whole database to clear up state
DROP DATABASE mydb;

-- create clear database schema once again
CREATE SCHEMA IF NOT EXISTS mydb DEFAULT CHARACTER SET utf8 ;
USE mydb;

-- create all system's tables table by table

CREATE TABLE IF NOT EXISTS Addresses (
  id INT NOT NULL AUTO_INCREMENT,
  street VARCHAR(45) NOT NULL,
  street_number VARCHAR(8) NOT NULL,
  locality VARCHAR(45) NOT NULL,
  postal_code VARCHAR(6) NOT NULL,
  country VARCHAR(3) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS Zones (
  id INT NOT NULL AUTO_INCREMENT,
  cost_per_hour DECIMAL(5,2) NULL,
  PRIMARY KEY (id)
)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS ParkingLots (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NULL,
  capacity INT UNSIGNED NOT NULL,
  occupied_spots INT UNSIGNED NOT NULL DEFAULT 0,
  address_id INT NOT NULL,
  zone_id INT NOT NULL,
  PRIMARY KEY (id),
  INDEX fk_Street_Address1_idx (address_id ASC),
  INDEX fk_ParkingLot_Zone1_idx (zone_id ASC),
  CONSTRAINT fk_Street_Address1
    FOREIGN KEY (address_id)
    REFERENCES Addresses (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ParkingLot_Zone1
    FOREIGN KEY (zone_id)
    REFERENCES Zones (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS Cameras (
  id INT NOT NULL AUTO_INCREMENT,
  is_active TINYINT NULL,
  parking_lot_id INT NOT NULL,
  PRIMARY KEY (id),
  INDEX fk_Camera_ParkingLot1_idx (parking_lot_id ASC),
  CONSTRAINT fk_Camera_ParkingLot1
    FOREIGN KEY (parking_lot_id)
    REFERENCES ParkingLots (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS Users (
  id INT NOT NULL AUTO_INCREMENT,
  login VARCHAR(45) UNIQUE NOT NULL,
  password VARCHAR(45) NOT NULL,
  is_admin TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS Vehicles (
  id INT NOT NULL AUTO_INCREMENT,
  model_name VARCHAR(40) NOT NULL,
  license_plate VARCHAR(7) UNIQUE NOT NULL,
  user_id INT NULL,
  PRIMARY KEY (id),
  INDEX fk_car_user1_idx (user_id ASC),
  CONSTRAINT fk_car_user1
    FOREIGN KEY (user_id)
    REFERENCES Users (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS Bills (
  id INT NOT NULL AUTO_INCREMENT,
  total_cost DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS Controllers (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(45) NOT NULL,
  surname VARCHAR(45) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS Fines (
  id INT NOT NULL AUTO_INCREMENT,
  total_cost DECIMAL(5,2) NOT NULL,
  controller_id INT NOT NULL,
  PRIMARY KEY (id),
  INDEX fk_Fine_Controller1_idx (controller_id ASC),
  CONSTRAINT fk_Fine_Controller1
    FOREIGN KEY (controller_id)
    REFERENCES Controllers (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS EParkingTickets (
  id INT NOT NULL AUTO_INCREMENT,
  start_date DATETIME NOT NULL,
  end_date DATETIME NULL,
  status ENUM('STARTED', 'ENDED', 'CANCELLED', 'PAID') NOT NULL,
  vehicle_id INT NOT NULL,
  parking_lot_id INT NOT NULL,
  bill_id INT NULL,
  fine_id INT NULL,
  PRIMARY KEY (id, parking_lot_id, vehicle_id),
  INDEX fk_occupation_car1_idx (vehicle_id ASC),
  INDEX fk_VirtualOccupation_ParkingLot1_idx (parking_lot_id ASC),
  INDEX fk_EParkingTicket_Bill1_idx (bill_id ASC),
  INDEX fk_EParkingTicket_Fine1_idx (fine_id ASC),
  CONSTRAINT fk_occupation_car1
    FOREIGN KEY (vehicle_id)
    REFERENCES Vehicles (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_VirtualOccupation_ParkingLot1
    FOREIGN KEY (parking_lot_id)
    REFERENCES ParkingLots (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_EParkingTicket_Bill1
    FOREIGN KEY (bill_id)
    REFERENCES Bills (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_EParkingTicket_Fine1
    FOREIGN KEY (fine_id)
    REFERENCES Fines (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS ParkingMeters (
  id INT NOT NULL AUTO_INCREMENT,
  nfc_tag_id VARCHAR(6) NOT NULL,
  parking_lot_id INT NOT NULL,
  PRIMARY KEY (id),
  INDEX fk_ParkingMeter_ParkingLot1_idx (parking_lot_id ASC),
  CONSTRAINT fk_ParkingMeter_ParkingLot1
    FOREIGN KEY (parking_lot_id)
    REFERENCES ParkingLots (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS Payments (
  id INT NOT NULL AUTO_INCREMENT,
  date DATETIME NOT NULL,
  status ENUM('success', 'failure') NOT NULL,
  payment_reference INT NOT NULL,
  bill_id INT NULL,
  fine_id INT NULL,
  PRIMARY KEY (id),
  INDEX bill_id_idx (bill_id ASC),
  INDEX fine_id_idx (fine_id ASC),
  CONSTRAINT bill_id
    FOREIGN KEY (bill_id)
    REFERENCES Bills (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fine_id
    FOREIGN KEY (fine_id)
    REFERENCES Fines (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- triggers

delimiter $$
create trigger prevent_wrong_capacity_insert before insert on ParkingLots
for each row
begin
	if (new.occupied_spots > new.capacity) then
		signal sqlstate '45000' set MESSAGE_TEXT = "You can't insert Lot with occupied_spots > capacity";
    end if;
end $$
delimiter ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- clean state of the database