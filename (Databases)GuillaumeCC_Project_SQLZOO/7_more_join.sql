-- Lesson: https://sqlzoo.net/wiki/More_JOIN_operations

-- List the films where the yr is 1962 [Show id, title]
SELECT id, title
 FROM movie
 WHERE yr=1962

-- Give year of 'Citizen Kane'.
SELECT yr FROM movie WHERE title = 'Citizen Kane'

-- List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
SELECT id, title, yr FROM movie WHERE title LIKE '%Star Trek%' ORDER BY yr

-- What id number does the actor 'Glenn Close' have?
SELECT id FROM actor WHERE name = 'Glenn Close'

-- What is the id of the film 'Casablanca'
SELECT id FROM movie WHERE title = 'Casablanca'

-- Obtain the cast list for 'Casablanca'.
SELECT name FROM actor JOIN casting ON id = actorid WHERE movieid = 11768

-- Obtain the cast list for the film 'Alien'
SELECT name FROM actor JOIN casting ON id = actorid WHERE movieid = (SELECT id FROM movie WHERE title = 'Alien')

-- List the films in which 'Harrison Ford' has appeared
SELECT title FROM movie JOIN casting ON id = movieid WHERE actorid = (SELECT id FROM actor WHERE name = 'Harrison Ford')

-- List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]
SELECT title FROM movie JOIN casting ON id = movieid WHERE actorid = (SELECT id FROM actor WHERE name = 'Harrison Ford' AND ord > 1)

-- List the films together with the leading star for all 1962 films.
SELECT m.title, a.name FROM casting
JOIN movie as m ON movieid = m.id
JOIN actor AS a ON actorid = a.id
WHERE m.yr = 1962 AND ord = 1

-- Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
        JOIN actor   ON actorid=actor.id
WHERE name='Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2

-- List the film title and the leading actor for all of the films 'Julie Andrews' played in.
SELECT title, name FROM movie
JOIN casting ON id = movieid AND ord = 1
JOIN actor ON actorid = actor.id
WHERE movie.id IN (
  SELECT movieid FROM casting
  WHERE actorid IN
   (SELECT id FROM actor WHERE name='Julie Andrews'))


-- Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.
SELECT name FROM actor
JOIN casting ON id = actorid AND ord = 1
GROUP BY name
HAVING COUNT(name) >= 15
ORDER BY name

-- List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT title, COUNT(actorid) as number FROM movie
JOIN casting ON id = movieid WHERE yr = 1978
GROUP BY title
ORDER BY number DESC, title

-- List all the people who have worked with 'Art Garfunkel'.
SELECT name FROM actor
JOIN casting ON id = actorid
WHERE movieid IN (
    SELECT id FROM movie
    JOIN casting ON id=movieid
        WHERE actorid = (SELECT id FROM actor WHERE name = 'Art Garfunkel'))
AND name != 'Art Garfunkel'

-- Quiz: https://sqlzoo.net/wiki/JOIN_Quiz_2
-- 1 - C
-- 2 - E
-- 3 - C
-- 4 - B
-- 5 - D
-- 6 - C
-- 7 - B
