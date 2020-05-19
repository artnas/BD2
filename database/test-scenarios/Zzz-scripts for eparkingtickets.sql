
#### EParkingTickets ###

### INSERT

# block from inserting a ticket with end_date comes before start_date
insert into eparkingtickets (start_date, end_date, status, vehicle_id, parking_lot_id)
values ('2020-05-10 09:15:32', '2020-05-10 06:15:32', 'ENDED', 23, 17);

# block from inserting a ticket with end_date <> null and status <> 'ENDED'
insert into eparkingtickets (start_date, end_date, status, vehicle_id, parking_lot_id)
values ('2020-05-10 09:15:32', '2020-05-10 11:15:32', 'STARTED', 23, 17);

# block from inserting a ticket with end_date is null and status <> 'STARTED'
insert into eparkingtickets (start_date, status, vehicle_id, parking_lot_id)
values ('2020-05-10 09:15:32', 'ENDED', 23, 17);

### UPDATE

# block from updating start_date of a ticket
update eparkingtickets set start_date = '2020-09-24 12:34:03' where id = 15;

# block from updating a ticket with end_date comes before start_date
insert into eparkingtickets (start_date, status, vehicle_id, parking_lot_id)
values ('2020-05-10 09:15:32', 'STARTED', 23, 17);
set @last_id = LAST_INSERT_ID();
update eparkingtickets set end_date = '2019-09-24 12:34:03' where id = @last_id;

# block from changing vehile and/or parking_lot
update eparkingtickets set vehicle_id = 89, parking_lot_id = 23 where id = 15;













