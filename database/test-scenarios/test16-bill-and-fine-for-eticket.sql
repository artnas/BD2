insert into bills values (88888, 21.14);
insert into fines values(99999, 180.23, 9999);

insert into eparkingtickets values(100000, '2019-05-16 15:07:32','2019-05-16 20:50:27', 'ENDED', 22262, 69, 88888, 99999);
update eparkingtickets set fine_id = 99999 where id = 1;