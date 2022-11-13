use sakila;

#1.Drop column picture from staff.
alter table staff
drop column picture;
select * from staff;


#2.A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.
select address_id into @address_id from address
where address = '1913 Hanoi Way';
select @address_id;

select store_id into @store_id from store
where manager_staff_id = 2;
select @store_id;


select max(staff_id)+1 into @staff_id from staff;
select @staff_id;

insert into staff
values (@staff_id,'TAMMY','SANDERS',@address_id,'TAMMY.SANDERS@sakilastaff.com',@store_id,1,'TAMMY',NULL,now());
select * from staff;


#3.Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. You can use current date for the rental_date column in the rental table.
select customer_id into @customer_id from customer
where first_name = 'CHARLOTTE' and last_name = 'HUNTER';
select @customer_id;

select film_id into @film_id from film
where title = 'ACADEMY DINOSAUR';
select @film_id;

select inventory_id into @inventory_id from inventory
where film_id = @film_id and store_id =1 limit 1;
select @inventory_id;

select staff_id into @staff_id from staff
where first_name = 'Mike';
select @staff_id;

select max(rental_id)+1 into @rental_id from rental;
select @rental_id;

insert into rental
values (@rental_id,now(),@inventory_id,@customer_id,'2005-05-26 22:04:30',@staff_id,'2006-02-15 21:30:53');

select * from rental
where rental_id = @rental_id;


#4.Delete non-active users, but first, create a backup table deleted_users to store customer_id, email, and the date for the users that would be deleted. Follow these steps:
#Check if there are any non-active users
#Create a table backup table as suggested
#Insert the non active users in the table backup table
#Delete the non active users from the table customer
select * from customer
where active = 0;

SHOW CREATE table customer;

CREATE TABLE if not exists `deleted_users` (
  `customer_id` smallint unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(50) DEFAULT NULL,
  `delete_date` datetime NOT NULL,
  PRIMARY KEY (`customer_id`)
);

insert into deleted_users
select customer_id, email, now() as delete_date from customer;

SET sql_safe_updates=0;

delete from payment
where customer_id in (select customer_id from customer where active = 0);

delete from rental
where customer_id in (select customer_id from customer where active = 0);

delete from customer
where active = 0;

select * from deleted_users;