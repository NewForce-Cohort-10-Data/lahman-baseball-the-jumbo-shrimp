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