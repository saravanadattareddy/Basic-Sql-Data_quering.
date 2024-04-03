
   select * from movies;
   select * from movies where title Like"%Avenger%";
   select title, release_year from movies where studio Like"%Marvel %";
   select release_year from movies where title = "Godfather"; 
   select * from movies where release_year = 2022 or release_year = 2019 or release_year = 2018;
   select * from movies where studio in ("Marvel Studios", "Zee Studios");
   select * from movies where imdb_rating is NULL;
   select * from movies where imdb_rating is NOT NULL;
   select * from movies where industry = "Bollywood" Order by imdb_rating ;
   select * from movies where industry = "Bollywood" Order by imdb_rating Desc Limit 5 ;
   select * from movies order by release_year Desc;
   select * from movies where release_year = 2022;
   select * from movies where release_year > 2020;
   select * from movies where release_year > 2020 and imdb_rating > 8;
   select * from movies where studio in ("Marvel studios","Hombale Films");
   select title,release_year from movies where title like"%THOR%" order by release_year Asc;
   select * from movies where studio != "Marvel Studios";
   select MIN(imdb_rating) as min_rating,
   MAX(imdb_rating) as max_rating, (Avg(imdb_rating),2) as avg_rating from movies Where Studio = "Marvel Studios";
   select count(*) from movies where industry ="hollywood";
   select industry from movies group by industry;
    select studio  from movies group by studio;
    #how many movies were released between 2015 and 2022
    select count(*) from movies where release_year between "2015" and "2022";
    #print the max and min movie release year
    select max(release_year) as max_movies, min(release_year) as min_movies  from movies ;
    
    #print a year and how many movies were released in that year starting with latest year--

    select release_year, count(*) as movies_count 
   from movies group by release_year order by release_year desc;
   # Print profit % for all the movies
   select (revenue - budget) as profit,
      (revenue - budget)*100/budget as profit_pct from financials;
#Show all the movies with their language names

   SELECT m.title, l.name FROM movies m 
   JOIN languages l USING (language_id);
   
#Show all Telugu movie names (assuming you don't know language
#id for Telugu)
  
   SELECT title	FROM movies m 
   LEFT JOIN languages l 
   ON m.language_id=l.language_id
   WHERE l.name="Telugu";

# Show language and number of movies released in that language
   	SELECT 
            l.name, 
            COUNT(m.movie_id) as no_movies
	FROM languages l
	LEFT JOIN movies m USING (language_id)        
	GROUP BY language_id 
	ORDER BY no_movies DESC;
### Module: SQL Joins (INNER, LEFT, RIGHT, FULL)

-- Print all movies along with their title, budget, revenue, currency and unit. [INNER JOIN]
	SELECT 
            m.movie_id, title, budget, revenue, currency, unit 
	FROM movies m
	INNER JOIN financials f
	ON m.movie_id=f.movie_id;

-- Perform LEFT JOIN on above discussed scenario
	SELECT 
            m.movie_id, title, budget, revenue, currency, unit 
	FROM movies m
	LEFT JOIN financials f
	ON m.movie_id=f.movie_id;

-- Perform RIGHT JOIN on above discussed scenario
	SELECT 
            m.movie_id, title, budget, revenue, currency, unit 
	FROM movies m
	RIGHT JOIN financials f
	ON m.movie_id=f.movie_id;

-- Perform FULL JOIN using 'Union' on above two tables [movies, financials]
	SELECT 
            m.movie_id, title, budget, revenue, currency, unit 
	FROM movies m
	LEFT JOIN financials f
	ON m.movie_id=f.movie_id

	UNION

	SELECT 
            m.movie_id, title, budget, revenue, currency, unit 
	FROM movies m
	RIGHT JOIN financials f
	ON m.movie_id=f.movie_id;

-- Interchanging the position of Left and Right Tables
	Select 
	    m.movie_id, title, revenue 
	from movies m 
        left join financials f
        on m.movie_id = f.movie_id;

	Select 
	    m.movie_id, title, revenue 
	from financials f 
        left join movies m
        on m.movie_id = f.movie_id;

-- Replacing 'ON' with 'USING' while joining conditions
	Select 
	   m.movie_id, title, revenue 
	from movies m 
        left join financials f
	USING (movie_id);
      


	
### Module: Cross Join

-- Print a list of final menu items along with their price for a restaurant.
	SELECT 
           *, 
           CONCAT(name, " - ", variant_name) as full_name,
           (price+variant_price) as full_price
	FROM food_db.items
	CROSS JOIN food_db.variants;




### Module: Analytics on Tables

-- Find profit for all movies 
	SELECT 
           m.movie_id, title, budget, revenue, currency, unit, 
	   (revenue-budget) as profit 
	FROM movies m
	JOIN financials f
	ON m.movie_id=f.movie_id;

-- Find profit for all movies in bollywood
	SELECT 
           m.movie_id, title, budget, revenue, currency, unit, 
	   (revenue-budget) as profit 
	FROM movies m
	JOIN financials f
	ON m.movie_id=f.movie_id
	WHERE m.industry="Bollywood";

-- Find profit of all bollywood movies and sort them by profit amount (Make sure the profit be in millions for better comparisons)
	SELECT 
    	    m.movie_id, title revenue, currency, unit, 
            CASE 
                WHEN unit="Thousands" THEN ROUND((revenue-budget)/1000,2)
        	WHEN unit="Billions" THEN ROUND((revenue-budget)*1000,2)
                ELSE revenue-budget
            END as profit_mln
	FROM movies m
	JOIN financials f 
	ON m.movie_id=f.movie_id
	WHERE m.industry="Bollywood"
	ORDER BY profit_mln DESC;





### Module: Join More Than Two Tables

-- Show comma separated actor names for each movie
	SELECT 
            m.title, group_concat(name separator " | ") as actors
	FROM movies m
	JOIN movie_actor ma ON m.movie_id=ma.movie_id
	JOIN actors a ON a.actor_id=ma.actor_id
	GROUP BY m.movie_id;

-- Print actor name and all the movies they are part of
	SELECT 
            a.name, GROUP_CONCAT(m.title SEPARATOR ' | ') as movies
	FROM actors a
	JOIN movie_actor ma ON a.actor_id=ma.actor_id
	JOIN movies m ON ma.movie_id=m.movie_id
	GROUP BY a.actor_id;

-- Print actor name and how many movies they acted in
	SELECT 
            a.name, 
            GROUP_CONCAT(m.title SEPARATOR ' | ') as movies,
            COUNT(m.title) as num_movies
	FROM actors a
	JOIN movie_actor ma ON a.actor_id=ma.actor_id
	JOIN movies m ON ma.movie_id=m.movie_id
	GROUP BY a.actor_id
	ORDER BY num_movies DESC;
## Complex Queries




### Module: Subqueries

-- Select a movie with highest imdb_rating
	-- without subquery
	select * from movies order by imdb_rating desc limit 1;
	
	-- with subquery
	select * from movies where imdb_rating=(select max(imdb_rating) from movies);

-- Select a movie with highest and lowest imdb_rating
	-- without subquery
	select * from movies where imdb_rating in (1.9, 9.3);

	-- with subquery
	select * from movies where imdb_rating in (
        				(select min(imdb_rating) from movies), 
    					(select max(imdb_rating) from movies)
						);

-- Select all the actors whose age is greater than 70 and less than 85
	select 
	    actor_name, age
	FROM 
  	    (Select
                name as actor_name,
                (year(curdate()) - birth_year) as age
    	     From actors
            ) AS actors_age_table
	WHERE age > 70 AND age < 85;


	


### Module: ANY, ALL Operators

-- select actors who acted in any of these movies (101,110, 121)
	select * From actors WHERE actor_id = ANY(select actor_id From movie_actor where movie_id IN (101, 110, 121));

-- select all movies whose rating is greater than *any* of the marvel movies rating
	select * from movies where imdb_rating > ANY(select imdb_rating from movies where studio="Marvel studios");

-- Above, can be achieved in another way too (sub query, min)
	select * from movies where imdb_rating > (select min(imdb_rating) from movies where studio="Marvel studios");

-- select all movies whose rating is greater than *all* of the marvel movies rating
	select * from movies where imdb_rating > ALL(select imdb_rating from movies where studio="Marvel studios");

-- Above, can be achieved in another way too (sub query, max)
	select * from movies where imdb_rating > (select max(imdb_rating) from movies where studio="Marvel studios");





### Module: Co-Related Subquery

-- Get the actor id, actor name and the total number of movies they acted in.
	SELECT 
           actor_id, 
           name, 
	   (SELECT COUNT(*) FROM movie_actor WHERE actor_id = actors.actor_id) as movies_count
	FROM actors
	ORDER BY movies_count DESC;

-- Above, can be achieved by using Joins too!
	select 
	    a.actor_id, 
	    a.name, 
	    count(*) as movie_count
	from movie_actor ma
	join actors a
	on a.actor_id=ma.actor_id
	group by actor_id
	order by movie_count desc;




### Module: Common Table Expression (CTE)

-- Select all the actors whose age is greater than 70 and less than 85 [Previously, we have used sub-queries to solve this. Now we use CTE's]
	with actors_age as 
	   (select
                name as actor_name,
                year(curdate()) - birth_year as age
            from actors
	    )
	select actor_name, age from actors_age where age > 70 and age < 85;


-- Movies that produced 500% profit and their rating was less than average rating for all movies
	with 
	   x as 
	      (select 
		   *, 
                   (revenue-budget)*100/budget as pct_profit
               from financials),
    	   y as 
	      (select * from movies where imdb_rating < (select avg(imdb_rating) from movies))
	select 
	    x.movie_id, y.title, x.pct_profit, y.imdb_rating
	from x
	join y
	on x.movie_id=y.movie_id
	where x.pct_profit > 500;


##-- Above, can be achieved using sub-query too (But, code readability is less here compared to CTE's)
	select 
	   x.movie_id, y.title, x.pct_profit, y.imdb_rating
	from ( 
              select
                  *, 
                  (revenue-budget)*100/budget as pct_profit
              from financials
	     ) x
	join 
	     (select * from movies where imdb_rating < (select avg(imdb_rating) from movies)) y
	on x.movie_id=y.movie_id
	where pct_profit>500;

##Database Creation & Updates



### Module: Insert Statement

-- Simple insert for new record in movies
	INSERT INTO movies VALUES (141, "Bahuhbali 3", "Bollywood", 2030, 9.0, "Arka Media Works", 2);

-- Insert with NULL or DEFAULT values
	INSERT INTO movies VALUES (142, "Thor 10", "Hollywood", NULL, DEFAULT, "Marvel Studios", 5);

-- Same insert with column names
	INSERT INTO movies (movie_id, title, industry, language_id) VALUES (143, "Pushpa 5", "Bollywood", 2);

-- Insert with invalid language_id. Foreign key constraint fails
	INSERT INTO movies (movie_id, title, industry, language_id) VALUES (144, "Pushpa 6", "Bollywood", 10);

-- Insert multiple rows
	INSERT INTO movies 
    	     (movie_id, title, industry, language_id)
	VALUES 
    	     (145, "Inception 2", "Hollywood", 5),
             (146, "Inception 3", "Hollywood", 5),
             (147, "Inception 4", "Hollywood", 5);



### Module: Update and Delete

-- Say THOR 10 movie is released in 2050, and you want to update the rating now :)
	UPDATE movies 
	SET imdb_rating=8, release_year=2050
	WHERE movie_id=142;

-- Update multiple records. [Update all studios with 'Warner Bros. Pictures' for all the Inception movies records] 
	UPDATE movies 
	SET studio='Warner Bros. Pictures'
	WHERE title like "Inception %";

-- Delete all new inception movies
	DELETE FROM movies 
	WHERE  title like "Inception %";

-- Another delete to restore the database to normal again
	DELETE FROM movies 
	WHERE movie_id in (141, 142, 143);































    