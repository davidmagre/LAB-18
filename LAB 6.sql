/*1. Rank films by length (filter out the rows with nulls or zeros in length column). 
Select only columns title, length and rank in your output.*/

select title, length, rank() over (order by length desc) as 'Rank Length' from sakila.film
where length is not null and length != 0;


/*2. Rank films by length within the `rating` category (filter out the rows with nulls or zeros in length column). 
In your output, only select the columns title, length, rating and rank.*/

select title, length, rating, rank() over (partition by rating order by length desc) as 'Rank Length' from sakila.film
where length is not null and length != 0;
  
/*3. How many films are there for each of the categories in the category table? 
**Hint**: Use appropriate join between the tables "category" and "film_category".*/

select category_id, count(*) as film_count
from film f inner join film_category c on f.film_id = c.film_id
group by category_id;

/*4. Which actor has appeared in the most films? 
**Hint**: You can create a join between the tables "actor" and "film actor" and count the number of times an actor appears.*/

select a.first_name, a.last_name, count(*) as film_count
from actor a inner join film_actor fa on a.actor_id = fa.actor_id
group by a.actor_id
order by film_count desc
limit 1;

/*5. Which is the most active customer (the customer that has rented the most number of films)? 
**Hint**: Use appropriate join between the tables "customer" and "rental" and count the `rental_id` for each customer.*/

select c.first_name, c.last_name, count(*) as rental_count
from customer c inner join rental r on c.customer_id = r.customer_id
group by c.customer_id
order by rental_count desc
limit 1;

/*6. List the number of films per category.*/

select category_id, count(*) as film_count
from film f inner join film_category c on f.film_id = c.film_id
group by category_id;

/*7. Display the first and the last names, as well as the address, of each staff member.*/

select first_name, last_name, email from staff;

/*8. Display the total amount rung up by each staff member in August 2005.*/

SELECT 
    s.first_name, 
    s.last_name, 
    CONCAT(YEAR(p.payment_date), '-', MONTH(p.payment_date)) AS payment_month,
    SUM(p.amount) AS total_amount
FROM 
    payment p 
INNER JOIN 
    staff s ON p.staff_id = s.staff_id
WHERE 
    MONTH(p.payment_date) = 8 AND YEAR(p.payment_date) = 2005
GROUP BY 
    s.first_name, s.last_name, payment_month;

/*9. List all films and the number of actors who are listed for each film.*/

select title, count(*) as actor_count
from film f inner join film_actor fa on f.film_id = fa.film_id
group by f.film_id, title;

/*10. Using the payment and the customer tables as well as the JOIN command, list the total amount paid by each customer. 
List the customers alphabetically by their last names.*/

select first_name, last_name, sum(amount) as amount_customer
from customer c inner join payment p on c.customer_id = p.customer_id
group by first_name, last_name
order by last_name asc;

/*11. Write a query to display for each store its store ID, city, and country.*/

select store_id, city, country
from store s inner join address a
on s.address_id = a.address_id
inner join city ci
on a.city_id= ci.city_id
inner join country co
on ci.country_id = co.country_id
group by store_id, city, country;

/*12. Write a query to display how much business, in dollars, each store brought in.*/

select s.store_id, concat('$', format(sum(p.amount), 2)) as amount_store
from store s inner join staff sf
on s.store_id = sf.store_id
inner join payment p
on sf.staff_id= p.staff_id
group by s.store_id;

/*13. What is the average running time of films by category?*/

select c.name, avg(f.length) as average_length
from category c inner join film_category fc
on c.category_id = fc.category_id
inner join film f
on fc.film_id= f.film_id
group by c.name;

/*14. Which film categories are longest?*/

select c.name, avg(f.length) as average_length
from category c inner join film_category fc
on c.category_id = fc.category_id
inner join film f
on fc.film_id= f.film_id
group by c.name
order by average_length desc;

/*15. Display the most frequently rented movies in descending order.*/

select f.title, count(*) as number_of_rented_times
from film f inner join inventory i
on f.film_id = i.film_id
inner join rental r
on i.inventory_id= r.inventory_id
group by f.title
order by number_of_rented_times desc;

/*16. List the top five genres in gross revenue in descending order.*/

select c.name, sum(p.amount) as gross_revenue
from category c inner join film_category fc
on c.category_id = fc.category_id
inner join inventory i
on fc.film_id = i.film_id
inner join rental r
on i.inventory_id = r.inventory_id
inner join payment p
on r.rental_id = p.rental_id
group by c.name
order by gross_revenue desc
limit 5;

/*17. Is "Academy Dinosaur" available for rent from Store 1?*/

select f.title, count(*) as available_copies
from inventory i
inner join film f 
on i.film_id = f.film_id
inner join store s
on i.store_id = s.store_id
where f.title = 'Academy Dinosaur' and s.store_id = 1;