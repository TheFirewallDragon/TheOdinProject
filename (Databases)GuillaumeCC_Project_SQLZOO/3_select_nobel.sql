-- Change the query shown so that it displays Nobel prizes for 1950.
SELECT yr, subject, winner
  FROM nobel
 WHERE yr = 1950

--  Show who won the 1962 prize for literature.
SELECT winner
  FROM nobel
 WHERE yr = 1962
   AND subject = 'literature'

-- Show the year and subject that won 'Albert Einstein' his prize.
SELECT yr, subject
FROM nobel
WHERE winner = 'Albert Einstein'

-- Give the name of the 'peace' winners since the year 2000, including 2000.
SELECT winner
FROM nobel
WHERE subject = 'peace' AND yr >= 2000

-- Show all details (yr, subject, winner) of the literature prize winners for 1980 to 1989 inclusive.
SELECT * FROM nobel
WHERE subject = 'literature' AND yr BETWEEN 1980 AND 1989

-- Show all details of the presidential winners:
-- Theodore Roosevelt
-- Thomas Woodrow Wilson
-- Jimmy Carter
-- Barack Obama
SELECT * FROM nobel
 WHERE winner IN ('Theodore Roosevelt',
                  'Woodrow Wilson',
                  'Jimmy Carter',
                  'Barack Obama')

-- Show the winners with first name John
SELECT winner FROM nobel WHERE winner LIKE 'John%'

-- Show the year, subject, and name of physics winners for 1980 together with the chemistry winners for 1984.
SELECT * FROM nobel WHERE (subject = 'physics' AND yr = 1980) OR  (subject = 'chemistry' AND yr = 1984)

-- Show the year, subject, and name of winners for 1980 excluding chemistry and medicine
SELECT * FROM nobel WHERE yr = 1980 AND subject NOT IN ('chemistry', 'medicine')

-- Show year, subject, and name of people who won a 'Medicine' prize in an early year (before 1910, not including 1910) together with winners of a 'Literature' prize in a later year (after 2004, including 2004)
SELECT * FROM nobel
WHERE (yr < 1910 AND subject = 'Medicine') OR (yr >= 2004 AND subject = 'Literature')

-- Find all details of the prize won by PETER GRÜNBERG
SELECT * FROM nobel WHERE winner = 'Peter Grünberg'

-- Find all details of the prize won by EUGENE O'NEILL
SELECT * FROM nobel WHERE winner = 'Eugene O\'Neill'
-- OR SELECT * FROM nobel WHERE winner = 'Eugene O''Neill'

'

--Knights in order

--List the winners, year and subject where the winner starts with Sir. Show the the most recent first, then by name order.
SELECT winner, yr, subject FROM nobel WHERE winner LIKE 'Sir %' ORDER BY yr DESC

-- The expression subject IN ('chemistry','physics') can be used as a value - it will be 0 or 1.
-- Show the 1984 winners and subject ordered by subject and winner name; but list chemistry and physics last.
SELECT winner, subject
  FROM nobel
 WHERE yr=1984
 ORDER BY (subject IN ('physics','chemistry')), subject,winner

-- Nobel Quiz: https://sqlzoo.net/wiki/Nobel_Quiz

-- 1 - E
-- 2 - C
-- 3 - B
-- 4 - C
-- 5 - C
-- 6 - C
-- 7 - D
