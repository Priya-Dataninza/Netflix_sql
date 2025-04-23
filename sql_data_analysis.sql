--Netflix Project 

DROP TABLE IF EXISTS netflix;

CREATE TABLE netflix
(
show_id VARCHAR(6),
type VARCHAR(6),
title VARCHAR(150),
director VARCHAR(300),
casts VARCHAR(1000),
country VARCHAR(150),
date_added VARCHAR(50),
release_year int,
rating VARCHAR(10),
duration VARCHAR(20),
listed_in VARCHAR(100),
description VARCHAR(250)
);

 SELECT * FROM netflix;

 --15 Business problems to solve 

 --1. Count the number of Movies vs TV Showse

 SELECT
      type,
      COUNT(*) AS total_content
FROM netflix
 GROUP BY type;

 --2.Find the most common rating for Movies and TV Shows
 SELECT type,
        rating 
 FROM
        (SELECT type,
		        rating,
			    COUNT(*),
				RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
         FROM netflix
         GROUP BY type,rating)
 WHERE ranking=1;
 
--3.List all movies released in a specific year (e.g.,2021)

SELECT * 
     FROM netflix 
    WHERE  type ='Movie'
               AND
		   release_year =2021;

--4.Find the top 5 countries with the most content on netflix

SELECT
     UNNEST(STRING_TO_ARRAY(country,',')) AS new_country,
	 COUNT(show_id) AS total_content 
          FROM netflix
GROUP BY country
ORDER BY total_content DESC
LIMIT 5;

--5.Identify the longest Movie

SELECT * 
      FROM netflix
  WHERE type ='Movie'
         AND 
     duration=(SELECT MAX(duration) FROM netflix);

--6.Find content added in the last 5 years

SELECT * 
      FROM netflix
WHERE TO_DATE(date_added,'Month DD,YYYY')=CURRENT_DATE - INTERVAL'5 years';

--7.Find all the Movies/TV Shows by director 'Rajiv Chilaka'

SELECT * 
     FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';

--8.List all TV Shows with more than 5 seasons

SELECT *
     FROM netflix ;
WHERE type='TV Show'
         AND
SPLIT_PART(duration,' ',1)::INT>5;

--9.Count the number of content items in each genre
SELECT UNNEST(STRING_TO_ARRAY(listed_in,',')) AS genre,
       COUNT(*) AS no_of_content
     FROM netflix
GROUP BY genre;

--10.Find each year and the average numbers of content release by India on
--netflix return top 5 year with highest average content release 

SELECT EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD,YYYY')) AS 
release_year,COUNT(*),ROUND(((COUNT(*)::NUMERIC/(SELECT COUNT(*) FROM netflix WHERE country='India'):: NUMERIC) * 100),2) AS no_content 
FROM netflix
WHERE country = 'India'
GROUP BY EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD,YYYY'))
ORDER BY no_content DESC
LIMIT 5;

--11.Find all content without a director

SELECT *
   FROM netflix
WHERE director IS NULL;

--12.List all movies that are documentries

SELECT *
   FROM netflix
WHERE type='Movie'
        AND 
listed_in ILIKE '%documentaries%';

--13.Find how many movies actor 'Salman Khan' appeared in last 10 years

SELECT *
    FROM netflix
WHERE casts ILIKE '%Salman Khan%'
          AND
TO_DATE(date_added,'Month DD,YYYY')>CURRENT_DATE - INTERVAL'10 years';

--14.Find the top 10 actors who have appeared in the highest number of movies produced in India

SELECT UNNEST(STRING_TO_ARRAY(casts,',')),
       COUNT(*) AS no_content
FROM netflix
GROUP BY UNNEST(STRING_TO_ARRAY(casts,','))
ORDER BY COUNT(*) DESC
LIMIT 10;

--15.Categorize the content based on the presence of the keywords 'kill' and 'voilence' in 
--the description field.Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.

SELECT *,
       CASE 
   WHEN description ILIKE '%kill%'
           OR
		description ILIKE '%voilence%'
              THEN 'Bad_content'
  ELSE 'Good_content'
      END AS Category
FROM netflix;

-----------------------------------------------END OF PROJECT---------------------------------------------------------------------










 