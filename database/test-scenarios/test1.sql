
# Update ParkingLot with occupied_spots and capacity as negative numbers 
update ParkingLots
set capacity = -1, occupied_spots = -1
where id = 1;
