

/* THIS IS TO SUPPORT FOR PRESENTATION SCENARIOS*/

/* get all vehicles parked at given parkinglot */
select distinct v.license_plate from vehicles v inner join eparkingtickets t on v.id = t.vehicle_id 
                         inner join parkinglots p on p.id = t.parking_lot_id where p.name = 'PAKLOT-52626'; /* OR p.name = 'PAKLOT-23423'*/


/* check queries for backend functions*/
SELECT parkinglots.name, count(eparkingtickets.id) FROM eparkingtickets INNER JOIN parkinglots ON parkinglots.id=eparkingtickets.parking_lot_id INNER JOIN vehicles ON vehicles.id=eparkingtickets.vehicle_id INNER JOIN payments ON payments.bill_id=eparkingtickets.bill_id OR payments.fine_id=eparkingtickets.fine_id WHERE parkinglots.id = 2 AND ((eparkingtickets.start_date BETWEEN '2018-03-01 00:00:00' AND '2020-06-18 23:00:48') AND (eparkingtickets.end_date BETWEEN '2018-03-01 00:00:00' AND '2020-06-18 23:00:48')) AND vehicles.license_plate = 'byl3995' AND payments.status = 'SUCCESS';

SELECT parkinglots.name, count(eparkingtickets.id) FROM eparkingtickets INNER JOIN parkinglots ON parkinglots.id=eparkingtickets.parking_lot_id INNER JOIN vehicles ON vehicles.id=eparkingtickets.vehicle_id INNER JOIN payments ON payments.bill_id=eparkingtickets.bill_id OR payments.fine_id=eparkingtickets.fine_id WHERE parkinglots.id = 56 AND ((eparkingtickets.start_date BETWEEN '2019-10-08 00:00:00' AND '2019-11-29 00:00:00') AND (eparkingtickets.end_date BETWEEN '2019-10-08 00:00:00' AND '2019-11-29 00:00:00')) AND payments.status = 'FAILURE'

select distinct v.license_plate from vehicles v inner join eparkingtickets t on v.id = t.vehicle_id inner join parkinglots p on p.id = t.parking_lot_id where p.name = 'PAKLOT-52626'