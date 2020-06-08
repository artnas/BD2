# block from updating a ticket with end_date comes before start_date
insert into eparkingtickets (start_date, status, vehicle_id, parking_lot_id)
values ('2020-05-10 09:15:32', 'STARTED', 23, 17);
set @last_id = LAST_INSERT_ID();
update eparkingtickets set end_date = '2019-09-24 12:34:03' where id = @last_id;