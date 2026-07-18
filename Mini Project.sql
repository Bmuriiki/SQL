--creating schema
create schema sunrise;

--Setting search path
set search_path to sunrise;

--PART 1: CREATING & ALTERING TABLE
create table customers(
		customer_id int primary key,
		full_name varchar(80),
		email varchar(50) unique,
		phone_number varchar(80) unique,
		location varchar(80)
);

create table product(
		product_id int primary key,
		product_name varchar(100),
		category varchar(80),
		unit_price numeric(10,2) not null check(unit_price>0),
		stock int default 0
);

create table orders(
		order_id int primary key,
		customer_id int,
		order_date date,
		status varchar(80) default 'Pending'
);

create table order_item(
		order_item_id int,
		order_id int,
		product_id int,
		quantity int not null check(quantity>0)
);
alter table product
rename stock to stock_quantity;

alter table customers
add column loyalty_points int default 0;

alter table product
alter column product_name
type varchar(150);



--PART 2: INSERTING & CHANGING DATA

insert into customers(
		customer_id,
		full_name,
		email,
		phone_number,
		location
)values
		(1,'Grace Wambui','grace.wambui@gmail.com','0711223344', 'Nairobi'),
		(2,'Kevin Mutiso','kevin.mutiso@gmail.com','0722334455', 'Nakuru'),
		(3,'Faith Chebet','faith.chebet@gmail.com','0733445566', 'Eldoret'),
		(4,'Ibrahim Noor','ibrahim.noor@gmail.com','0744556677', 'Mombasa');



insert into product(
		product_id,
		product_name,
		category,
		unit_price,
		stock
) values
	(1, 'Maize Flour 2kgs', 'Groceries', 180.00, 50),
	(2, 'Cooking Oil 1L', 'Groceries', 320.00, 30),
	(3, 'Bathing Soap', 'Toiletries', 85.00, 100),
	(4, 'Notebook A4', 'Stationary', 60.00, 200);



insert into orders(
		order_id,
		customer_id,
		order_date,
		status
)values
		(1, 1, '2024-03-01', 'Delivered'),
		(2, 2, '2024-03-02', 'Pending'),
		(3, 1, '2024-03-03', 'Delivered'),
		(4, 3, '2024-03-04', 'Cancelled');


insert into order_item(
		order_item_id,
		order_id,
		product_id,
		quantity
)values
		(1,1,1,2),
		(2,1,3,1),
		(3,2,2,1),
		(4,3,4,5);

update orders
set status= 'Delivered'
where order_id= 2;


delete from orders
where order_id=4;

--Filtering & Operators

select *
from product
where unit_price >100;

select *
from customers
where location<> 'Nairobi';

--or
select *
from customers
where location!= 'Nairobi';

select *
from product
where unit_price between 60 and 200;

select *
from customers
where location in ('Nairobi', 'Nakuru', 'Mombasa');


select *
from product
where product_name like '%Oil%';


select *
from orders
where status= 'pending'
order by order_date desc;

select *
from product
order by 4 desc
limit 2;



-- GROUPING & AGGREGATES
select customer_id,
	   count(*)
from orders
group by customer_id;

select customer_id,
	   count(*)
from orders
group by customer_id
having count(*)>1;

--JOINS
--Inner Join
select c.full_name,
	   o.order_id,
	   o.status
from customers c
inner join orders o
on c.customer_id = o.customer_id;

--Left Join
select *
from orders o
left join order_item oi
on o.order_id = oi.order_id;

--Inner join
select oi.order_item_id,
	   p.product_name,
	   p.stock_quantity as quantity
from order_item oi
inner join product p
on oi.product_id =  p.product_id;

--Inner join

select c.full_name,
	   o.order_id,
	   p.product_name,
	   p.stock_quantity as quantity
from orders o
inner join order_item oi
on o.order_id= oi.order_id
inner join product p
on p.product_id= oi.product_id
inner join customers c
on c.customer_id = o.customer_id;

--Join & Group by
select p.product_name,
	   sum(p.stock_quantity) as quantity
from orders o
inner join order_item oi
on o.order_id= oi.order_id
inner join product p
on p.product_id= oi.product_id
inner join customers c
on c.customer_id = o.customer_id
group by product_name;

















































