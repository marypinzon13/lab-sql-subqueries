/*
How many copies of the film Hunchback Impossible exist in the inventory system?
List all films whose length is longer than the average of all the films.
Use subqueries to display all actors who appear in the film Alone Trip.
Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
Customers who spent more than the average payments.
*/
-- How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT * FROM sakila.film;
SELECT * FROM sakila.inventory;

SELECT film_id, title
FROM sakila.film
WHERE title = 'Hunchback Impossible';

SELECT COUNT(film_id) as inventory
FROM sakila.inventory
WHERE film_id = 439
GROUP BY film_id;

SELECT COUNT(i.film_id) as Inventory
FROM sakila.film as fi
INNER JOIN  sakila.inventory as i
ON fi.film_id = i.film_id
WHERE fi.title = 'Hunchback Impossible' and i.film_id = 439
GROUP BY i.film_id;


-- List all films whose length is longer than the average of all the films.
SELECT * FROM sakila.film;

SELECT ROUND(AVG(length),2) AS average
FROM sakila.film;
-- avg(length) 115.27

SELECT film_id, title, length 
FROM sakila.film
WHERE length > ALL (SELECT ROUND(AVG(length),2) AS average
FROM sakila.film);

-- Use subqueries to display all actors who appear in the film Alone Trip.
SELECT * FROM sakila.actor;
SELECT * FROM sakila.film_actor;
SELECT * FROM sakila.film;
-- 17 film id

SELECT first_name, last_name
FROM sakila.actor
WHERE actor_id IN (
					SELECT actor_id
					FROM sakila.film_actor
					WHERE film_id IN(
						SELECT film_id
						FROM sakila.film
						WHERE title = 'Alone Trip'));

/*
Sales have been lagging among young families, and you wish to target all family 
movies for a promotion. 
Identify all movies categorized as family films.
*/

-- category id family is 8. 
SELECT * FROM sakila.category;
SELECT * FROM sakila.film_category;
SELECT * FROM sakila.film;

SELECT film_id, title, description
FROM sakila.film
WHERE film_id IN (SELECT film_id
				  FROM sakila.film_category
				  WHERE category_id IN(SELECT category_id
										FROM sakila.category
										WHERE name = 'family'));


/* Get name and email from customers from Canada using subqueries. 
Do the same with joins. Note that to create a join, you will have 
to identify the correct tables with their primary keys and foreign keys, 
that will help you get the relevant information.
    */
SELECT * FROM sakila.customer;
SELECT * FROM sakila.address;
SELECT * FROM sakila.city;
-- id country 20.
SELECT * FROM sakila.country;

SELECT customer_id, first_name, email, address_id 
FROM sakila.customer
WHERE address_id IN(
					SELECT city_id 
					FROM sakila.address
                    WHERE city_id IN (
									SELECT city_id
									FROM sakila.city
									WHERE country_id IN(
														SELECT country_id
                                                        FROM sakila.country
                                                        WHERE country = 'Canada')));
-- inner join
SELECT cu.customer_id, cu.first_name, cu.email, cu.address_id
FROM sakila.customer as cu
INNER JOIN sakila.address as ad
ON cu.address_id = ad.address_id
INNER JOIN sakila.city as ci
ON ad.city_id = ci.city_id
INNER JOIN  sakila.country as co
ON ci.country_id = co.country_id
WHERE co.country = 'Canada';


/*
Which are films starred by the most prolific actor? Most prolific actor is defined as the
 actor that has acted in the most number of films. First you will have to find 
 the most prolific actor and then use that actor_id to find the different films 
 that he/she starred.
*/
SELECT * FROM sakila.actor;
SELECT * FROM sakila.film_actor;
SELECT * FROM sakila.film;


SELECT  ac.first_name as name, COUNT(ac.actor_id) as actor
FROM sakila.actor as ac
INNER JOIN sakila.film_actor as fa
ON ac.actor_id = fa.actor_id
GROUP BY ac.actor_id
ORDER BY ac.actor_id DESC;


/*
Films rented by most profitable customer. 
You can use the customer table and payment
 table to find the most profitable customer 
 ie the customer that has made the largest sum of payments
*/

SELECT * FROM sakila.customer;
SELECT * FROM sakila.payment;


SELECT customer_id, sum(amount) as total
FROM sakila.payment
WHERE customer_id IN (SELECT customer_id
						FROM sakila.customer
						WHERE active = 1)
GROUP BY customer_id
ORDER BY total DESC
LIMIT 20;


-- Customers who spent more than the average payments.

SELECT customer_id,amount
FROM sakila.payment
WHERE amount > (SELECT ROUND(AVG(amount),2)
					FROM sakila.payment)

ORDER BY amount DESC
LIMIT 20;

 