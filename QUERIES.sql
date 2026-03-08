-- In the 2021/22 Premier League season, which 5 players had the highest overall “impact score”
-- (goals, assists, recoveries, passes), and what are their average training rating and salary?

-- SELECT TOP 5 p.First_Name,p.Last_Name,
-- SUM(pp.Goals) AS Goals,SUM(pp.Assists) AS Assists,SUM(pp.Recoveries) AS Recoveries,SUM(pp.Passes_Completed) AS Passes,
-- CAST(SUM(pp.Goals)*4 + SUM(pp.Assists)*3 + SUM(pp.Recoveries)*0.5 + SUM(pp.Passes_Completed)*0.01 AS DECIMAL(10,2)) AS Impact_Score,
-- ta.Avg_Rating,ct.Salary
-- FROM PLAYERS p
-- JOIN PLAYER_PERFORMANCE pp ON pp.Player_ID=p.Player_ID
-- JOIN FIXTURES f ON f.Fixture_ID=pp.Fixture_ID
-- JOIN COMPETITIONS c ON c.Competition_ID=f.Competition_ID
-- JOIN SEASONS s ON s.Season_ID=f.Season_ID
-- LEFT JOIN (SELECT Player_ID,AVG(CAST(Rating AS DECIMAL(5,2))) AS Avg_Rating FROM TRAINING_RATING GROUP BY Player_ID) ta ON ta.Player_ID=p.Player_ID
-- LEFT JOIN CONTRACTS ct ON ct.Player_ID=p.Player_ID
-- WHERE c.Competition_Name='Premier League' AND s.Season_Years='2021/22'
-- GROUP BY p.First_Name,p.Last_Name,ta.Avg_Rating,ct.Salary
-- HAVING COUNT(pp.Player_Performance_ID)>=4
-- ORDER BY Impact_Score DESC;

-- Which opponents have been the toughest for us in the Premier League (2021/22),
-- based on lowest points-per-game, plus goals for/against against each club?

-- SELECT TOP 5 rc.Club_Name,
-- COUNT(*) AS Games,
-- SUM(f.Points_Secured) AS Points,
-- CAST(SUM(f.Points_Secured)*1.0/COUNT(*) AS DECIMAL(4,2)) AS Points_Per_Game,
-- SUM(f.Goals_For) AS Goals_For,
-- SUM(f.Goals_Against) AS Goals_Against,
-- SUM(f.Goals_For)-SUM(f.Goals_Against) AS Goal_Difference
-- FROM FIXTURES f
-- JOIN COMPETITIONS c ON c.Competition_ID=f.Competition_ID
-- JOIN SEASONS s ON s.Season_ID=f.Season_ID
-- JOIN RIVAL_CLUBS rc ON rc.Club_ID=f.Club_ID
-- WHERE c.Competition_Name='Premier League' AND s.Season_Years='2021/22'
-- GROUP BY rc.Club_Name
-- ORDER BY Points_Per_Game ASC, Goal_Difference ASC;

-- Which 5 players contributed the biggest share of our total goal contributions in 2021/22 (all competitions),
-- and what % of the team’s total (goals+assists) did each player produce?

-- SELECT TOP 5 p.First_Name,p.Last_Name,
-- SUM(pp.Goals) AS Goals,SUM(pp.Assists) AS Assists,
-- SUM(pp.Goals+pp.Assists) AS Goal_Contributions,
-- CAST(SUM(pp.Goals+pp.Assists)*100.0/
-- NULLIF((SELECT SUM(pp2.Goals+pp2.Assists) FROM PLAYER_PERFORMANCE pp2
-- JOIN FIXTURES f2 ON f2.Fixture_ID=pp2.Fixture_ID
-- JOIN SEASONS s2 ON s2.Season_ID=f2.Season_ID
-- WHERE s2.Season_Years='2021/22'),0) AS DECIMAL(5,2)) AS Share_Percent
-- FROM PLAYERS p
-- JOIN PLAYER_PERFORMANCE pp ON pp.Player_ID=p.Player_ID
-- JOIN FIXTURES f ON f.Fixture_ID=pp.Fixture_ID
-- JOIN SEASONS s ON s.Season_ID=f.Season_ID
-- WHERE s.Season_Years='2021/22'
-- GROUP BY p.First_Name,p.Last_Name
-- ORDER BY Share_Percent DESC,Goal_Contributions DESC;


-- In 2021/22, which 5 players were the best “big-game” performers:
-- only matches where goal difference >=2, ranked by impact score per 90?

-- SELECT TOP 5 p.First_Name,p.Last_Name,
-- SUM(CAST(pp.Minutes_Played AS INT)) AS Minutes,
-- CAST((
--     (SUM(CAST(pp.Goals AS INT))*4
--     +SUM(CAST(pp.Assists AS INT))*3
--     +SUM(CAST(pp.Recoveries AS INT))*0.5
--     +SUM(CAST(pp.Passes_Completed AS INT))*0.01)*90.0
--     /NULLIF(SUM(CAST(pp.Minutes_Played AS INT)),0)
-- ) AS DECIMAL(8,2)) AS Impact_Per_90
-- FROM PLAYERS p
-- JOIN PLAYER_PERFORMANCE pp ON pp.Player_ID=p.Player_ID
-- JOIN FIXTURES f ON f.Fixture_ID=pp.Fixture_ID
-- JOIN SEASONS s ON s.Season_ID=f.Season_ID
-- WHERE s.Season_Years='2021/22' AND ABS(CAST(f.Goals_For AS INT)-CAST(f.Goals_Against AS INT))>=2
-- GROUP BY p.First_Name,p.Last_Name
-- HAVING SUM(CAST(pp.Minutes_Played AS INT))>=180
-- ORDER BY Impact_Per_90 DESC,Minutes DESC;


-- -- Across 2021/22, what is our record by competition type (League/Cup/International)?
-- -- (uses UNION ALL so it returns one table with “All” + split by type)

-- SELECT 'All' AS Competition_Type,
-- COUNT(*) AS Games,SUM(Points_Secured) AS Points,
-- SUM(Goals_For) AS GF,SUM(Goals_Against) AS GA,
-- CAST(SUM(Points_Secured)*1.0/COUNT(*) AS DECIMAL(4,2)) AS PPG
-- FROM FIXTURES f
-- JOIN SEASONS s ON s.Season_ID=f.Season_ID
-- WHERE s.Season_Years='2021/22'
-- UNION ALL
-- SELECT c.Competition_Type,
-- COUNT(*) AS Games,SUM(f.Points_Secured) AS Points,
-- SUM(f.Goals_For) AS GF,SUM(f.Goals_Against) AS GA,
-- CAST(SUM(f.Points_Secured)*1.0/COUNT(*) AS DECIMAL(4,2)) AS PPG
-- FROM FIXTURES f
-- JOIN COMPETITIONS c ON c.Competition_ID=f.Competition_ID
-- JOIN SEASONS s ON s.Season_ID=f.Season_ID
-- WHERE s.Season_Years='2021/22'
-- GROUP BY c.Competition_Type
-- ORDER BY Competition_Type;


-- For 2021/22 fixtures, which 5 players had the best “matchday readiness”:
-- average of their last 3 training ratings BEFORE each fixture, compared to their match output?

-- SELECT TOP 5 p.First_Name,p.Last_Name,
-- CAST(AVG(x.PreMatch_Rating) AS DECIMAL(5,2)) AS Avg_PreMatch_Rating,
-- CAST(AVG(x.Match_Output) AS DECIMAL(6,2)) AS Avg_Match_Output,
-- CAST(AVG(x.Match_Output)/NULLIF(AVG(x.PreMatch_Rating),0) AS DECIMAL(6,2)) AS Efficiency_Index
-- FROM PLAYERS p
-- JOIN (
--     SELECT pp.Player_ID,
--     CAST((SELECT AVG(CAST(tr2.Rating AS DECIMAL(5,2))) FROM (
--         SELECT TOP 3 tr.Rating FROM TRAINING_RATING tr
--         JOIN TRAININGS t ON t.Training_ID=tr.Training_ID
--         WHERE tr.Player_ID=pp.Player_ID AND t.Training_Date<f.Fixture_Date
--         ORDER BY t.Training_Date DESC
--     ) tr2) AS DECIMAL(5,2)) AS PreMatch_Rating,
--     (pp.Goals*0.7+pp.Assists*0.6+pp.Recoveries) AS Match_Output
--     FROM PLAYER_PERFORMANCE pp
--     JOIN FIXTURES f ON f.Fixture_ID=pp.Fixture_ID
--     JOIN SEASONS s ON s.Season_ID=f.Season_ID
--     WHERE s.Season_Years='2021/22'
-- ) x ON x.Player_ID=p.Player_ID
-- GROUP BY p.First_Name,p.Last_Name
-- ORDER BY Efficiency_Index DESC;



-- In 2021/22, which referees were “worst for us” by points per game (all competitions),
-- with goals for/against under each referee?

-- SELECT f.Referee,
-- COUNT(*) AS Games,SUM(f.Points_Secured) AS Points,
-- CAST(SUM(f.Points_Secured)*1.0/COUNT(*) AS DECIMAL(4,2)) AS Points_Per_Game,
-- SUM(f.Goals_For) AS Goals_For,SUM(f.Goals_Against) AS Goals_Against,
-- SUM(f.Goals_For)-SUM(f.Goals_Against) AS Goal_Difference
-- FROM FIXTURES f
-- JOIN SEASONS s ON s.Season_ID=f.Season_ID
-- WHERE s.Season_Years='2021/22'
-- GROUP BY f.Referee
-- ORDER BY Points_Per_Game ASC,Goal_Difference ASC;


-- Which 5 players were the most “versatile” in 2021/22 (played in most distinct competitions),
-- and what were their total goal contributions?

-- SELECT TOP 5 p.First_Name,p.Last_Name,
-- COUNT(DISTINCT f.Competition_ID) AS Competitions_Played,
-- SUM(pp.Goals) AS Goals,SUM(pp.Assists) AS Assists,
-- SUM(pp.Goals+pp.Assists) AS Goal_Contributions
-- FROM PLAYERS p
-- JOIN PLAYER_PERFORMANCE pp ON pp.Player_ID=p.Player_ID
-- JOIN FIXTURES f ON f.Fixture_ID=pp.Fixture_ID
-- JOIN SEASONS s ON s.Season_ID=f.Season_ID
-- WHERE s.Season_Years='2021/22'
-- GROUP BY p.First_Name,p.Last_Name
-- ORDER BY Competitions_Played DESC,Goal_Contributions DESC;


-- Which players have the biggest injury burden overall (days injured),
-- and how does that relate to their average training rating?

-- SELECT p.First_Name,p.Last_Name,
-- SUM(DATEDIFF(day,i.Date_Incurred,i.Expected_Return_Date)) AS Days_Injured,
-- CAST(AVG(CAST(tr.Rating AS DECIMAL(5,2))) AS DECIMAL(5,2)) AS Avg_Training_Rating,
-- COUNT(DISTINCT i.Injury_ID) AS Injury_Count
-- FROM PLAYERS p
-- LEFT JOIN INJURIES i ON i.Player_ID=p.Player_ID
-- LEFT JOIN TRAINING_RATING tr ON tr.Player_ID=p.Player_ID
-- GROUP BY p.First_Name,p.Last_Name
-- HAVING SUM(DATEDIFF(day,i.Date_Incurred,i.Expected_Return_Date)) IS NOT NULL
-- ORDER BY Days_Injured DESC,Injury_Count DESC;


-- Which 5 players gave the best value-for-money in 2021/22 (impact per salary),
-- using only matches from that season (all competitions)?

SELECT TOP 5 p.First_Name,p.Last_Name,ct.Salary,
CAST((SUM(pp.Goals)*4+SUM(pp.Assists)*3+SUM(pp.Recoveries)*0.5+SUM(pp.Passes_Completed)*0.01) AS DECIMAL(10,2)) AS Impact,
CAST((SUM(pp.Goals)*4+SUM(pp.Assists)*3+SUM(pp.Recoveries)*0.5+SUM(pp.Passes_Completed)*0.01)/NULLIF(ct.Salary,0) AS DECIMAL(12,8)) AS Value_Index
FROM PLAYERS p
JOIN CONTRACTS ct ON ct.Player_ID=p.Player_ID
JOIN PLAYER_PERFORMANCE pp ON pp.Player_ID=p.Player_ID
JOIN FIXTURES f ON f.Fixture_ID=pp.Fixture_ID
JOIN SEASONS s ON s.Season_ID=f.Season_ID
WHERE s.Season_Years='2021/22'
GROUP BY p.First_Name,p.Last_Name,ct.Salary
ORDER BY Value_Index DESC,Impact DESC;
