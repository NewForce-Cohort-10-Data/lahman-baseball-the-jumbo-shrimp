-- 8. Using the attendance figures from the homegames table, 
-- find the teams and parks which had the top 5 average attendance per game in 2016 

WITH park_info AS (WITH id_keys AS (SELECT team, park, games, ROUND(AVG(attendance) ,0) avg_attendance
FROM homegames
GROUP BY team, park, games
ORDER BY avg_attendance DESC)

SELECT p.park_name, i.team, i.avg_attendance
FROM parks as p
INNER JOIN id_keys as i
USING(park)
GROUP BY team, p.park_name, i.avg_attendance
ORDER BY i.avg_attendance DESC)

SELECT p.park_name, name, p.avg_attendance
FROM teams as t
INNER JOIN park_info as p
ON t.teamid = p.team
GROUP BY p.park_name, name, p.avg_attendance
ORDER BY p.avg_attendance DESC
LIMIT 5

-- COL, NYA, SLN, SFN, LAA

-- (where average attendance is defined as total attendance divided by number of games).  



WITH park_info AS (WITH id_keys AS (SELECT team, park, ROUND(AVG(attendance)/games ,0) avg_attendance
FROM homegames
GROUP BY team, park, games
ORDER BY avg_attendance DESC)

SELECT p.park_name, i.team, i.avg_attendance
FROM parks as p
INNER JOIN id_keys as i
USING(park)
GROUP BY team, p.park_name, i.avg_attendance
ORDER BY i.avg_attendance DESC)

SELECT p.park_name, name, p.avg_attendance
FROM teams as t
INNER JOIN park_info as p
ON t.teamid = p.team
GROUP BY p.park_name, name, p.avg_attendance
ORDER BY p.avg_attendance DESC
LIMIT 5

-- Only consider parks where there were at least 10 games played.
-- Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.


WITH park_info AS (WITH id_keys AS (SELECT team, park, ROUND(AVG(attendance),0) avg_attendance
FROM homegames
WHERE games >= 10
GROUP BY team, park, games
ORDER BY avg_attendance ASC
)

SELECT p.park_name, i.team, i.avg_attendance
FROM parks as p
INNER JOIN id_keys as i
USING(park)
GROUP BY team, p.park_name, i.avg_attendance
ORDER BY i.avg_attendance ASC)

SELECT p.park_name, name, p.avg_attendance
FROM teams as t
INNER JOIN park_info as p
ON t.teamid = p.team
GROUP BY p.park_name, name, p.avg_attendance
ORDER BY p.avg_attendance ASC
LIMIT 5

-- All the results show up as 0
