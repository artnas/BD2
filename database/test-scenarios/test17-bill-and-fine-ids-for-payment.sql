insert into bills values (88888, 21.14);
insert into fines values (99999, 180.23, 9999);

INSERT INTO payments VALUES (100000, '2019-02-21 13:16:22', 'success', 1102000001, 88888, 99999);
update payments set fine_id = 99999 where id = 142;