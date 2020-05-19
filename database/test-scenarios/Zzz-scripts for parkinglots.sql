
#### Parkinglots ###
### INSERT
# insert parking lot with empty name
insert into parkinglots (name, capacity, address_id, zone_id) 
values ('', 50, 1, 1);

# insert parking lot with none-positive capacity
insert into parkinglots (name, capacity, address_id, zone_id) 
values ('PAKLOT-9999', 0, 1, 1);

# insert parking lot with occupied spots greater than 0
insert into parkinglots (name, capacity, occupied_spots, address_id, zone_id) 
values ('PAKLOT-9999', 50, 25, 1, 1);

### UPDATE
# update empty name 
update parkinglots set name = '' where id = 1;

# update none-positive capacity
update parkinglots set capacity = 0 where id = 1;

# attempt changing address or zone of parking lot
update parkinglots set address_id = 5 where id = 1;
update parkinglots set zone_id = 5 where id = 1;

## attempt changing capacity AND/OR occupied_spots 
## where it will result to have capacity < occupied_spots
# new capacity less than current occupied_spots
update parkinglots set capacity = 2 where id = 1; 
# new capacity less than new occupied_spots
update parkinglots set capacity = 2, occupied_spots = 4 where id = 1; 
# old capacity less than new occupied_spots
update parkinglots set occupied_spots = 200 where id = 1;

