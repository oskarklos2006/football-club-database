SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

BEGIN TRANSACTION;

INSERT INTO FIXTURES
(Referee, Goals_For, Goals_Against, Points_Secured, Fixture_Date, Competition_ID, Club_ID, Season_ID)
VALUES
('TX1 Ref', 2, 1, 3, SYSDATETIME(), 1, 1, 9);

DECLARE @FixtureId SMALLINT = SCOPE_IDENTITY();

WAITFOR DELAY '00:00:10';

INSERT INTO PLAYER_PERFORMANCE
(Distance_Covered, Goals, Assists, Minutes_Played, Recoveries,
 Yellow_Cards, Red_Cards, Passes_Completed, Player_ID, Fixture_ID)
VALUES
(9.5, 1, 0, 90, 5, 0, 0, 40, 1, @FixtureId);

COMMIT;
