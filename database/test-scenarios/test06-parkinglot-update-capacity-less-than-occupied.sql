
## attempt changing capacity AND/OR occupied_spots 
## where it will result to have capacity < occupied_spots
# new capacity less than current occupied_spots
update parkinglots set capacity = 2 where id = 1; 
# new capacity less than new occupied_spots
update parkinglots set capacity = 2, occupied_spots = 4 where id = 1; 
# old capacity less than new occupied_spots
update parkinglots set occupied_spots = 200 where id = 1;