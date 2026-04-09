
-- CREATE DATA BASE NETFLIX DB
CREATE DATABASE Netflix_db;

USE Netflix_db;

-- Create Table Netflix 
CREATE TABLE netflix_titles (
  show_id      VARCHAR(10)  PRIMARY KEY,
  type         VARCHAR(10),
  title        VARCHAR(300),
  director     VARCHAR(300),
  cast         TEXT,
  country      VARCHAR(200),
  date_added   DATE,
  release_year INT,
  rating       VARCHAR(20),
  duration     VARCHAR(20),
  listed_in    VARCHAR(300),
  description  TEXT
);
-- import csv file SQLserver.

SELECT *
FROM netflix_titles;

-- Query 1 : Summary Statistics --Content count by type
SELECT type,
       COUNT(*) AS Total_titles,
	   ROUND(100.0 *  COUNT(*) / SUM (COUNT(*)) OVER(), 2) AS Percentage
FROM netflix_titles
GROUP BY type
ORDER BY Total_titles DESC;

-- Query 2 : Top 10 Countries by Number of Titles
SELECT TOP (10)country,
       COUNT(title) As No_of_Titles,
FROM netflix_titles
WHERE country is not null
GROUP BY country
ORDER BY No_of_Titles DESC;

-- Query 3: Content added per Year(Trend)

SELECT YEAR(date_added) AS year_added,
       COUNT(*) AS titles_added
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY YEAR(date_added)
ORDER BY year_added;

-- Query 4: Rating Distribution by Content Type
SELECT type AS content_type,
       rating, COUNT(*) AS count
FROM netflix_titles
WHERE rating IS NOT NULL
GROUP BY type, rating
ORDER BY type, count DESC;


-- Query 5: Average Movie Duration by Rating
SELECT rating,
       ROUND(AVG(CAST(
           LEFT(duration, CHARINDEX(' ', duration) - 1) 
       AS INT)), 1) AS avg_duration_min
FROM netflix_titles
WHERE type = 'Movie'
  AND duration LIKE '%min%'
GROUP BY rating
ORDER BY avg_duration_min DESC;

-- Query 6: Correlation Proxy — Movies Added vs Release Year Gap

SELECT type,
        ROUND(AVG(YEAR(date_added) - release_year), 1) as avg_year_to_add,
		MIN(YEAR(date_added) - release_year) As min_gap,
		MAX(YEAR(date_added) - release_year) As max_gap
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY type;

-- Query 7: Top Genres Using String Splitting
SELECT TOP(10)
    TRIM(value) AS genre,
    COUNT(*) AS genre_count
FROM netflix_titles
CROSS APPLY STRING_SPLIT(listed_in, ',')
WHERE TRIM(value) <> ''
GROUP BY TRIM(value)
ORDER BY genre_count DESC;

-- Query 8: Directors with Most Titles
SELECT TOP(10)director,
      COUNT(*) AS title_count,
	  STRING_AGG(type, ', ') WITHIN GROUP (ORDER BY type) AS content_type
FROM ( SELECT DISTINCT director, type
     FROM netflix_titles
     WHERE director <> 'Unknown'
) sub
GROUP BY director
ORDER BY title_count DESC;
