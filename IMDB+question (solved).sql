USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT
   table_name,
   table_rows as no_of_rows 
FROM
   INFORMATION_SCHEMA.TABLES 
WHERE
   TABLE_SCHEMA = 'imdb';









-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT
   IF (COUNT(*) - COUNT(title) > 0, 'has null', 'no null') AS title,
   IF (COUNT(*) - COUNT(YEAR) > 0, 'has null', 'no null') AS year,
   IF (COUNT(*) - COUNT(date_published) > 0, 'has null', 'no null') AS date_published,
   IF (COUNT(*) - COUNT(duration) > 0, 'has null', 'no null') AS duration,
   IF (COUNT(*) - COUNT(country) > 0, 'has null', 'no null') AS country,
   IF (COUNT(*) - COUNT(worlwide_gross_income) > 0, 'has null', 'no null') AS worlwide_gross_income,
   IF (COUNT(*) - COUNT(languages) > 0, 'has null', 'not null') AS languages,
   IF (COUNT(*) - COUNT(production_company) > 0, 'has null', 'no null') AS production_company 
FROM
   movie;






-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT
   year,
   COUNT(id) AS number_of_movies 
FROM
   movie 
GROUP BY
   YEAR;
SELECT
   MONTH(date_published) 'month_num',
   COUNT(id) AS number_of_movies 
FROM
   movie 
GROUP BY
   MONTH(date_published) 
ORDER BY
   MONTH(date_published);


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT
   SUM(number_of_movies ) total_no_of_movies_in_2019 
FROM
   (
      SELECT
         COUNT(id) AS number_of_movies 
      FROM
         movie 
      WHERE
         country regexp "India" 
         AND YEAR = "2019" 
      UNION ALL
      SELECT
         COUNT(id) AS number_of_movies 
      FROM
         movie 
      WHERE
         country regexp "USA" 
         AND YEAR = "2019" 
   )
   summation;



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
SELECT DISTINCT
(genre) 
FROM
   genre;

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT
   genre,
   COUNT(genre) AS no_of_movies 
FROM
   genre g 
   JOIN
      movie m 
      ON g.movie_id = m.id 
GROUP BY
   genre 
ORDER BY
   COUNT(genre) DESC LIMIT 1;








/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
SELECT
   COUNT(*) AS no_of_movies_with_one_genre 
FROM
   (
      SELECT
         movie_id 
      FROM
         genre g 
         JOIN
            movie m 
            ON g.movie_id = m.id 
      GROUP BY
         title 
      HAVING
         COUNT(DISTINCT genre) = 1 
   )
   having_one_genre;










/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT
   genre,
   round(AVG(duration)) AS avg_duration 
FROM
   genre g 
   INNER JOIN
      movie m 
      ON g.movie_id = m.id 
GROUP BY
   genre 
ORDER BY
   round(AVG(duration)) DESC;



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


WITH genre_ranks AS 
(
   SELECT
      genre,
      COUNT(movie_id) AS movie_count,
      RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank 
   FROM
      genre AS g 
      INNER JOIN
         movie AS m 
         ON m.id = g.movie_id 
   GROUP BY
      g.genre 
)
SELECT
   * 
FROM
   genre_ranks 
WHERE
   genre = 'Thriller';









/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT
   MIN(avg_rating) AS min_avg_rating,
   MAX(avg_rating)AS max_avg_rating,
   MIN(total_votes) AS min_total_votes,
   MAX(total_votes) AS max_total_votes,
   MIN(median_rating) AS min_median_rating,
   MAX(median_rating) AS max_median_rating 
FROM
   ratings;




    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

-- It's ok if RANK() or DENSE_RANK() is used too
SELECT
   title,
   avg_rating,
   RANK() OVER( 
ORDER BY
   avg_rating DESC) AS movie_rank 
FROM
   movie m 
   INNER JOIN
      ratings r 
      ON m.id = r.movie_id LIMIT 10;







/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
SELECT
   median_rating,
   COUNT(movie_id) AS movie_count 
FROM
   ratings 
GROUP BY
   median_rating 
ORDER BY
   median_rating;









/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
WITH production_house AS 
(
   SELECT
      production_company,
      COUNT(movie_id) AS movie_count,
      RANK() OVER(
   ORDER BY
      COUNT(movie_id) DESC) AS prod_company_rank 
   FROM
      movie m 
      JOIN
         ratings r 
         ON m.id = r.movie_id 
   WHERE
      avg_rating > 8.0 
      AND production_company IS NOT NULL 
   GROUP BY
      production_company
)
SELECT
   * 
FROM
   production_house 
WHERE
   prod_company_rank = 1;










-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT
   genre,
   COUNT(id) AS movie_count 
FROM
   genre AS g 
   INNER JOIN
      movie AS m 
      ON m.id = g.movie_id 
   INNER JOIN
      ratings r 
      ON m.id = r.movie_id 
WHERE
   total_votes > 1000 
   AND MONTH(date_published) = '3' 
   AND YEAR(date_published) = '2017' 
   AND country = "USA" 
GROUP BY
   g.genre 
ORDER BY
   movie_count DESC;











-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
SELECT
   title,
   avg_rating,
   genre 
FROM
   genre g 
   JOIN
      movie m 
      ON m.id = g.movie_id 
   JOIN
      ratings r 
      ON r.movie_id = m.id 
WHERE
   avg_rating > 8 
   AND title LIKE "The %" 
GROUP BY
   genre ;









-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT
   COUNT(title) AS no_of_movie_titles 
FROM
   ratings r 
   JOIN
      movie m 
      ON r.movie_id = m.id 
WHERE
   date_published BETWEEN CAST('2018-04-01' AS DATE) AND CAST('2019-04-01' AS DATE) 
   AND median_rating = 8;








-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
WITH cte AS 
(
   SELECT
      SUM(total_votes) AS German_votes 
   FROM
      (
         SELECT
            languages,
            SUM(total_votes) AS total_votes 
         FROM
            movie m 
            JOIN
               ratings r 
               ON r.movie_id = m.id 
         GROUP BY
            languages 
         ORDER BY
            languages
      )
      t 
   WHERE
      languages regexp "german" 
)
,
cte1 AS
(
   SELECT
      SUM(total_votes) AS Italian_votes 
   FROM
      (
         SELECT
            languages,
            SUM(total_votes) AS total_votes 
         FROM
            movie m 
            JOIN
               ratings r 
               ON r.movie_id = m.id 
         GROUP BY
            languages 
         ORDER BY
            languages
      )
      t 
   WHERE
      languages regexp "italian"
)
SELECT
   cte.German_votes,
   cte1.Italian_votes,
   IF( cte.german_votes > cte1.italian_votes, "Yes", "NO") AS Are_German_Votes_More 
FROM
   cte 
   JOIN
      cte1;

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
SELECT
   IF (COUNT(*) - COUNT(name) > 0, COUNT(*) - COUNT(name), '0') AS name_nulls,
   IF (COUNT(*) - COUNT(height) > 0, COUNT(*) - COUNT(height), '0') AS height_nulls,
   IF (COUNT(*) - COUNT(date_of_birth) > 0, COUNT(*) - COUNT(date_of_birth), '0') AS date_of_birth_nulls,
   IF (COUNT(*) - COUNT(known_for_movies) > 0, COUNT(*) - COUNT(known_for_movies) , '0') AS known_for_movies_nulls 
FROM
   names;







/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
WITH top_rated_genres AS 
(
   SELECT
      genre,
      COUNT(m.id) AS movie_count,
      RANK() OVER (
   ORDER BY
      COUNT(m.id) DESC) AS genre_rank 
   FROM
      genre AS g 
      LEFT JOIN
         movie AS m 
         ON g.movie_id = m.id 
      INNER JOIN
         ratings AS r 
         ON m.id = r.movie_id 
   WHERE
      avg_rating > 8 
   GROUP BY
      genre 
)
SELECT
   n.name AS director_name,
   COUNT(m.id)AS movie_count 
FROM
   names AS n 
   INNER JOIN
      director_mapping AS d 
      ON n.id = d.name_id 
   INNER JOIN
      movie AS m 
      ON d.movie_id = m.id 
   INNER JOIN
      ratings AS r 
      ON m.id = r.movie_id 
   INNER JOIN
      genre AS g 
      ON g.movie_id = m.id 
WHERE
   g.genre IN
   (
      SELECT DISTINCT
         genre 
      FROM
         top_rated_genres 
      WHERE
         genre_rank <= 3
   )
   AND avg_rating > 8 
GROUP BY
   name 
ORDER BY
   movie_count DESC LIMIT 3;









/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
SELECT
   n.name AS actor_name,
   COUNT(m.id) AS movie_count 
FROM
   names AS n 
   JOIN
      role_mapping AS rm 
      ON n.id = rm.name_id 
   JOIN
      movie AS m 
      ON m.id = rm.movie_id 
   JOIN
      ratings AS r 
      ON m.id = r.movie_id 
WHERE
   r.median_rating >= 8 
   AND category = "actor" 
GROUP BY
   actor_name 
ORDER BY
   movie_count DESC LIMIT 2;







/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
WITH production AS 
(
   SELECT
      production_company,
      SUM(total_votes) AS vote_count,
      ROW_NUMBER() OVER(
   ORDER BY
      SUM(total_votes) DESC ) AS prod_comp_rank 
   FROM
      ratings r 
      JOIN
         movie m 
         ON m.id = r.movie_id 
   GROUP BY
      production_company
)
SELECT
   * 
FROM
   production 
WHERE
   prod_comp_rank <= 3;









/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT
   n.name AS actor_name,
   SUM(total_votes) AS total_votes,
   COUNT(m.id) AS movie_count,
   round(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actor_avg_rating,
   RANK() OVER(
ORDER BY
   SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) DESC) AS actor_rank 
FROM
   names n 
   INNER JOIN
      role_mapping rm 
      ON n.id = rm.name_id 
   INNER JOIN
      ratings r 
      ON r.movie_id = rm.movie_id 
   INNER JOIN
      movie m 
      ON m.id = r.movie_id 
WHERE
   m.country = "India" 
   and rm.category='actor'
GROUP BY
   n.name 
HAVING
   COUNT(m.id) >= 5 ;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
SELECT
   n.name AS actor_name,
   SUM(total_votes) AS total_votes,
   COUNT(m.id) AS movie_count,
   round(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actor_avg_rating,
   RANK() OVER(
ORDER BY
   SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) DESC) AS actor_rank 
FROM
   names n 
   INNER JOIN
      role_mapping rm 
      ON n.id = rm.name_id 
   INNER JOIN
      ratings r 
      ON r.movie_id = rm.movie_id 
   INNER JOIN
      movie m 
      ON m.id = r.movie_id 
WHERE
   m.country = "India" 
   AND rm.category = 'actress' 
   AND languages = "Hindi" 
GROUP BY
   n.name 
HAVING
   COUNT(m.id) >= 3;



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
SELECT DISTINCT
   m.Title,
   r.Avg_rating,
   CASE
      WHEN
         r.avg_rating > 8 
      THEN
         "Superhit" 
      WHEN
         r.avg_rating BETWEEN 7 AND 8 
      THEN
         "Hit" 
      WHEN
         r.avg_rating BETWEEN 5 AND 7 
      THEN
         "One-time-watch" 
      ELSE
         "Flop" 
   END
   AS Classified
FROM
   names n 
   JOIN
      role_mapping rm 
      ON n.id = rm.name_id 
   JOIN
      ratings r 
      ON r.movie_id = rm.movie_id 
   JOIN
      movie m 
      ON m.id = r.movie_id 
   JOIN
      genre AS g 
      ON g.movie_id = m.id 
WHERE
   g.genre = 'Thriller' 
ORDER BY
   avg_rating DESC;









/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:


SELECT
   genre,
   round(AVG(duration), 2) AS avg_duration,
   SUM(round(AVG(duration), 2)) OVER(
ORDER BY
   genre) AS running_total_duration,
   round(AVG(AVG(duration)) OVER(
ORDER BY
   genre), 2) AS moving_avg_duration 
FROM
   movie AS m 
   INNER JOIN
      genre AS g 
      ON m.id = g.movie_id 
GROUP BY
   genre 
ORDER BY
   genre;








-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

-- Assuming Numeric Value as standard for worldwide_gross_income  instead of real currency conversion
SELECT
   * 
FROM
   (
      WITH top_rated_genres AS 
      (
         SELECT
            genre,
            COUNT(m.id) AS movie_count,
            RANK() OVER ( 
         ORDER BY
            COUNT(m.id) DESC) AS genre_rank 
         FROM
            genre AS g 
            JOIN
               movie AS m 
               ON g.movie_id = m.id 
            INNER JOIN
               ratings AS r 
               ON m.id = r.movie_id 
         GROUP BY
            genre 
      )
      SELECT
         genre,
         year,
         title AS movie_name,
         worlwide_gross_income,
         ROW_NUMBER() OVER(PARTITION BY YEAR 
      ORDER BY
         CAST(replace(replace(worlwide_gross_income, '$', ''), 'INR', '') AS DECIMAL(18, 2)) DESC) AS movie_rank 
      FROM
         movie AS m 
         INNER JOIN
            genre AS g 
            ON m.id = g.movie_id 
      WHERE
         worlwide_gross_income IS NOT NULL 
         AND genre IN 
         (
            SELECT
               genre 
            FROM
               top_rated_genres 
            WHERE
               genre_rank <= 3
         )
   )
   t 
WHERE
   movie_rank <= 5 ;









-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
SELECT
   production_company,
   COUNT(m.id) AS movie_count,
   RANK() OVER(
ORDER BY
   COUNT(m.id) DESC) AS prod_comp_rank 
FROM
   movie m,
   ratings r 
WHERE
   POSITION(',' IN languages) > 0 
   AND median_rating >= 8 
   AND m.id = r.movie_id 
   AND production_company IS NOT NULL 
GROUP BY
   production_company LIMIT 2;





-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:



SELECT
   n.name AS actress_name,
   SUM(r.total_votes) AS total_votes,
   COUNT(m.id) AS movie_count,
   round(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actress_avg_rating,
   ROW_NUMBER() OVER(
ORDER BY
   SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes) DESC) AS actress_rank 
FROM
   movie m 
   JOIN
      genre g 
      ON m.id = g.movie_id 
   JOIN
      ratings r 
      ON r.movie_id = m.id 
   JOIN
      role_mapping rm 
      ON rm.movie_id = m.id 
   JOIN
      names n 
      ON n.id = rm.name_id 
WHERE
   r.avg_rating > 8 
   AND g.genre = "drama" 
   AND rm.category = 'actress' 
GROUP BY
   n.name LIMIT 3;









/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH moviedays AS
  (
  WITH sub_movie AS
  (
           SELECT   name_id,
                    lead(date_published,1,0)over(partition BY name_id ORDER BY date_published),
                    date_published,
                    datediff(lead(date_published,1,0)over (partition BY name_id ORDER BY date_published),date_published) AS inter_movie_duration
           FROM     names n,
                    director_mapping dm,
                    movie m,
                    ratings r
           WHERE    n.id=dm.name_id
           AND      dm.movie_id =m.id
           AND      m.id=r.movie_id )
  SELECT   name_id,
           round(avg(inter_movie_duration))AS avg_inter_movie_days
  FROM     sub_movie
  GROUP BY name_id )
SELECT     n.id        													AS director_id ,
           name        													AS director_name,
           count(m.id)													AS number_of_movies,
           avg_inter_movie_days,
           round(sum(r.avg_rating *r.total_votes)/sum(r.total_votes),2) AS avg_rating,
           sum(r.total_votes)                                           AS total_votes,
           min(r.avg_rating)                                            AS min_rating,
           max(r.avg_rating)                                            AS max_rating,
           sum(duration)                                                AS total_duration
FROM       names n
INNER JOIN director_mapping dm
ON         n.id=dm.name_id
INNER JOIN movie m
ON         dm.movie_id =m.id
INNER JOIN ratings r
ON         m.id=r.movie_id
LEFT JOIN  moviedays md
ON         n.id=md.name_id
GROUP BY   director_id
ORDER BY   number_of_movies DESC
LIMIT      9;
