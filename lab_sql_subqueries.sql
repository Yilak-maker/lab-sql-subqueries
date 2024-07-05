-- 1. how many copies of the film Hunchback Impossible exist in the inventory system?
use sakila;
select count(*) as number_of_copies
from inventory 
where film_id = ( select film_id 
                from film
                where title = 'Hunchback Impossible');
-- 2) List all films whose length is longer than the average of all the films.
select title, length
from film
where length > (select avg(length) 
               from film )
               order by length desc;

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.

Select a.first_name, a.last_name
from actor a
join film_actor fa on a.actor_id = fa.actor_id
join film f on fa.film_id = f.film_id
where f.title = "Alone Trip";

-- 4 Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
Select f.title
from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
where c.name = "family" ;

-- 5 Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select c.first_name, c.last_name, c.email
from customer c
join address a on c.address_id = a.address_id
join city ct on a.city_id = ct.city_id
join country cy on ct.country_id = cy.country_id
where cy.country = "Canada" ;

select first_name, last_name, email 
from customer
where address_id in (select address_id 
   from city 
   where city_id in (select country_id 
             from country 
             where country = "Canada"));
             
             
-- 6 Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
Select count(fa.film_id) as number_of_films, actor_id
from film_actor fa
group by actor_id
order by number_of_films desc
limit 1;

Select count(fa.film_id) as number_of_films, fa.actor_id
from film_actor fa
where fa.film_id in ( select title 
                     from film f
					 where f.film_id = fa.film_id
                     group by fa.actor_id 
                     order by film_id);
                     
				-- or -
                
select f.title
from film f
join film_actor fa on f.film_id = fa.film_id
where fa.actor_id = (select actor_id 
				   from film_actor fa
                   group by actor_id
                   order by count(film_id) desc
                   limit 1);


-- 7 Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments



select f.title 
from rental r
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
where r.customer_id =  (
     select p.customer_id
	 from payment p
	  group by p.customer_id
	  order by sum(p.amount) desc
	  limit 1);

-- 8 Get the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client.

select customer_id, sum(amount) as total_amount_spent
from payment 
group by customer_id
having sum(amount) > ( select avg(total_amount_spent)
                      from (select customer_id, sum(amount) as total_amount_spent 
                      from payment
                      group by customer_id) as AvgSpentSubquary
                      );
