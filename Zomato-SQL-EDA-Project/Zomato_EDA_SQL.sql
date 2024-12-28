
-- Creating the table and importing dataset as csv file.

CREATE TABLE zomato(
	name TEXT,
	online_order VARCHAR(10),
	book_table VARCHAR(10),
	rating FLOAT,
	votes INTEGER,
	location VARCHAR(50),
	rest_type VARCHAR(50),
	dish_liked TEXT,
	cuisines TEXT,
	cost_two_people INTEGER,
	listed_in_type VARCHAR(50),
	listed_in VARCHAR(50)
); */

-- viewing data
SELECT * FROM zomato;

-- most rated restaraunts
SELECT name,rating,location FROM zomato
WHERE rating >4.5;

-- checking for unique rest values 
SELECT COUNT(name),COUNT(DISTINCT(name)) FROM zomato;

-- top restaraunts most orderd
SELECT name,COUNT(name) AS total_orders FROM zomato
GROUP BY name
ORDER BY total_orders DESC
limit 10;

SELECT * FROM zomato;
--Top 3 Shops doing maximum business
SELECT name,SUM(cost_two_people) AS costly ,ROUND(AVG(rating)::NUMERIC,2) AS avg_rating FROM zomato
GROUP BY name
HAVING SUM(cost_two_people) IS NOT NULL 
ORDER BY costly DESC;

--In which area most restaurants located
SELECT COUNT(name),location AS area FROM zomato
GROUP BY location
ORDER BY COUNT(name) DESC;

--In which area lowest restaurants located
SELECT COUNT(name),location AS area FROM zomato
GROUP BY location
ORDER BY COUNT(name) ASC
LIMIT 10 ;


-- From which area Got most online_orders 
SELECT COUNT(online_order) AS orders,listed_in FROM zomato
WHERE online_order='Yes'
GROUP BY listed_in
ORDER BY orders DESC;


--Restaurants delivering Online or not
SELECT COUNT(name),online_order FROM zomato
GROUP BY online_order;

--Restaurants allowing table booking or not
SELECT COUNT(name),book_table FROM zomato
GROUP BY book_table;

--Top Locations with most Ratings and orders
SELECT COUNT(name),location,online_order,AVG(rating) FROM zomato
WHERE online_order ='Yes'
GROUP BY location,online_order
HAVING AVG(rating) > 4
ORDER BY COUNT(name) DESC;

--Top 10 famous restaurant types in bengaluru
SELECT COUNT(name) AS rest_name,rest_type  FROM zomato
GROUP BY rest_type
HAVING rest_type IS NOT NULL 
ORDER BY rest_name DESC
LIMIT 10;

--Top 10 famous restaurant types i.e rated in bengaluru
SELECT rest_type,AVG(rating) AS avg_rating  FROM zomato
GROUP BY rest_type
HAVING rest_type IS NOT NULL AND AVG(rating) > 4
LIMIT 10;

--Top 10 costly restaurant types in bengaluru
SELECT ROUND(AVG(cost_two_people),2) AS costly,rest_type  FROM zomato
GROUP BY rest_type
HAVING AVG(cost_two_people) IS NOT NULL 
ORDER BY costly DESC
LIMIT 10;

-- Top dishes ordered
SELECT COUNT(dish_liked) AS dishs_orderd,dish_liked FROM zomato
GROUP BY dish_liked
ORDER BY dishs_orderd DESC
LIMIT 10;

-- Least dishes ordered
SELECT COUNT(dish_liked) AS dishs_orderd,dish_liked FROM zomato
GROUP BY dish_liked
ORDER BY dishs_orderd ASC
LIMIT 10;

-- Top dishes liked
SELECT AVG(rating) AS rating,dish_liked FROM zomato
GROUP BY dish_liked
HAVING AVG(rating) IS NOT NULL 
ORDER BY rating DESC
LIMIT 10;

-- bottom rated dishes
SELECT ROUND(AVG(rating)::NUMERIC,2) AS rating,dish_liked FROM zomato
GROUP BY dish_liked
HAVING AVG(rating) IS NOT NULL 
ORDER BY rating ASC
LIMIT 10;


-- Top cuisines ordered
SELECT COUNT(cuisines) AS cuisines_ordered,cuisines FROM zomato
GROUP BY cuisines
ORDER BY cuisines_ordered DESC
LIMIT 10;

-- Top cuisines liked
SELECT ROUND(AVG(rating)::NUMERIC,2) AS rating,cuisines FROM zomato
GROUP BY cuisines
HAVING AVG(rating) IS NOT NULL 
ORDER BY rating DESC
LIMIT 10;

--  Bottom rated cuisines
SELECT ROUND(AVG(rating)::NUMERIC,2) AS rating,cuisines FROM zomato
GROUP BY cuisines
HAVING AVG(rating) IS NOT NULL 
ORDER BY rating ASC
LIMIT 10; */