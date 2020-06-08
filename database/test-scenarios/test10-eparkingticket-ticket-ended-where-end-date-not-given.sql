# block from inserting a ticket with end_date is null and status <> 'STARTED'
insert into eparkingtickets (start_date, status, vehicle_id, parking_lot_id)
values ('2020-05-10 09:15:32', 'ENDED', 23, 17);