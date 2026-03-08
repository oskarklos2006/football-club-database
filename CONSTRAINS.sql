-- Step 1: check current team of player 1
--SELECT Player_ID, First_Name, Group_ID FROM PLAYERS WHERE Player_ID = 1;

-- Step 2: insert a temporary team (has no children in other tables)
--INSERT INTO OWN_TEAMS (Group_Name, Coach_Name)
--VALUES ('TempGroup','TempCoach');

-- Step 3: assign player 1 to that temporary team
--UPDATE PLAYERS 
--SET Group_ID = (SELECT Group_ID FROM OWN_TEAMS WHERE Group_Name='TempGroup')
--WHERE Player_ID = 1;

-- Step 4: verify player is linked to TempGroup
--SELECT Player_ID, First_Name, Group_ID FROM PLAYERS WHERE Player_ID = 1;

-- Step 5: delete the temporary team (SET NULL should activate)
--DELETE FROM OWN_TEAMS
--WHERE Group_Name='TempGroup';

-- Step 6: check if player now has NULL as Group_ID
--SELECT Player_ID, First_Name, Group_ID FROM PLAYERS WHERE Player_ID = 1;
