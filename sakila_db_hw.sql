USE sakila;

SELECT first_name, last_name
FROM actor;


SELECT concat(first_name,' ', last_name) AS "Actor Name"
FROM actor;


SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name like "Joe%";

SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name like "%GEN%";

SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name like "%LI%"
ORDER BY last_name, first_name;

SELECT country_id, country
FROM country 
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

ALTER TABLE actor
ADD COLUMN description BLOB;

ALTER TABLE actor DROP description;

SELECT last_name, count(last_name) AS 'last name count'
FROM actor
GROUP BY last_name;

SELECT last_name, count(actor_id) AS 'last_name_count'
FROM actor
GROUP BY last_name;

SELECT last_name, count(actor_id) AS 'last_name_count'
FROM actor
GROUP BY last_name
HAVING last_name_count > 1;

UPDATE actor
SET first_name = 'HARPO'
WHERE actor_id = 172;

UPDATE actor
SET first_name = 'GROUCHO'
WHERE actor_id = 172;

SHOW CREATE TABLE address;

-- 6a
SELECT first_name, last_name, address
FROM staff s LEFT JOIN address a
	ON s.address_id = a.address_id;
    
-- 6b
SELECT first_name, last_name, payment_date, SUM(amount) AS 'total amount'
FROM staff s LEFT JOIN payment p
	ON s.staff_id = p.staff_id
WHERE payment_date LIKE '2005-08%'
GROUP BY first_name;

-- 6c
SELECT title, COUNT(actor_id) AS 'actor count'
FROM film f INNER JOIN film_actor fa
	ON f.film_id = fa.film_id 
GROUP BY title;

-- 6d
SELECT title, f.film_id, COUNT(inventory_id) AS 'inventory count'
FROM film f LEFT JOIN inventory i
		ON f.film_id = i.film_id
GROUP BY title
HAVING title like '%Hunchback Impossible%';

-- 6e
SELECT first_name, last_name, SUM(amount) AS 'total amount paid'
FROM customer c LEFT JOIN payment p
		ON c.customer_id = p.customer_id
GROUP BY last_name;

-- 7a
SELECT title
FROM film
WHERE title LIKE 'K%' OR  title LIKE 'Q%' AND language_id IN (SELECT language_id
																FROM language
														WHERE name = 'English');
-- 7b
SELECT CONCAT(first_name,' ', last_name) AS 'actor name'
FROM actor
WHERE actor_id IN (SELECT actor_id
					FROM film_actor
                    WHERE film_id IN (SELECT film_id
										FROM film
                                        WHERE title = 'Alone Trip'));

-- 7c
SELECT country, first_name, last_name, email
FROM customer cu LEFT JOIN address a
	ON cu.address_id = a.address_id
    JOIN city ci 
    ON a.city_id = ci.city_id
    JOIN country co
    ON ci.country_id = co.country_id
WHERE country = 'Canada';

-- 7d
SELECT title, rating
FROM film
WHERE  rating = 'PG' or rating = 'PG-13'
ORDER BY title;

-- 7e
SELECT title, MAX(rental_date) AS 'rental date'
FROM rental r LEFT JOIN inventory i
	ON r.inventory_id = i.inventory_id
    JOIN film f
		ON i.film_id = f.film_id
GROUP BY title
ORDER BY MAX(rental_date) DESC;

-- 7f
SELECT st.store_id, SUM(amount) AS 'total amount'
FROM store st JOIN staff s 
	ON st.store_id = s.store_id
    JOIN payment p 
    ON s.staff_id = p.staff_id
GROUP BY st.store_id;

-- 7g
SELECT st.store_id, city, country
FROM store st JOIN staff s
	ON st.store_id = s.store_id
    JOIN address a
    ON s.address_id = a.address_id
    JOIN city c
    ON a.city_id = c.city_id
    JOIN country co
    ON c.country_id = co.country_id
GROUP BY city;

-- 7h
SELECT c.name, SUM(p.amount) AS 'total amount'
FROM category c LEFT JOIN film_category fc
	ON c.category_id = fc.category_id
    JOIN inventory i
    ON fc.film_id = i.film_id
    JOIN rental r
    ON i.inventory_id = r.inventory_id
    JOIN payment p
    ON r.rental_id = p.rental_id
GROUP BY c.name 
ORDER BY 'total amount' DESC
LIMIT 5;

-- 8a
CREATE OR REPLACE VIEW top5_videos AS 
SELECT  c.name, SUM(p.amount)
FROM category c LEFT JOIN film_category fc
	ON c.category_id = fc.category_id
    JOIN inventory i
    ON fc.film_id = i.film_id
    JOIN rental r
    ON i.inventory_id = r.inventory_id
    JOIN payment p
    ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY 'total amount' DESC
LIMIT 5;


-- 8b
SELECT * FROM top5_videos;

-- 8c
DROP VIEW top5_videos;




