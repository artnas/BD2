
select * from ParkingLots where id = 1;

update ParkingLots
set capacity = -1, occupied_spots = -1
where id = 1;