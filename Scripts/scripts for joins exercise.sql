-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.
SELECT 
		specs.film_title
	,	specs.release_year
	,	revenue.worldwide_gross
FROM specs
	INNER JOIN revenue
	USING (movie_id)
GROUP BY specs.film_title,
		specs.release_year,
		revenue.worldwide_gross
ORDER BY revenue.worldwide_gross;

-- Answer:
 	"film_title"	"release_year"	"worldwide_gross"
	"Semi-Tough"		1977		37187139

-- 2. What year has the highest average imdb rating?
SELECT 	
		specs.release_year
	,	AVG(rating.imdb_rating)
FROM specs
	INNER JOIN rating
	USING(movie_id)
GROUP BY specs.release_year
ORDER BY AVG(rating.imdb_rating) DESC;

--Answer: 
	"release_year"		"avg_imdb_rating"
		1991			7.4500000000000000


-- 3. What is the highest grossing G-rated movie? Which company distributed it?
SELECT 
		distributors.company_name
	, 	specs.mpaa_rating
	,	MAX(revenue.worldwide_gross)
FROM distributors
	INNER JOIN specs
	ON distributors.distributor_id = specs.domestic_distributor_id
		INNER JOIN revenue
		USING(movie_id)
WHERE specs.mpaa_rating = 'G'
GROUP BY distributors.company_name, specs.mpaa_rating
ORDER BY MAX(revenue.worldwide_gross) DESC;

--Answer:
	"company_name"	"mpaa_rating"	"worldwide_gross"
	"Walt Disney "		"G"			1073394593

-- 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.
SELECT 	
		DISTINCT(distributors.company_name)
	,	COUNT(specs.movie_id)
FROM distributors
	LEFT JOIN specs
	ON distributors.distributor_id = specs.domestic_distributor_id
GROUP BY DISTINCT(distributors.company_name);


-- 5. Write a query that returns the five distributors with the highest average movie budget.
SELECT 
		distributors.company_name
	,	specs.movie_id
	,	AVG(revenue.film_budget)
FROM distributors
	INNER JOIN specs
	ON distributors.distributor_id = specs.domestic_distributor_id
		INNER JOIN revenue
		USING(movie_id)
GROUP BY distributors.company_name, specs.movie_id
ORDER BY AVG(revenue.film_budget) DESC
LIMIT 5;

--Answer:
	"company_name"	"movie_id"	"avg"
	"Walt Disney "	5547	356000000.00000000
	"Walt Disney "	5557	321000000.00000000
	"Walt Disney "	5567	317000000.00000000
	"Walt Disney "	5667	300000000.00000000
	"Warner Bros."	5685	270000000.00000000


-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?
SELECT
		distributors.company_name
	,	distributors.headquarters
	,	COUNT(specs.movie_id)
	,	rating.imdb_rating
FROM distributors
	INNER JOIN specs
	ON distributors.distributor_id = specs.domestic_distributor_id
		INNER JOIN rating
		USING(movie_id)
WHERE distributors.headquarters NOT ILIKE '%CA%'
GROUP BY distributors.company_name, distributors.headquarters, rating.imdb_rating
ORDER BY rating.imdb_rating DESC;

--Answer:
	"company_name"	"headquarters"	"count"	"imdb_rating"
	"IFC Films"		"New York, NY"		1		6.5
	
-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?
SELECT
		specs.film_title
	,	specs.length_in_min/60 AS length_in_hours
	,	AVG(rating.imdb_rating)
FROM specs
	INNER JOIN rating
		USING(movie_id)
WHERE  specs.length_in_min/60 > 2
	OR specs.length_in_min/60 < 2
GROUP BY specs.film_title, length_in_hours
ORDER BY AVG(rating.imdb_rating) DESC
LIMIT 5;

--Answer:
	"film_title"				"length_in_hours"	"avg"
	"The Lord of the Rings: 	
	The Return of the King"				3			8.9000000000000000
	"Schindler's List"					3			8.9000000000000000