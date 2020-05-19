# block from inserting a ticket with end_date <> null and status <> 'ENDED'
insert into eparkingtickets (start_date, end_date, status, vehicle_id, parking_lot_id)
values ('2020-05-10 09:15:32', '2020-05-10 11:15:32', 'STARTED', 23, 17);