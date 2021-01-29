use sakila;

-- How many copies of the film Hunchback Impossible exist in the inventory system?
select count(inventory_id) from inventory
where film_id in(
	select film_id from film
    where title='Hunchback Impossible');


-- Use subqueries to display all actors who appear in the film Alone Trip.

select
	 actor_id, film_id from film_actor
	where film_id in(
		select film_id from film 
		where title = 'Alone Trip');


select first_name, last_name, email from customer
where address_id in(
select address_id from address
where city_id in(
select city_id from city
where country_id in(
select country_id from country
where country = 'Canada')));
-- List all films whose length is longer than the average of all the films.
select * from film
where length > (select  avg(length) from film)
order by length;

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.

select title from film
where film_id in (
select film_id from film_category
where category_id in(
select category_id from category
where name = 'Family'));

-- Get name and email from customers from Canada using subqueries. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, 
-- that will help you get the relevant information.

select first_name, last_name, email from customer
where address_id in(
select address_id from address
where city_id in(
select city_id from city
where country_id in(
select country_id from country
where country = 'Canada')));

-- Do the same with joins. 

select c.first_name, c.last_name, c.email from customer c
join address a
on c.address_id = a.address_id
join city ci
on a.city_id = ci.city_id
join country co
on ci.country_id = co.country_id
WHERE co.country = 'Canada';  

-- Which are films starred by the most prolific actor? 
-- Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

-- select film_id from film_actor

select title from film
where film_id in (
	select film_id from film_actor
    where actor_id in (SELECT actor_id from(
			select actor_id, count(film_id) AS total from film_actor
			GROUP BY actor_id
            Order by total desc
            LIMIT 1) as sub1 ));



-- Films rented by most profitable customer. 
select title from film
where film_id in(
	select film_id from inventory
	where inventory_id in (
		select inventory_id from rental
		where rental_id in(
			select rental_id from payment
			where customer_id = (
				select customer_id
				from payment
GROUP BY customer_id
ORDER BY sum(amount) DESC
limit 1))));


-- Customers who spent more than the average payments.

-- inner query
select sum(amount) / count(distinct customer_id) avg_total from payment;

select customer_id, sum(amount) from payment
group by customer_id
having sum(amount) > (
select sum(amount) / count(distinct customer_id) avg_total from payment);

-- checking
select customer_id, sum(amount) as total from payment
Group by customer_id;