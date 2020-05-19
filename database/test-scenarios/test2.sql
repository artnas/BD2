insert into ParkingLots(name, capacity, occupied_spots, address_id, zone_id)
values ('new Lot', 1, 123456, 35, 28);

select * from ParkingLots where name = 'new Lot';