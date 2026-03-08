BEGIN TRANSACTION;

INSERT INTO PLAYER_PERFORMANCE
(Distance_Covered, Goals, Assists, Minutes_Played, Recoveries,
 Yellow_Cards, Red_Cards, Passes_Completed, Player_ID, Fixture_ID)
SELECT
10.0, 1, 0, 90, 5, 0, 0, 30, 1,
(SELECT TOP 1 Fixture_ID FROM FIXTURES WHERE Season_ID = 9);

COMMIT;
