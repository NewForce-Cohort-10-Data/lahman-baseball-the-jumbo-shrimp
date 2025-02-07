-- 8. Using the attendance figures from the homegames table, 
-- find the teams and parks which had the top 5 average attendance per game in 2016 

SELECT team, park, ROUND(AVG(attendance) ,0) avg_attendance
FROM homegames
GROUP BY team, park
ORDER BY avg_attendance DESC
LIMIT 5;
-- COL, NYA, SLN, SFN, LAA

-- (where average attendance is defined as total attendance divided by number of games).  

SELECT team, park, ROUND(AVG(attendance)/games ,0) avg_attendance
FROM homegames
GROUP BY team, park, games
ORDER BY avg_attendance DESC
LIMIT 5;


-- Only consider parks where there were at least 10 games played.
-- Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.

SELECT *
FROM homegames

