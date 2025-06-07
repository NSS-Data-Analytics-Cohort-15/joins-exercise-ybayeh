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
HAVING worldwide_gross = MIN(worldwide_gross)
ORDER BY revenue.worldwide_gross ASC;

-- Answer:
	"company_name" 	"release_year"	"worldwide_gross"
	"Warner Bros."		1977			37187139

-- 2. What year has the highest average imdb rating?
SELECT 	
		specs.release_year
	,	AVG(imdb_rating) AS avg_imdb_rating
FROM specs
	INNER JOIN rating
	USING(movie_id)
GROUP BY specs.release_year
ORDER BY AVG(imdb_rating) DESC;

--Answer: 
	"release_year"		"avg_imdb_rating"
		1991			7.4500000000000000




