SELECT * FROM 
NBA_season1718_salary nss;

SELECT * FROM 
Seasons_Stats ss
where ss."Year" > 1999;

SELECT Player, SUM(PTS) as ptsum
FROM Seasons_Stats ss 
group by Player 
ORDER by ptsum DESC;


SELECT ss.Player, ss."Year", SUM(ss.PTS), SUM(nss.season17_18) as sal, AVG(ss."FG%")
FROM Seasons_Stats ss
JOIN NBA_season1718_salary nss 
on ss.Player = nss.Player
WHERE ss."Year" > 2000
GROUP BY ss.Player 
ORDER BY sal DESC;


SELECT ss.Age, AVG(ss.PTS), AVG(nss.season17_18) as sal
FROM Seasons_Stats ss 
JOIN NBA_season1718_salary nss 
on ss.Player = nss.Player
GROUP BY ss.AGE 
ORDER BY sal DESC;

SELECT ss.Pos, AVG(ss.PTS), AVG(nss.season17_18) as sal
FROM Seasons_Stats ss 
JOIN NBA_season1718_salary nss 
on ss.Player = nss.Player
GROUP BY ss.Pos 
ORDER BY sal DESC;

SELECT ss.Tm, AVG(ss.PTS), AVG(nss.season17_18) as sal
FROM Seasons_Stats ss
JOIN NBA_season1718_salary nss 
on ss.Player = nss.Player
GROUP BY ss.Tm
ORDER BY sal DESC;

SELECT ss.Tm, AVG(ss.PTS), AVG(nss.season17_18) as sal
FROM Seasons_Stats ss
JOIN NBA_season1718_salary nss 
on ss.Player = nss.Player
GROUP BY ss.Tm
HAVING MIN(ss."Year") > 1999
ORDER BY sal DESC;




WITH Player_years AS (SELECT ss.Player, 
SUM(nss.season17_18) as sal, 
(2018-ss."Year") as yearsInLeague
FROM Seasons_Stats ss
JOIN NBA_season1718_salary nss 
on ss.Player = nss.Player
WHERE ss."Year" > 2000
GROUP BY ss.Player 
ORDER BY sal DESC)
SELECT Player_years.Player, Player_years.sal
FROM Player_years
WHERE yearsInLeague < 8;

