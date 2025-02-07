-- Question 4:
-- Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.
SELECT playerid, 
    CASE
        WHEN pos = 'OF' THEN 'Outfield'
        WHEN pos IN ('SS', '1B', '2B', '3B') THEN 'Infield'
		WHEN pos IN ('P', 'C') THEN 'Battery'
        ELSE NULL
    END AS Position_Group,
    SUM(po) AS Total_Putouts
FROM
    fielding
WHERE
    yearid= 2016
GROUP BY
    playerid, Position_Group
ORDER BY playerid ASC;

