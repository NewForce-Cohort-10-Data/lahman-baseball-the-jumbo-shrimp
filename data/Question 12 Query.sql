-- Question 12
-- In this question, you will explore the connection between number of wins and attendance.
-- Does there appear to be any correlation between attendance at home games and number of wins?

-- Not from scanning data, but perhaps with visualizations.

WITH attendance_data AS (
    SELECT
        h.team,
        h.year,
        ROUND(SUM(h.attendance) / SUM(h.games), 0) AS avg_attendance
    FROM homegames h
    GROUP BY h.team, h.year)

SELECT
    t.name AS team_name,
    ad.year,
    ad.avg_attendance,
    t.w AS total_wins
FROM attendance_data ad
JOIN teams t ON t.teamid = ad.team AND t.yearid = ad.year
ORDER BY avg_attendance DESC;

-- Do teams that win the world series see a boost in attendance the following year? 
-- Yes

WITH attendance_data AS (
    SELECT
        h.team,
        h.year,
        ROUND(SUM(h.attendance) / SUM(h.games), 0) AS avg_attendance
    FROM homegames h
    GROUP BY h.team, h.year
),
world_series_winners AS (
    SELECT teamid, yearid AS ws_year
    FROM teams
    WHERE wswin = 'Y'
)
SELECT 
    t.name AS team_name,
    ws.ws_year AS win_year,
    ad_win.avg_attendance AS avg_win_year_attendance, 
    COALESCE(ad_next.avg_attendance, 0) AS avg_next_year_attendance, 
    (COALESCE(ad_next.avg_attendance, 0) - ad_win.avg_attendance) AS attendance_diff
FROM world_series_winners ws
JOIN teams t ON ws.teamid = t.teamid AND ws.ws_year = t.yearid 
LEFT JOIN attendance_data ad_win ON t.teamid = ad_win.team AND ad_win.year = ws.ws_year
LEFT JOIN attendance_data ad_next ON t.teamid = ad_next.team AND ad_next.year = ws.ws_year + 1
ORDER BY attendance_diff DESC, ws.ws_year DESC, t.name;


-- What about teams that made the playoffs? Making the playoffs means either being a division winner or a wild card winner.
-- Yes

WITH attendance_data AS (
    SELECT
        h.team,
        h.year,
        ROUND(SUM(h.attendance) / SUM(h.games), 0) AS avg_attendance
    FROM homegames h
    GROUP BY h.team, h.year
),
playoff_teams AS (
    SELECT teamid, yearid
    FROM teams
    WHERE divwin = 'Y' OR wcwin = 'Y'
)
SELECT 
    t.name AS team_name,
    pt.yearid AS playoff_year,
    ad_playoff.avg_attendance AS avg_playoff_year_attendance, 
    COALESCE(ad_next.avg_attendance, 0) AS avg_next_year_attendance, 
    (COALESCE(ad_next.avg_attendance, 0) - ad_playoff.avg_attendance) AS attendance_diff
FROM playoff_teams pt
JOIN teams t ON pt.teamid = t.teamid AND pt.yearid = t.yearid 
LEFT JOIN attendance_data ad_playoff ON t.teamid = ad_playoff.team AND ad_playoff.year = pt.yearid
LEFT JOIN attendance_data ad_next ON t.teamid = ad_next.team AND ad_next.year = pt.yearid + 1
ORDER BY attendance_diff DESC, pt.yearid DESC, t.name;

