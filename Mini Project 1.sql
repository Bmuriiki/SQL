--Creating schema
create schema duka;

--Setting default search
set search_path to duka;

--Creating table
create table duka_products(
product_id SERIAL primary key,
product_name VARCHAR(50) not null,
category VARCHAR(30),
price NUMERIC(8,2),
quantity_in_stock INT
);

--Inserting data into the table

insert into duka_products(product_name, category, price, quantity_in_stock)
values ('Unga wa ngano', 'Grains & Cereals', 180.00, 50),
('Mchele Pishori', 'Grains & Cereals', 220.00, 40),
('Sukari', 'Grains & Cereals', 150.00, 60),
('Maziwa Fresh', 'Dairy', 60.00, 30),
('Mtindi', 'Dairy', 90.00, 20),
('Chai ya Majani', 'Beverages', 250.00, 25),
('Soda', 'Beverages', 70.00, 45),
('Sabuni ya kufulia', 'Household', 55.00, 35),
('Mafuta ya Taa', 'Houshold', 120.00, 15),
('Mkate', 'Snacks & Bakery', 65.00, 20);

--Selecting
select *
from duka_products

--Adding a new column
alter table duka_products
add column supplier VARCHAR(100);

--Updating the table
update duka_products
set supplier= 'Kenya Grain Miller'
where category= 'Grains & Cereals';

 --Renaming column 
alter table duka_products
rename column quantity_in_stock to stock_level;

--Changing number of characters
alter table duka_products
alter column product_name 
type VARCHAR(100);

--Dropping column
alter table duka_products
drop column discount_note;

--Deleting data
delete from duka_products
where product_name= 'Mafuta ya Taa';

--Dropping tables
drop table duka_products;








 

