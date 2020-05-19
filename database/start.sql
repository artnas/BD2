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


-- stored procedures

DELIMITER ;;
CREATE PROCEDURE create_bills_for_all_tickets()
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

DELIMITER ;;
CREATE PROCEDURE create_bill_for_a_ticket(IN ticket_id int)
BEGIN
	set @cost_per_hour = (
		select z.cost_per_hour 
        from eparkingtickets t 
        left join parkinglots p on t.parking_lot_id = p.id
		left join zones z on z.id = p.zone_id
		where t.id = ticket_id
	);
    
    set @number_of_hours = (
		select TIMESTAMPDIFF(MINUTE,start_date, end_date)/60 from eparkingtickets where id = ticket_id
	);
    
    # create new bill on bills table
	insert into bills (total_cost) values(@cost_per_hour * @number_of_hours);
	
    # add id of the new bill as a foreign key of eparkingtickets table
    set @new_inserted_id = LAST_INSERT_ID();
    update eparkingtickets 
    set Bill_id = @new_inserted_id 
    where id = ticket_id;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE create_fines_for_few_tickets(IN percent double, explode int)
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

DELIMITER ;;
CREATE PROCEDURE create_fine_for_a_ticket(IN ticket_id int, explode int)
BEGIN
	set @cost_per_hour = (
		select z.cost_per_hour 
        from eparkingtickets t 
        left join parkinglots p 
        on t.parking_lot_id = p.id
		left join zones z on z.id = p.zone_id
		where t.id = ticket_id
	);
    
    set @number_of_hours = (
		select TIMESTAMPDIFF(MINUTE,start_date, end_date)/60 
        from eparkingtickets 
        where id = ticket_id
	);
    
    # create new fine
    set @random_controller_id = floor(rand() * (select max(id) from controllers));
	insert into fines (total_cost, controller_id) values(
			@cost_per_hour * @number_of_hours * explode, 
            @random_controller_id
	);
	
    # add id of the new fine as a foreign key of eparkingtickets table
    set @new_inserted_id = LAST_INSERT_ID();
    
    # get bill_id of this ticket
    set @bill_id = (
		select bill_id 
        from eparkingtickets 
        where id = ticket_id
	);
    
    update eparkingtickets 
    set fine_id = @new_inserted_id, bill_id = null 
    where id = ticket_id;
    
    # remove bill of this ticket
    delete from bills where id = @bill_id;
END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE create_payments_for_all_bills()
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

DELIMITER ;;
CREATE PROCEDURE create_payments_for_all_fines()
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

DELIMITER ;;
CREATE PROCEDURE create_payment_for_a_bill(IN bill_id int)
BEGIN
	set @payment_date = date_add(
		(
			select t.end_date 
			from bills b 
			join eparkingtickets t 
			on b.id = t.bill_id 
			where b.id = bill_id
        ), 
		interval 5 SECOND
	);
    
    set @payment_reference_number = 1102000000 + bill_id;
    
    # create new payment 
	insert into payments (date, status, payment_reference, bill_id, fine_id) values(
		@payment_date, 'success', @payment_reference_number, bill_id, null
	);
	
END ;;
DELIMITER ;

DELIMITER ;;
CREATE PROCEDURE create_payment_for_a_fine(IN fine_id int)
BEGIN
	set @payment_date = date_add(
		(
			select t.end_date 
            from fines f 
            join eparkingtickets t 
            on f.id = t.fine_id 
            where f.id = fine_id
		), 
		interval 7*24*rand()  HOUR
	);
    
    set @payment_reference_number = 1199000000 + fine_id;
    
    # create new payment 
	insert into payments (date, status, payment_reference, bill_id, fine_id) 
    values(@payment_date, 'success', @payment_reference_number, null, fine_id);
    
END ;;
DELIMITER ;

-- create triggers

delimiter $$
create trigger prevent_wrong_capacity_insert before insert on ParkingLots
for each row
begin
	if (new.occupied_spots > new.capacity) then
		signal sqlstate '45000' set MESSAGE_TEXT = "You can't insert Lot with occupied_spots > capacity";
    end if;
end $$
delimiter ;

delimiter $$
create trigger prevent_bill_and_fine_insert before insert on EParkingTickets
for each row
begin
	if (new.bill_id is not null and new.fine_id is not null) then
		signal sqlstate '45000' set MESSAGE_TEXT = "You can't insert EParkingTicket both with Bill and Fine";
    end if;
end $$
delimiter ;

delimiter $$
create trigger prevent_bill_and_fine_update before update on EParkingTickets
for each row
begin
	if (new.bill_id is not null and new.fine_id is not null) then
		signal sqlstate '45000' set MESSAGE_TEXT = "You can't update EParkingTicket both with Bill and Fine";
    end if;
end $$
delimiter ;

delimiter $$
create trigger prevent_payment_bill_and_fine_insert before insert on Payments
for each row
begin
	if (new.bill_id is not null and new.fine_id is not null) then
		signal sqlstate '45000' set MESSAGE_TEXT = "You can't insert Payment both with Bill and Fine";
    end if;
end $$
delimiter ;

delimiter $$
create trigger prevent_payment_bill_and_fine_update before update on Payments
for each row
begin
	if (new.bill_id is not null and new.fine_id is not null) then
		signal sqlstate '45000' set MESSAGE_TEXT = "You can't update Payment both with Bill and Fine";
    end if;
end $$
delimiter ;

DELIMITER ;;
CREATE TRIGGER validate_insert_data BEFORE INSERT ON eparkingtickets FOR EACH ROW BEGIN
    if (new.end_date < new.start_date) then
		signal sqlstate '45000' set MESSAGE_TEXT = "End_date must be later than start_date.";
	else if (new.end_date is not null and new.status <> 'ENDED' and new.status <> 'PAID') then
		signal sqlstate '45000' set MESSAGE_TEXT = "Ticket must be ended because end_date is given.";
	else if (new.end_date is null and new.status <> 'STARTED') then
		signal sqlstate '45000' set MESSAGE_TEXT = "Ticket must be only started due to end_date not given.";
	end if; 
    end if;
    end if;
END;;


DELIMITER ;;
CREATE TRIGGER validate_update_data BEFORE UPDATE ON eparkingtickets FOR EACH ROW BEGIN
	if (new.end_date < old.start_date) then
		signal sqlstate '45000' set MESSAGE_TEXT = "End_date must be later than start_date.";
    else if (new.start_date <> old.start_date) then
		signal sqlstate '45000' set MESSAGE_TEXT = "Start_date can not be updated.";
	else if (new.vehicle_id <> old.vehicle_id OR new.parking_lot_id <> old.parking_lot_id) then 
		signal sqlstate '45000' set MESSAGE_TEXT = "Vehicle and Parkinglot can not be changed.";
	end if;
    end if;
    end if;
END
;;

DELIMITER ;;
CREATE TRIGGER block_invalid_name_capacity_occupied_spots BEFORE INSERT ON parkinglots FOR EACH ROW BEGIN
	if (new.name = '' OR
		new.capacity <= 0 
        -- OR  (new.occupied_spots <> 0)
	) then
		signal sqlstate '45000' set MESSAGE_TEXT = "Name must not be empty, capacity must be positive, and occupied spots must be zero.";
    end if;
END
;;

DELIMITER ;;
CREATE TRIGGER block_invalid_changes BEFORE UPDATE ON parkinglots FOR EACH ROW BEGIN
	if (trim(new.name) = '' OR
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

-- result: clean state of the database