-- 2. Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?

WITH shortest_player AS (
    SELECT playerid, nameFirst, nameLast, height
    FROM people
    ORDER BY height ASC
    LIMIT 1
)
SELECT 
    sp.nameFirst || ' ' || sp.nameLast AS player_name,
    sp.height,
    SUM(a.G_all) AS total_games_played,
    t.name AS team_name
FROM shortest_player sp
JOIN appearances a ON sp.playerid = a.playerid
JOIN teams t ON a.teamid = t.teamID
GROUP BY sp.nameFirst, sp.nameLast, sp.height, t.name;

-- 6. Find the player who had the most success stealing bases in 2016, where success is measured as the percentage of stolen base attempts which are successful.
-- (A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted at least 20 stolen bases.

WITH steal_attempts AS (
    SELECT 
        playerid,
        (sb * 1.0) / NULLIF((sb + cs), 0) AS success_rate,
        sb,
        cs
    FROM batting
    WHERE yearid = 2016
    GROUP BY playerid, sb, cs
    HAVING (sb + cs) >= 20
    ORDER BY success_rate DESC
    LIMIT 1
)
SELECT 
    p.nameFirst || ' ' || p.nameLast AS player_name,
    sa.success_rate,
    sa.sb,
    sa.cs
FROM steal_attempts sa
JOIN people p ON sa.playerid = p.playerid;

--round to convert to percentage

WITH steal_attempts AS (
    SELECT 
        playerid,
        (sb * 100.0) / NULLIF((sb + cs), 0) AS success_rate, -- Convert to percentage
        sb,
        cs
    FROM batting
    WHERE yearid = 2016
    GROUP BY playerid, sb, cs
    HAVING (sb + cs) >= 20
    ORDER BY success_rate DESC
    LIMIT 1
)
SELECT 
    p.nameFirst || ' ' || p.nameLast AS player_name,
    ROUND(sa.success_rate, 2) AS success_rate, -- Round to 2 decimal places
    sa.sb,
    sa.cs
FROM steal_attempts sa
JOIN people p ON sa.playerid = p.playerid;

-- 10. Find all players who hit their career highest number of home runs in 2016. 
-- Consider only players who have played in the league for at least 10 years, and who hit at least one home run in 2016. 
-- Report the players' first and last names and the number of home runs they hit in 2016.

WITH career_hr AS (
    -- Get the maximum HR in any year for each player
    SELECT playerid, MAX(HR) AS max_career_hr
    FROM batting
    GROUP BY playerid
),
player_10_years AS (
    -- Get players who have played at least 10 years
    SELECT playerid
    FROM batting
    GROUP BY playerid
    HAVING COUNT(DISTINCT yearID) >= 10
)
SELECT 
    p.nameFirst || ' ' || p.nameLast AS player_name,
    b.HR AS hr_2016
FROM batting b
JOIN career_hr ch ON b.playerid = ch.playerid
JOIN player_10_years py ON b.playerid = py.playerid
JOIN people p ON b.playerid = p.playerid
WHERE b.yearID = 2016
  AND b.HR > 0  -- Only consider players who hit at least 1 HR in 2016
  AND b.HR = ch.max_career_hr;  -- Only include players whose 2016 HR count is their highest ever