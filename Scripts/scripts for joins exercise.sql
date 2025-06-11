-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.
SELECT 
		specs.film_title
	,	specs.release_year
	,	revenue.worldwide_gross
FROM specs
	LEFT JOIN revenue
	USING (movie_id)
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
ORDER BY rating.imdb_rating DESC;

--Answer: 
	"release_year"		"avg_imdb_rating"
		1991			7.4500000000000000


-- 3. What is the highest grossing G-rated movie? Which company distributed it?
SELECT 
		distributors.company_name
	,	specs.film_title
	, 	specs.mpaa_rating
	,	revenue.worldwide_gross
FROM distributors
	INNER JOIN specs
	ON distributors.distributor_id = specs.domestic_distributor_id
		INNER JOIN revenue
		USING(movie_id)
WHERE specs.mpaa_rating = 'G'
ORDER BY revenue.worldwide_gross DESC
LIMIT 1;

--Answer:
	"company_name"	"film_title"	"mpaa_rating"	"worldwide_gross"
	"Walt Disney "	"Toy Story 4"	"G"				1073394593

-- 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.
SELECT 	
		distributors.company_name
	,	COUNT(specs.movie_id)
FROM distributors
	LEFT JOIN specs
	ON distributors.distributor_id = specs.domestic_distributor_id
GROUP BY distributors.company_name
ORDER BY COUNT(specs.movie_id) DESC;


-- 5. Write a query that returns the five distributors with the highest average movie budget.
SELECT 
		distributors.company_name
	,	COUNT(specs.film_title)
	,	AVG(revenue.film_budget)::money AS average_film_budget
FROM distributors
	LEFT JOIN specs
	ON distributors.distributor_id = specs.domestic_distributor_id
		INNER JOIN revenue
		USING(movie_id)
GROUP BY distributors.company_name
ORDER BY AVG(revenue.film_budget) DESC
LIMIT 5;

--Answer:
	"company_name"	"count"	"average_film_budget"
	"Walt Disney "	76	"$148,735,526.32"
	"Sony Pictures"	31	"$139,129,032.26"
	"Lionsgate"		5	"$122,600,000.00"
	"DreamWorks"	17	"$121,352,941.18"
	"Warner Bros."	71	"$103,430,985.92"																																
-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?
SELECT
		distributors.company_name
	,	distributors.headquarters
	,	specs.film_title --COUNT(specs.movie_id)
	,	rating.imdb_rating
FROM distributors
	INNER JOIN specs
	ON distributors.distributor_id = specs.domestic_distributor_id
		INNER JOIN rating
		USING(movie_id)
WHERE distributors.headquarters NOT ILIKE '%, CA'
ORDER BY rating.imdb_rating DESC
LIMIT 1;

--Answer:
	"company_name"		"headquarters"		"film_title"	"imdb_rating"
	"Vestron Pictures"	"Chicago, Illinois"	"Dirty Dancing"		7.0
	
-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?

--a) USING CASE 
SELECT
    CASE
        WHEN specs.length_in_min > 120 THEN 'Over 2 Hours'
        WHEN specs.length_in_min <= 120 THEN '2 Hours or Less' -- This includes movies exactly 120 mins. 
    END AS film_length_category, -- This creates a new column called film_length_category that assigns each movie to one of your desired categories based on its length 
    AVG(rating.imdb_rating) AS average_rating
FROM
    specs
JOIN
    rating ON specs.movie_id = rating.movie_id
GROUP BY
    film_length_category -- Grouping all movies belonging to 'Over 2 Hours' into one group and '2 Hours or Less' into another, allowing AVG() to calculate the average for each category.
ORDER BY 1 DESC;																																															

--Answer:
	"film_length_category"	"average_rating"
	"Over 2 Hours"			7.2571428571428571
	"2 Hours or Less"		6.9154185022026432

--b) USING UNION
SELECT 'movies > 2 hours' AS movie_time, AVG(imdb_rating)
FROM specs
JOIN rating
USING(movie_id)
WHERE  length_in_min > 120
UNION
SELECT 'movies < 2 hours' AS movie_time ,AVG(imdb_rating)
FROM specs
JOIN rating
USING(movie_id)
WHERE  length_in_min < 120

--Answer:
	"movie_time"	"avg"
"movies < 2 hours"	6.9161434977578475
"movies > 2 hours"	7.2571428571428571





