-- Recently i discovered that there seems to be some implicit aliasing if I don't use the "AS" function. 
	-- ex. normally I would alias a column like so: w AS wins
	-- But I am able to do so as w wins
	-- I discovered this in my personal project and I will test if any error may occur

SELECT name, 
wswin, 
yearid, w wins
FROM teams
WHERE wswin = 'N'
AND 
yearid BETWEEN 1970 AND 2016
ORDER BY w DESC



-- 7.  From 1970 – 2016, what is the largest number of wins for a team that did not win the world series?

SELECT name, wswin, yearid, w AS wins
FROM teams
WHERE wswin = 'N'
AND 
yearid BETWEEN 1970 AND 2016
ORDER BY w DESC

--Seattle Mariners - 116


--  What is the smallest number of wins for a team that did win the world series? Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. Then redo your query, excluding the problem year. How often from 1970 – 2016 

SELECT name, 
wswin, 
yearid, w wins
FROM teams
WHERE wswin = 'Y'
AND 
yearid BETWEEN 1970 AND 2016
ORDER BY w ASC

-- Los Angeles Dodgers, 63

-- was it the case that a team with the most wins also won the world series? 

(SELECT teamid, 
wswin, 
yearid, w AS wins
FROM teams
WHERE 
-- wswin = 'Y' AND 
yearid BETWEEN 1970 AND 2016
ORDER BY w DESC)



-- No. This is not the case. The Seattle Mariners won had the most wins 

--  What percentage of the time?

(SELECT teamid, 
wswin, 
yearid, (COUNT(w) * 100/ (SELECT COUNT(w)) )  AS wins
FROM teams
WHERE 
-- wswin = 'Y' AND 
yearid BETWEEN 1970 AND 2016
GROUP BY teamid, wswin, yearid
ORDER BY wins DESC)

-- I attempted to look up the percentage calculation. There seems to be some problems