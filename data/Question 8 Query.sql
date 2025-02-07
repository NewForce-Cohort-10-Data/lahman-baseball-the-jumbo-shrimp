-- Question 8:
-- Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 (where average attendance is defined as total attendance divided by number of games). Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance. 

WITH attendance_data AS (
    SELECT
        h.team AS team_id,
        p.park_name AS park_name,
        ROUND(h.attendance / h.games, 0) AS avg_attendance
    FROM homegames h
    JOIN parks p ON h.park = p.park
    WHERE h.year = 2016
      AND h.games >= 10)

SELECT park_name, team_id, avg_attendance
FROM attendance_data
ORDER BY avg_attendance DESC
LIMIT 5;

-- Repeat for the lowest 5 average attendance

WITH attendance_data AS (
    SELECT
        h.team AS team_id,
        p.park_name AS park_name,
        ROUND(h.attendance / h.games, 0) AS avg_attendance
    FROM homegames h
    JOIN parks p ON h.park = p.park
    WHERE h.year = 2016
      AND h.games >= 10)

SELECT park_name, team_id, avg_attendance
FROM attendance_data
ORDER BY avg_attendance ASC
LIMIT 5;