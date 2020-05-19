# block from inserting a ticket with end_date comes before start_date
insert into eparkingtickets (start_date, end_date, status, vehicle_id, parking_lot_id)
values ('2020-05-10 09:15:32', '2020-05-10 06:15:32', 'ENDED', 23, 17);