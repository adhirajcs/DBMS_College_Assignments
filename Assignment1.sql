Create table product (product_id varchar(10) primary key, product_name varchar(20), manufacturer_name
char(20), product_rate number(9,4), sell_price number(9,4),product_description varchar(25));

Create table client (client_id varchar(10) primary key, client_name char(20),address varchar(15), city
char(15),pin number(8), state char(15),bal_due number(9,4));

Create table salesman (salesman_id varchar(10) primary key, salesman_name char(20),address varchar(15), city
char(15),pin number(8), state char(15),salary number(9,4));

Create table sales_order_details (sales_order_no varchar(10) primary key, sales_order_date date, client_id
varchar(10) references client(client_id), salesman_id varchar(10) references salesman(salesman_id) ,
bill_payby_party char(5), delivery_date date, product_rate number(9,4), tot_quantity_order
number(8),cancel_date date default NULL);


insert into product values ('p001','lux_soap','Lux_international','15.67','20.43','soap');
insert into product values ('p002','copy','times_copy_org','14.80','16.40','copy');
insert into product values ('p003','marry_biscuit','marigold_org','2218.80','2220.40','buiskit');
insert into product values ('p004','mitsubisi_pen','pen_international','2015.67','2120.43','pen');
insert into product values ('p005','learn_books','book_world','5104.80','5116.40','book');
insert into product values ('p006','tata_steel','tata_org','5118.80','5120.40','tata');
insert into product values ('p007','seagate hdd','seaget_world','5104.80','5116.40','HDD1034');
insert into product values('p008','dvd writer','frontec_org','5118.80','5120.40','DVDRW');


insert into client values ('cn01001','alak roy',' b.d.para','amarpur','799101','tripura','390.9');
insert into client values ('cn01002','suman roy',' puk para','agartala','799102','tripura','2390.9');
insert into client values ('cn01004','priya das',' chora para','kamalpur','799301','tripura','1390.9');
insert into client values ('cn01005','mita mia',' kamal para','singur','799721','tripura','190.9');
insert into client values ('cn01006','pulak roy',' bircity','sonitpur','799141','assam','110.9');
insert into client values ('cn01007','munni das',' nappam','sonitpur','799152','assam','190.9');
insert into client values ('cn01008','kusum roy',' city_dos','tezpur','799141','assam','110.9');
insert into client values ('cn01009','mina das',' pachmile','tezpur','799152','assam','190.9');
insert into client values ('cn01003','moytree nayak',' pachmile','tezpur','799152','assam','9990.9');
insert into client values ('cn01010','pauri mia',' pachmile','tezpur','799152','assam','2990.9');
insert into client values ('cn01011','manali das',' satmile','tezpur','799154','assam','3990.9');


insert into salesman values ('s001','Rohan das','nappam','Tezpur','79970','Assam','8000');
insert into salesman values ('s002','Rohan das','nappam','Tezpur','799170','Assam','8000');
insert into salesman values ('s003','Smita das','nirjuli','itanagar','799701','Arunachal','9000');
insert into salesman values ('s004','Kabir bora','nappam','Tezpur','799703','Assam','8500');
insert into salesman values ('s005','Neha singh','borbota ','sonitpur','795970','assam','9600');
insert into salesman values ('s006','Priya agarwal','gandhi road ','32 distric','799750','delhi','9900');
insert into salesman values ('s007','Ashok Paul','filmcity','munnabari ','799740','mumbai','8900');



insert into sales_order_details values ('on01001','01-aug-2008','cn01001','s001','yes','20-aug-2008', '2220.40','50','');
insert into sales_order_details values ('on01002','12-aug-2008','cn01004','s001', 'yes','23-aug-2008', '2220.40','15'.'');
insert into sales_order_details values ('on01003','12-aug-2008','cn01005','s003', 'yes','26-aug-2008', '2220.40','10','');
insert into sales_order_details values ('on01004','13-aug-2008','cn01004','s001', 'yes','20-aug-2008', '2220.40','15','');
insert into sales_order_details values ('on01005','14-aug-2008','cn01002','s002', 'no','30-aug-2008', '2220.40','52', '28-march-2008');
insert into sales_order_details values ('on01006','15-aug-2008','cn01001','s001', 'yes','31-aug-2008','2220.40','53','');
insert into sales_order_details values ('on01007','16-jan-2008','cn01003','s004', 'yes','28-aug-2008', '2220.40','54','');
insert into sales_order_details values ('on01008','01-feb-2008','cn01004','s003', 'no','28-aug-2008', '8220.40','54', '18-march-2008');


-- (a) Retrieve the list of names and the cities of all the clients.
select client_name,city from client

-- (b) List the various products available.
select product_name from product

-- (c) Find the names of all clients having ‘a’ as the second letter in their names.
select client_name from client where client_name like '_a%'

-- (d) List all the clients who are located in TEZPUR.
select client_name from client where city='tezpur'

-- (e) Find the products whose selling price is greater than 2000 and less than or equal to 5000
select product_name from product where sell_price>2000 and sell_price<=5000

-- (f) Add a new column NEW_PRICE into the product_master table.
alter table product add (NEW_PRICE varchar(20))

-- (g) Rename the column product_rate of Sales_Order_Details to new_product_rate.
desc product
alter table product rename column product_rate to new_product_rate
desc product

-- (h) List the products in sorted order of their description.
select * from product order by PRODUCT_DESCRIPTION ASC

-- (i) Display the order number and date on which the clients placed their order.
select SALES_ORDER_NO,SALES_ORDER_DATE from sales_order_details

-- (j) Delete all the records having delivery date before 25th August, 2008.
delete from sales_order_details where delivery_date<'25-aug-2008';

-- (k) Change the delivery date of order number ON01008 to 16-08-08
update sales_order_details set sales_order_date='16-08-08' where sales_order_no='on01008'

-- (l) Change the bal_due of client_no CN01003 to 1200
update client set bal_due='1200' where client_id='cn01003'

-- (m)Find the product with description as ‘HDD1034’ and ‘DVDRW’
select product_name from product where product_description='HDD1034' or product_description='DVDRW'

-- (n) List the names, city and state of the clients not in the state of ‘ASSAM’
select client_name,city,state from client where state<>'assam'

-- (o) List of all orders that were canceled in the of March.
select sales_order_no from sales_order_details where cancel_date like '%-03-%'




