--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

BEGIN TRANSACTION;

SELECT
    COUNT(*) AS Appearances,
    SUM(pp.Goals) AS Goals,
    SUM(pp.Minutes_Played) AS Minutes
FROM PLAYER_PERFORMANCE pp
JOIN FIXTURES f ON f.Fixture_ID = pp.Fixture_ID
WHERE f.Season_ID = 9
  AND pp.Player_ID = 1;

WAITFOR DELAY '00:00:10';

SELECT
    COUNT(*) AS Appearances,
    SUM(pp.Goals) AS Goals,
    SUM(pp.Minutes_Played) AS Minutes
FROM PLAYER_PERFORMANCE pp
JOIN FIXTURES f ON f.Fixture_ID = pp.Fixture_ID
WHERE f.Season_ID = 9
  AND pp.Player_ID = 1;

COMMIT;
