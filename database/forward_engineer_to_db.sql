-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS mydb DEFAULT CHARACTER SET utf8 ;
USE mydb ;

-- -----------------------------------------------------
-- Table mydb.Address
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.Address (
  id INT NOT NULL AUTO_INCREMENT,
  street VARCHAR(45) NOT NULL,
  street_number VARCHAR(8) NOT NULL,
  locality VARCHAR(45) NOT NULL,
  postal_code VARCHAR(6) NOT NULL,
  country VARCHAR(3) NOT NULL,
  PRIMARY KEY (id))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table mydb.Zone
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.Zone (
  id INT NOT NULL AUTO_INCREMENT,
  cost_per_hour DECIMAL(5,2) NULL,
  PRIMARY KEY (id))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table mydb.ParkingLot
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.ParkingLot (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(50) NULL,
  capacity INT UNSIGNED NOT NULL,
  occupied_spots INT UNSIGNED NOT NULL,
  address_id INT NOT NULL,
  zone_id INT NOT NULL,
  PRIMARY KEY (id),
  INDEX fk_Street_Address1_idx (address_id ASC),
  INDEX fk_ParkingLot_Zone1_idx (zone_id ASC),
  CONSTRAINT fk_Street_Address1
    FOREIGN KEY (address_id)
    REFERENCES mydb.Address (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_ParkingLot_Zone1
    FOREIGN KEY (zone_id)
    REFERENCES mydb.Zone (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table mydb.Camera
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.Camera (
  id INT NOT NULL AUTO_INCREMENT,
  is_active TINYINT(1) NULL,
  parking_lot_id INT NOT NULL,
  PRIMARY KEY (id),
  INDEX fk_Camera_ParkingLot1_idx (parking_lot_id ASC),
  CONSTRAINT fk_Camera_ParkingLot1
    FOREIGN KEY (parking_lot_id)
    REFERENCES mydb.ParkingLot (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table mydb.User
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.User (
  id INT NOT NULL AUTO_INCREMENT,
  login VARCHAR(45) NOT NULL,
  password VARCHAR(45) NOT NULL,
  is_admin TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (id))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table mydb.Vehicle
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.Vehicle (
  id INT NOT NULL AUTO_INCREMENT,
  model_name VARCHAR(40) NOT NULL,
  license_plate VARCHAR(7) NULL,
  user_id INT NULL,
  PRIMARY KEY (id),
  INDEX fk_car_user1_idx (user_id ASC),
  CONSTRAINT fk_car_user1
    FOREIGN KEY (user_id)
    REFERENCES mydb.User (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table mydb.Bill
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.Bill (
  id INT NOT NULL AUTO_INCREMENT,
  total_cost DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (id))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table mydb.Controller
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.Controller (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(45) NULL,
  surname VARCHAR(45) NULL,
  PRIMARY KEY (id))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table mydb.Fine
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.Fine (
  id INT NOT NULL,
  total_cost DECIMAL(5,2) NOT NULL,
  controller_id INT NOT NULL,
  PRIMARY KEY (id),
  INDEX fk_Fine_Controller1_idx (controller_id ASC),
  CONSTRAINT fk_Fine_Controller1
    FOREIGN KEY (controller_id)
    REFERENCES mydb.Controller (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table mydb.EParkingTicket
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.EParkingTicket (
  id INT NOT NULL AUTO_INCREMENT,
  start_date DATETIME NOT NULL,
  end_date DATETIME NULL,
  status ENUM('STARTED', 'ENDED', 'CANCELLED', 'PAID') NOT NULL,
  vehicle_id INT NOT NULL,
  parking_lot_id INT NOT NULL,
  Bill_id INT NULL,
  Fine_id INT NULL,
  PRIMARY KEY (id, parking_lot_id, vehicle_id),
  INDEX fk_occupation_car1_idx (vehicle_id ASC),
  INDEX fk_VirtualOccupation_ParkingLot1_idx (parking_lot_id ASC),
  INDEX fk_EParkingTicket_Bill1_idx (Bill_id ASC),
  INDEX fk_EParkingTicket_Fine1_idx (Fine_id ASC),
  CONSTRAINT fk_occupation_car1
    FOREIGN KEY (vehicle_id)
    REFERENCES mydb.Vehicle (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_VirtualOccupation_ParkingLot1
    FOREIGN KEY (parking_lot_id)
    REFERENCES mydb.ParkingLot (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_EParkingTicket_Bill1
    FOREIGN KEY (Bill_id)
    REFERENCES mydb.Bill (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_EParkingTicket_Fine1
    FOREIGN KEY (Fine_id)
    REFERENCES mydb.Fine (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table mydb.ParkingMeter
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.ParkingMeter (
  id INT NOT NULL AUTO_INCREMENT,
  nfc_tag_id VARCHAR(6) NOT NULL,
  parking_lot_id INT NOT NULL,
  PRIMARY KEY (id),
  INDEX fk_ParkingMeter_ParkingLot1_idx (parking_lot_id ASC),
  CONSTRAINT fk_ParkingMeter_ParkingLot1
    FOREIGN KEY (parking_lot_id)
    REFERENCES mydb.ParkingLot (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table mydb.Payment
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.Payment (
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
    REFERENCES mydb.Bill (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fine_id
    FOREIGN KEY (fine_id)
    REFERENCES mydb.Fine (id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;