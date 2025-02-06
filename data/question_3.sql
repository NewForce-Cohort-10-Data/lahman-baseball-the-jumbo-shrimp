WITH players AS (WITH player_id AS (WITH school_id AS (
	SELECT s.schoolid
	FROM schools AS s
	WHERE schoolid = 'vandy'
)

SELECT c.playerid,
		schoolid
FROM collegeplaying AS c
INNER JOIN school_id AS s
USING (schoolid)
)

SELECT playerid,
	p.namefirst, 
	p.namelast
FROM people as p
INNER JOIN player_id as pi
USING (playerid))

SELECT pl.namefirst, pl.namelast, 
SUM(sa.salary) AS total_salary 
FROM salaries AS sa
INNER JOIN players AS pl
USING(playerid)
GROUP BY pl.namefirst, pl.namelast
ORDER BY total_salary DESC