-- 1. What range of years for baseball games played does the provided database cover?
SELECT MIN(yearid), MAX(yearid)
FROM teams

-- 5. Find the average number of strikeouts per game by decade since 1920. 
-- Round the numbers you report to 2 decimal places. 

SELECT 
    (yearid / 10) * 10 AS decade,
    ROUND(SUM(so)::numeric/SUM(g)::numeric, 2) AS avg_strikeouts_per_game
FROM batting
WHERE yearid >= 1920
GROUP BY decade
ORDER BY decade;

SELECT 
    (yearid / 10) * 10 AS decade,
    ROUND(SUM(hr)::numeric/SUM(g)::numeric, 2) AS avg_homeruns_per_game
FROM batting
WHERE yearid >= 1920
GROUP BY decade
ORDER BY decade;




-- 9. Which managers have won the TSN Manager of the Year award in both 
-- the National League (NL) and the American League (AL)? 
-- Give their full name and the teams that they were managing when they won the award.

SELECT 
    p.nameFirst, p.nameLast AS full_name,
    MAX(CASE WHEN a.lgID = 'AL' THEN t.name END) AS team_AL,
    MAX(CASE WHEN a.lgID = 'NL' THEN t.name END) AS team_NL
FROM AwardsManagers a
JOIN Teams t 
    ON a.yearID = t.yearID 
    AND a.lgID = t.lgID
JOIN People p 
    using (playerid)
WHERE a.awardID = 'TSN Manager of the Year'
GROUP BY p.nameFirst, p.nameLast, a.playerID
HAVING 
    COUNT(distinct a.lgID) = 2 
ORDER BY full_name;


-- 13. Let's find if right handed pitchers are more common or the opposite.

SELECT 
    throws, 
    COUNT(DISTINCT playerID) AS pitcher_count,
    ROUND(100.0 * COUNT(DISTINCT playerID) / (SELECT COUNT(DISTINCT playerID) 
                                              FROM Pitching), 2) AS percentage
FROM People
WHERE playerID IN (SELECT DISTINCT playerID FROM Pitching)
GROUP BY throws
ORDER BY percentage DESC;

-- -- In our result table, we can see that there are significantly more players who pitch with their 
-- right hand (71.01%). Only 26.63% of players pitch with their left hand, making left-handed pitching indeed rarer.
-- Now knowing the percentage of left hand pitchers are lower, we nee to see whether they are more likely to make it 
-- into the hall of fame. 

SELECT 
    p.throws, 
    COUNT(h.playerID) AS hall_of_fame_pitchers,
    ROUND(100.0 * COUNT(h.playerID) / (SELECT COUNT(*) FROM HallOfFame WHERE inducted = 'Y'), 2) AS percentage
FROM HallOfFame h
JOIN People p 
    ON h.playerID = p.playerID
WHERE h.inducted = 'Y'
AND h.playerID IN (SELECT DISTINCT playerID FROM Pitching)
GROUP BY p.throws
ORDER BY hall_of_fame_pitchers DESC;

-- Now in our results we can see 24.6% of right-handed pitchers made it into the Hall of Fame,
-- compared to only 7.26% of left-handed pitchers.BUt it might be because there are more player who 
-- are right handed, so there is a bigger chance that a player chosen to be indicted will be right handed. 


-- Now let's count how many how many left-handed vs. right-handed pitchers have won the Cy Young Award.

SELECT 
    p.throws, 
    COUNT(a.playerID) AS cy_young_wins,
    ROUND(100.0 * COUNT(a.playerID) / (SELECT COUNT(*) FROM AwardsPlayers WHERE awardID = 'Cy Young Award'), 2) AS percentage
FROM AwardsPlayers a
JOIN People p 
    ON a.playerID = p.playerID
WHERE a.awardID = 'Cy Young Award'
GROUP BY p.throws
ORDER BY cy_young_wins DESC;

-- This suggests that while there are fewer left-handed pitchers,
-- those who do make it to the top tend to perform at a high level.

-- In conclusion, I believe there isn’t a significant difference in
-- Hall of Fame inductions, as that could be influenced by other factors
-- such as player likability or charisma. However, when it comes to 
-- skill sets, I do see a slight advantage for left-handed pitchers. 
-- Those who could throw with their left arm had a strategic edge
-- over their right-handed peers. 
-- I don't know much about baseball, but being left-handed might influence 
-- how a player throws the ball and how batters have to adjust to hit it.
-- So yeah, there is a subtle advantage for left handed pitchers, but sometimes that's all you need to 
-- set yourself apart from other great players when you are competing at a high level.
-- I don't think it’s a coincidence that one of the greatest pitchers
-- of all time, Sandy Koufax, was left-handed.
