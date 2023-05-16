create database CGV 
--region
create table region (
  region_id char(5) not null,
  region_name nvarchar(25),
  constraint region_pk primary key (region_id)
) 
--coupon
create table coupon (
  coupon_id varchar(10) not null,
  coupon_name nvarchar(200),
  discount float not null,
  maximumuses int not null,
  code varchar(10) not null constraint coupon_pk primary key(coupon_id)
) 
--18 payments
create table payments (
  payment_id varchar(50) not null,
  payment_method nvarchar(50) not null,
  description nvarchar(256) constraint payment_pk primary key(payment_id)
) 
--23 film
create table film (
  film_id varchar(50) not null,
  film_name nvarchar(50) not null,
  allowed_age int,
  film_type nvarchar(50) not null constraint film_pk primary key (film_id)
) 
--21 price
create table price (
  price_id varchar(50) not null,
  price float not null,
  description nvarchar(256),
  constraint price_pk primary key (price_id)
) 
--2 agency
create table agency (
  agency_id varchar(20),
  region_id char(5),
  address nvarchar(200),
  constraint agency_pk primary key (agency_id),
  constraint agency_fk foreign key (region_id) references region(region_id)
) 
--4 employee
create table employee (
  employee_id varchar(20) not null,
  em_lastname nvarchar(50),
  em_firstname varchar(50),
  em_phonenumber int,
  management_id varchar(20),
  agency_id varchar(20) constraint employees_pk primary key (employee_id),
  constraint employees_fk foreign key (agency_id) references agency(agency_id)
) 
--15 room
create table room (
  room_id varchar(5) not null,
  employee_id varchar(20) not null,
  room_name nvarchar(50),
  no_seat char(1) constraint room_pk primary key (room_id) constraint room_fk foreign key (employee_id) references employee(employee_id)
) 
--3 team
create table team (
  team_name nvarchar(200),
  room_id varchar(5) not null,
  employee_id varchar(20) not null,
  constraint team_pk primary key(room_id, employee_id),
  constraint team_fk1 foreign key (employee_id) references employee(employee_id),
  constraint team_fk2 foreign key (room_id) references room(room_id)
) 
--6 membership
create table membership (
  membership_id varchar(50) not null,
  membership_lastname nvarchar(50),
  constraint membership_pk primary key (membership_id)
) 
--5 customer
create table customer (
  customer_id varchar(50) not null,
  cus_lastname nvarchar(50),
  cus_firstname nvarchar(50),
  cus_phonenumber int,
  student char(1),
  membership_id varchar(50) not null,
  constraint customer_pk primary key (customer_id),
  constraint customer_fk foreign key (membership_id) references membership(membership_id)
) 
--7 nonmembership
create table nonmembership (
  customer_id varchar(50) not null foreign key references customer(customer_id),
  nonmembership_lastname nvarchar(50),
  primary key(customer_id)
) 
--17 invoice
create table invoice (
  employee_id varchar(20) not null,
  invoice_id varchar(200) not null,
  invoice_detail nvarchar(50),
  invoice_day date,
  payment_id varchar(50) not null,
  constraint invoice_pk primary key (invoice_id),
  constraint invoice_fk1 foreign key (employee_id) references employee(employee_id),
  constraint invoice_fk2 foreign key (payment_id) references payments(payment_id),
) 
--10 order
create table order_ (
  order_id varchar(50) not null,
  customer_id varchar(50),
  coupon_id varchar(10),
  invoice_id varchar(200) not null,
  constraint order_pk primary key (order_id),
  constraint order_fk1 foreign key (customer_id) references customer(customer_id),
  constraint order_fk2 foreign key (coupon_id) references coupon(coupon_id),
  constraint order_fk3 foreign key (invoice_id) references invoice(invoice_id)
) 
--19 combo
create table combo (
  combo_id varchar(50) not null,
  name nvarchar(50),
  price_id varchar(50) not null,
  constraint combo_pk primary key (combo_id),
  constraint combo_fk foreign key (price_id) references price(price_id)
) 
--11 menu order combo
create table moc (
  note nvarchar(256),
  order_id varchar(50) not null,
  combo_id varchar(50) not null,
  constraint moc_pk primary key(order_id, combo_id),
  constraint moc_fk1 foreign key (order_id) references order_(order_id),
  constraint moc_fk2 foreign key (combo_id) references combo(combo_id)
) 
--20 food & drink
create table fooddrink (
  fooddrink_id varchar(50) not null,
  name nvarchar(50),
  size nvarchar(50),
  price_id varchar(50) not null,
  constraint fooddrink_pk primary key (fooddrink_id),
  constraint fooddrink_fk foreign key (price_id) references price(price_id)
) 
--12 menu food drink
create table mfd (
  note nvarchar(256),
  fooddrink_id varchar(50) not null,
  combo_id varchar(50) not null,
  constraint mfd_pk primary key(fooddrink_id, combo_id),
  constraint mfd_fk1 foreign key (fooddrink_id) references fooddrink(fooddrink_id),
  constraint mfd_fk2 foreign key (combo_id) references combo(combo_id)
) 
--13 menu order food drink
create table mofd (
  note nvarchar(256),
  fooddrink_id varchar(50) not null,
  order_id varchar(50) not null,
  constraint mofd_pk primary key(fooddrink_id, order_id),
  constraint mofd_fk1 foreign key (fooddrink_id) references fooddrink(fooddrink_id),
  constraint mofd_fk2 foreign key (order_id) references order_(order_id)
) 
--14 ticket type
create table tickettype (
  tickettype_id varchar(50) not null,
  price_id varchar(50) not null,
  tickettype_name nvarchar(50) not null,
  constraint tickettype_pk primary key (tickettype_id),
  constraint tickettype_fk foreign key (price_id) references price(price_id)
) 
--16 seat
create table seat (
  room_id varchar(5) not null,
  seat_id varchar(10) not null,
  name nvarchar(50) constraint seat_pk primary key (seat_id),
  constraint seat_fk foreign key (room_id) references room(room_id)
) 
--22 ticket
create table ticket (
  ticket_id varchar(50) not null,
  film_id varchar(50) not null,
  invoice_id varchar(200) not null,
  coupon_id varchar(10),
  tickettype_id varchar(50) not null,
  seat_id varchar(10) not null,
  constraint ticket_pk primary key (ticket_id),
  constraint ticket_fk1 foreign key (film_id) references film(film_id),
  constraint ticket_fk2 foreign key (invoice_id) references invoice(invoice_id),
  constraint ticket_fk3 foreign key (coupon_id) references coupon(coupon_id),
  constraint ticket_fk4 foreign key (tickettype_id) references tickettype(tickettype_id)
)

--insert data--------------------------------
--1 region
INSERT INTO Region VALUES ('1', 'Bac');
INSERT INTO Region VALUES ('2', 'Trung');
INSERT INTO Region VALUES ('3', 'Nam');
INSERT INTO Region VALUES ('4', 'Tay');

--9 COUPON
INSERT INTO COUPON
VALUES
('CI001','Bronze1',0.01,'1','CCI1'),
('CI002','Bronze2',0.02,'1','CCI2'),
('CI003','Bronze3',0.03,'2','CCI3'),
('CI004','Silver1',0.04,'1','CCI4'),
('CI005','Silver2',0.05,'1','CCI5'),
('CI006','Silver3',0.06,'1','CCI6'),
('CI007','Gold1',0.07,'2','CCI7'),
('CI008','Gold2',0.08,'1','CCI8'),
('CI009','Gold3',0.09,'1','CCI9'),
('CI010','Diamond',0.1,'1','CCI10');

--18 Payments  
insert into PAYMENTS
values
('PI01', 'BANK', 'CASH TRANSFERS'),
('PI02', 'PAY', 'CASH PAYMENT')

--23 film
INSERT INTO FILM
VALUES
('FLI01',	'Doctor Strange 2',	13,	'Science fiction'),
('FLI02',	'Ironman 1',	10,	'Science fiction'),
('FLI03',	'Ironman 2',	13,	'Science fiction'),
('FLI04',	'Ironman 3',	13,	'Science fiction'),
('FLI05',	'Avenger infinity war',	16,	'Science fiction'),
('FLI06',	'Avenger end game',	12,	'Science fiction'),
('FLI07',	'Spider-man far from home',	12,	'Science fiction'),
('FLI08',	'Spider-man no way home',	13,	'Science fiction'),
('FLI09',	'Bố Gìa',	18,	'Comedy genre'),
('FLI010', 'Chị 13',	18,	'Comedy genre')

--21 Price
INSERT INTO PRICE(PRICE_ID,PRICE)
VALUES
('PC01', 10),
('PC02' ,20),
('PC03' ,23),
('PC04', 4),
('PC05' ,23),
('PC06' ,45),
('PC07', 26),
('PC08', 1),
('PC09', 42),
('PC10', 11)

--2 Agency 
INSERT INTO Agency VALUES ('AC01', '1', 'Cao Bang');
INSERT INTO Agency VALUES ('AC02', '1', 'Lang Son');
INSERT INTO Agency VALUES ('AC03', '1', 'Hai Duong');
INSERT INTO Agency VALUES ('AC04', '3', 'TP HCM');
INSERT INTO Agency VALUES ('AC05', '3', 'Dong Nai');
INSERT INTO Agency VALUES ('AC06', '3', 'Binh Duong');
INSERT INTO Agency VALUES ('AC07', '4', 'Ben Tre');
INSERT INTO Agency VALUES ('AC08', '2', 'Binh Dinh');
INSERT INTO Agency VALUES ('AC09', '3', 'Binh Phuoc');
INSERT INTO Agency VALUES ('AC010', '1', 'Bac Ninh');

--4 Employee
INSERT INTO Employee VALUES ('E001', 'Hoang', 'Nguyen', 101010, 'MI001', 'AC01');
INSERT INTO Employee VALUES ('E002', 'Sang', 'Man', 101012, 'MI002', 'AC02');
INSERT INTO Employee VALUES ('E003', 'Hoai', 'Tran', 1010103, 'MI003', 'AC03');
INSERT INTO Employee VALUES ('E004', 'Thanh', 'Ha', 101014,	'MI004', 'AC04' );
INSERT INTO Employee VALUES ('E005', 'Ngan', 'Ngo',101015, 'MI005' ,'AC05' );
INSERT INTO Employee VALUES ('E006', 'Truc', 'Thai', 101016, 	'MI006', 'AC06');
INSERT INTO Employee VALUES ('E007', 'Nguyen', 'Tran', 10107, 'MI007', 'AC07');
INSERT INTO Employee VALUES ('E008', 'A', 'Nguyen', 10108, 'MI008', 'AC08');
INSERT INTO Employee VALUES ('E009', 'B', 'Nguyen', 10109, 'MI009', 'AC09');
INSERT INTO Employee VALUES ('E010', 'C', 'Nguyen', 1010101	,'MI010', 'AC010');

--15  ROOM
INSERT INTO ROOM(ROOM_ID, EMPLOYEE_ID, ROOM_NAME) VALUES('R1',	'E002',	'Phòng 1');
INSERT INTO ROOM(ROOM_ID, EMPLOYEE_ID, ROOM_NAME) VALUES('R2',	'E004',		'Phòng 2');
INSERT INTO ROOM(ROOM_ID, EMPLOYEE_ID, ROOM_NAME) VALUES('R3',	'E005',		'Phòng 3');
INSERT INTO ROOM(ROOM_ID, EMPLOYEE_ID, ROOM_NAME) VALUES('R4',	'E003',		'Phòng 4');
INSERT INTO ROOM(ROOM_ID, EMPLOYEE_ID, ROOM_NAME) VALUES('R5',	'E001',		'Phòng 5');
INSERT INTO ROOM(ROOM_ID, EMPLOYEE_ID, ROOM_NAME) VALUES('R6',	'E007',		'Phòng 6');
INSERT INTO ROOM(ROOM_ID, EMPLOYEE_ID, ROOM_NAME) VALUES('R7',	'E006',		'Phòng 7');
INSERT INTO ROOM(ROOM_ID, EMPLOYEE_ID, ROOM_NAME) VALUES('R8',	'E008',		'Phòng 8');
INSERT INTO ROOM(ROOM_ID, EMPLOYEE_ID, ROOM_NAME) VALUES('R9',	'E010',	'Phòng 9');
INSERT INTO ROOM(ROOM_ID, EMPLOYEE_ID, ROOM_NAME) VALUES('R10',	'E009',	'Phòng 10');

--3 Team
INSERT INTO Team VALUES ('Team 1', 'R1', 'E002');
INSERT INTO Team VALUES ('Team 2', 'R2', 'E004');
INSERT INTO Team VALUES ('Team 3', 'R3', 'E005');
INSERT INTO Team VALUES ('Team 4', 'R4', 'E003');
INSERT INTO Team VALUES ('Team 5', 'R5', 'E001');
INSERT INTO Team VALUES ('Team 6', 'R6', 'E007');
INSERT INTO Team VALUES ('Team 7', 'R7', 'E006');
INSERT INTO Team VALUES ('Team 8', 'R8', 'E008');
INSERT INTO Team VALUES ('Team 9', 'R9', 'E010');
INSERT INTO Team VALUES ('Team 10', 'R10', 'E009');

--6 MEMBERSHIP
INSERT INTO MEMBERSHIP
VALUES
	('MEM01','C'),
	('MEM02','A'),
	('MEM03','U'),
	('MEM04','P'),
	('MEM05','Q');

--5.Bảng Customer
INSERT INTO Customer VALUES ('CUS01', 'C', 'Nguyen', 10101, 'X', 'MEM01');
INSERT INTO Customer VALUES ('CUS02', 'S', 'Man', 101231, 'X', 'MEM03');
INSERT INTO Customer VALUES ('CUS03', 'A', 'Tran', 141424, 'X', 'MEM02');	
INSERT INTO Customer VALUES ('CUS04', 'E', 'Ha', 213123, 'X','MEM03');	
INSERT INTO Customer VALUES ('CUS05','Y', 'Ngo', 144343,' ','MEM05');
INSERT INTO Customer VALUES ('CUS06', 'U', 'Thai', 1231235,'X', 'MEM03');
INSERT INTO Customer VALUES ('CUS07', 'V', 'Tran', 132123,' ','MEM03');	
INSERT INTO Customer VALUES ('CUS08', 'P', 'Nguyen', 1312415, 'X', 'MEM04');
INSERT INTO Customer VALUES ('CUS09', 'Q', 'Nguyen', 4567551, '', 'MEM05');
INSERT INTO Customer VALUES ('CUS10', 'M', 'Nguyen', 144441,'','MEM04');

--7 nonmembership
INSERT INTO NONMEMBERSHIP
VALUES
('CUS02', 'S'),
('CUS04', 'E'),
('CUS05', 'Y'),
('CUS07', 'V'),
('CUS10', 'M')

--17 Invoice    
insert into Invoice 
values
('E001', 'IV01', 'Doctor Strange 2',   convert(datetime,'18-06-12 10:34:09 PM',5), 'PI01'),
('E002', 'IV02', 'Ironman 1',                convert(datetime,'18-06-12 10:34:09 PM',5),  'PI01'),
('E003', 'IV03', 'Bố Gìa',                  convert(datetime,'18-06-12 10:34:09 PM',5),  'PI02'),
('E004', 'IV04', 'Ironman 3',               convert(datetime,'18-06-12 10:34:09 PM',5),  'PI02'),
('E005', 'IV05', 'Avenger infinity war',    convert(datetime,'18-06-12 10:34:09 PM',5),  'PI01'),
('E001', 'IV06', 'Avenger end game',         convert(datetime,'18-06-12 10:34:09 PM',5),  'PI01'),
('E002', 'IV07', 'Spider-man far from home', convert(datetime,'18-06-12 10:34:09 PM',5),  'PI02'),
('E003', 'IV08', 'Spider-man no way home',   convert(datetime,'18-06-12 10:34:09 PM',5),  'PI01'),
('E004', 'IV09', 'Ironman2',                convert(datetime,'18-06-12 10:34:09 PM',5),  'PI01'),
('E005', 'IV10', 'Chị 13',                  convert(datetime,'18-06-12 10:34:09 PM',5),  'PI02')

--10 ORDER
INSERT INTO ORDER_ VALUES ('OR01',	'CUS03',	'CI009',	'IV01');
INSERT INTO ORDER_ VALUES ('OR02',	'CUS02',	'CI002',	'IV02');
INSERT INTO ORDER_ VALUES ('OR03',	'CUS01',	'CI008',	'IV03');
INSERT INTO ORDER_ VALUES ('OR04',	'CUS08',	'CI004',	'IV07');
INSERT INTO ORDER_ VALUES ('OR05',	'CUS05',	'CI005',	'IV05'); 
INSERT INTO ORDER_ VALUES ('OR06'	,	'CUS06',	'CI006',	'IV01');
INSERT INTO ORDER_ VALUES('OR07',	'CUS10',	'CI007',	'IV09');
INSERT INTO ORDER_ VALUES ('OR08',	'CUS04',	'CI003',	'IV03');
INSERT INTO ORDER_ VALUES ('OR09',	'CUS09',	'CI001',	'IV08');
INSERT INTO ORDER_ VALUES ('OR10',	'CUS07',	'CI004',	'IV05');

--19 Combo  
insert into Combo
values  
('1', 'Ve + Nuoc',          'PC01'),
('2', 'Ve + Nuoc + Bap',      'PC03'),
('3', 'Ve + Nuoc + Trai cay', 'PC07'),
('4', 'Ve + Nuoc + My',       'PC09')

--11 MOC
INSERT INTO MOC(ORDER_ID, COMBO_ID)
VALUES('OR01',	1),	
	('OR02',	2),	
	('OR03',	4),	
	('OR04',	2),
	('OR05',	4),	
	('OR06',	3),
	('OR07',	1),
	('OR08',	3),	
	('OR09',	2),	
	('OR10',	1)

--20 Food & Drink  
insert into FOODDRINK
values      
('FDI01', '7 UP',       'Min',  'PC04'),
('FDI02', 'Pessi',      'Max',  'PC04'),
('FDI03', 'Cocacola',   'Min',  'PC04'),
('FDI04', 'Bắp',        'Min',  'PC01'),
('FDI05', 'Mỳ',         'Min',  'PC02')

--12 MFD
INSERT INTO MFD(COMBO_ID,FOODDRINK_ID) VALUES(1,	'FDI05');
INSERT INTO MFD(COMBO_ID,FOODDRINK_ID) VALUES (2,	'FDI04');
INSERT INTO MFD(COMBO_ID,FOODDRINK_ID) VALUES(3,	'FDI03');
INSERT INTO MFD(COMBO_ID,FOODDRINK_ID) VALUES(4,	'FDI01');
INSERT INTO MFD(COMBO_ID,FOODDRINK_ID) VALUES(1,	'FDI02');
INSERT INTO MFD(COMBO_ID,FOODDRINK_ID) VALUES(3,	'FDI02');
INSERT INTO MFD(COMBO_ID,FOODDRINK_ID) VALUES(4,	'FDI03');
INSERT INTO MFD(COMBO_ID,FOODDRINK_ID) VALUES(2,	'FDI01');
INSERT INTO MFD(COMBO_ID,FOODDRINK_ID) VALUES(3,	'FDI05');
INSERT INTO MFD(COMBO_ID,FOODDRINK_ID) VALUES(4,	'FDI04');

--13 MOFD
INSERT INTO MOFD(ORDER_ID, FOODDRINK_ID)
VALUES('OR05',	'FDI05'),
('OR07',	'FDI04'),
('OR03',	'FDI03'),
('OR10',	'FDI01'),
('OR01',	'FDI02'),
('OR06',	'FDI02'),
('OR02',	'FDI03'),
('OR08',	'FDI01'),
('OR09',	'FDI05'),
('OR09',	'FDI04')

--14 TICKETTYPE
INSERT INTO TICKETTYPE(TICKETTYPE_ID, PRICE_ID, TICKETTYPE_NAME)
VALUES('TK01',	'PC05',	'Ve don'),
('TK02',	'PC07',	'Combo ve nuoc'),
('TK03',	'PC09',	'Combo ve nuoc do an')

--16 Seat
insert into SEAT values('R1', 'A2', 'SINGLE');
insert into SEAT values('R2', 'A1', 'SINGLE');
insert into SEAT values('R3', 'A3', 'COUPLE');
insert into SEAT values('R4', 'A4', 'COUPLE');
insert into SEAT values('R6', 'A5', 'SINGLE');
insert into SEAT values('R5', 'B1', 'SINGLE');
insert into SEAT values('R7', 'B2', 'COUPLE');
insert into SEAT values('R9', 'B3', 'COUPLE');
insert into SEAT values('R8', 'B4', 'COUPLE');
insert into SEAT values('R10', 'B5', 'COUPLE');

--22 Ticket
INSERT INTO TICKET VALUES ('T01', 'FLI01', 'IV01', 'CI003', 'TK01', 'A1');
INSERT INTO TICKET VALUES ('T02', 'FLI02', 'IV02', 'CI003','TK03', 'A2');
INSERT INTO TICKET VALUES ('T03', 'FLI03', 'IV03','CI003','TK02', 'A3');
INSERT INTO TICKET VALUES('T04', 'FLI04', 'IV04', 'CI001', 'TK02', 'A4');
INSERT INTO TICKET VALUES('T05', 'FLI05', 'IV05', 'CI002', 'TK01', 'A5');
INSERT INTO TICKET VALUES('T06', 'FLI06', 'IV06', 'CI003', 'TK03', 'B1');
INSERT INTO TICKET VALUES('T07', 'FLI07', 'IV07','CI003 ', 'TK02', 'B2');
INSERT INTO TICKET VALUES('T08', 'FLI08', 'IV08', 'CI003','TK02', 'B3');
INSERT INTO TICKET VALUES('T09', 'FLI09', 'IV09', 'CI003','TK03', 'B4');
INSERT INTO TICKET VALUES('T10', 'FLI010', 'IV10', 'CI003', 'TK02', 'B5');
