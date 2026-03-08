CREATE TABLE COMPETITIONS (
    Competition_ID TINYINT IDENTITY(1,1) PRIMARY KEY,
    Competition_Name VARCHAR(50) NOT NULL,
    Competition_Type VARCHAR(20) NOT NULL,
    CHECK (Competition_Name <> ''),
    CHECK (Competition_Type IN ('League','Cup','International'))
)

CREATE TABLE RIVAL_CLUBS(
    CLUB_ID SMALLINT IDENTITY(1,1) PRIMARY KEY,
    Club_Name VARCHAR(50) NOT NULL,
    Country VARCHAR(50) NOT NULL,
    League VARCHAR(50) NOT NULL,
    CHECK (Club_Name <> ''),
    CHECK (Country <> ''),
    CHECK (League <> '')
)

CREATE TABLE OWN_TEAMS (
    Group_ID TINYINT IDENTITY(1,1) PRIMARY KEY,
    Group_Name VARCHAR(50) NOT NULL,
    Coach_Name VARCHAR (50) NOT NULL,
    CHECK (Group_Name <> ''),
    CHECK (Coach_Name <> '')
)

CREATE TABLE PLAYERS (
    Player_ID SMALLINT IDENTITY(1,1) PRIMARY KEY,
    First_Name VARCHAR(40) NOT NULL,
    Last_Name VARCHAR(40) NOT NULL,
    Player_Value DECIMAL(5,2) NULL,
    Group_ID TINYINT NULL,
    CHECK (Player_Value > 0),
    CHECK (LEN(First_Name) BETWEEN 2 AND 40),
    CHECK (LEN(Last_Name) BETWEEN 2 AND 40),
    FOREIGN KEY (Group_ID) REFERENCES OWN_TEAMS(Group_ID)
        ON DELETE SET NULL
)

CREATE TABLE SEASONS
(
    Season_ID SMALLINT IDENTITY(1,1) PRIMARY KEY,
    Start_Date DATE NOT NULL,
    End_Date DATE NOT NULL,
    Season_Years VARCHAR(9) NOT NULL,
    CHECK (Start_Date < End_Date),
    CHECK (Season_Years LIKE '[0-9][0-9][0-9][0-9]/[0-9][0-9]')
)


CREATE TABLE FIXTURES
(
    Fixture_ID SMALLINT IDENTITY(1,1) PRIMARY KEY,
    Referee VARCHAR(50) NOT NULL,
    Goals_For TINYINT NOT NULL,
    Goals_Against TINYINT NOT NULL,
    Points_Secured TINYINT NOT NULL,
    Fixture_Date DATETIME2 NOT NULL,
    Competition_ID TINYINT NOT NULL,
    Club_ID SMALLINT NOT NULL,
    Season_ID SMALLINT NOT NULL,
    CHECK (Goals_For BETWEEN 0 AND 30),
    CHECK (Goals_Against BETWEEN 0 AND 30),
    CHECK (Points_Secured BETWEEN 0 AND 3),
    FOREIGN KEY (Competition_ID) REFERENCES COMPETITIONS(Competition_ID)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    FOREIGN KEY (Club_ID) REFERENCES RIVAL_CLUBS(Club_ID)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    FOREIGN KEY (Season_ID) REFERENCES SEASONS(Season_ID)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
)

CREATE TABLE PLAYER_PERFORMANCE
(
    Player_Performance_ID SMALLINT IDENTITY(1,1) PRIMARY KEY,
    Distance_Covered DECIMAL(4,1) NOT NULL,
    Goals TINYINT NOT NULL,
    Assists TINYINT NOT NULL,
    Minutes_Played TINYINT NOT NULL,
    Recoveries TINYINT NOT NULL,
    Yellow_Cards TINYINT NOT NULL,
    Red_Cards TINYINT NOT NULL,
    Passes_Completed SMALLINT NOT NULL,
    Player_ID SMALLINT NULL,
    Fixture_ID SMALLINT NOT NULL,
    CHECK (Distance_Covered BETWEEN 0 AND 50),
    CHECK (Goals BETWEEN 0 AND 10),
    CHECK (Assists BETWEEN 0 AND 10),
    CHECK (Minutes_Played BETWEEN 0 AND 120),
    CHECK (Recoveries BETWEEN 0 AND 100),
    CHECK (Yellow_Cards BETWEEN 0 AND 2),
    CHECK (Red_Cards BETWEEN 0 AND 1),
    CHECK (Passes_Completed BETWEEN 0 AND 1000),
    FOREIGN KEY (Player_ID) REFERENCES PLAYERS(Player_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY (Fixture_ID) REFERENCES FIXTURES(Fixture_ID)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
)

CREATE TABLE PLAYER_SEASONS_SUMMARY
(
    Player_Summary_ID SMALLINT IDENTITY(1,1) PRIMARY KEY,
    Total_Appearances TINYINT NOT NULL,
    Total_Goals TINYINT NOT NULL,
    Total_Assists TINYINT NOT NULL,
    Total_Minutes_Played SMALLINT NOT NULL,
    Total_Recoveries SMALLINT NOT NULL,
    Total_Yellow_Cards TINYINT NOT NULL,
    Total_Red_Cards TINYINT NOT NULL,
    Total_Passes_Completed SMALLINT NOT NULL,
    Player_ID SMALLINT NULL,
    Season_ID SMALLINT NOT NULL,
    CHECK (Total_Appearances >= 0),
    CHECK (Total_Goals >= 0),
    CHECK (Total_Assists >= 0),
    CHECK (Total_Minutes_Played >= 0),
    CHECK (Total_Recoveries >= 0),
    CHECK (Total_Yellow_Cards >= 0),
    CHECK (Total_Red_Cards >= 0),
    CHECK (Total_Passes_Completed >= 0),
    FOREIGN KEY (Player_ID) REFERENCES PLAYERS(Player_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY (Season_ID) REFERENCES SEASONS(Season_ID)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
)

CREATE TABLE TRAININGS
(
    Training_ID SMALLINT IDENTITY(1,1) PRIMARY KEY,
    Training_Date DATETIME2 NOT NULL,
    Focus VARCHAR(50) NOT NULL,
    Group_ID TINYINT NOT NULL,
    CHECK (Focus <> ''),
    FOREIGN KEY (Group_ID) REFERENCES OWN_TEAMS(Group_ID)
        ON DELETE NO ACTION
        ON UPDATE CASCADE
)

CREATE TABLE TRAINING_RATING
(
    Training_Rating_ID SMALLINT IDENTITY(1,1) PRIMARY KEY,
    Rating TINYINT NOT NULL,
    Coach_Notes VARCHAR(250) NULL,
    Training_ID SMALLINT NOT NULL,
    Player_ID SMALLINT NULL,
    CHECK (Rating BETWEEN 1 AND 10),
    FOREIGN KEY (Training_ID) REFERENCES TRAININGS(Training_ID)
        ON DELETE NO ACTION
        ON UPDATE CASCADE,
    FOREIGN KEY (Player_ID) REFERENCES PLAYERS(Player_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
)

CREATE TABLE CONTRACTS
(
    Contract_ID SMALLINT IDENTITY(1,1) PRIMARY KEY,
    Start_Date DATE NOT NULL,
    End_Date DATE NOT NULL,
    Salary DECIMAL(15,2) NOT NULL,
    Player_ID SMALLINT NULL,
    CHECK (Salary > 0),
    FOREIGN KEY (Player_ID) REFERENCES PLAYERS(Player_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
)

CREATE TABLE INJURIES
(
    Injury_ID SMALLINT IDENTITY(1,1) PRIMARY KEY,
    Injury_Type VARCHAR(50) NOT NULL,
    Date_Incurred DATE NOT NULL,
    Expected_Return_Date DATE NOT NULL,
    Player_ID SMALLINT NULL,
    CHECK (Injury_Type <> ''),
    FOREIGN KEY (Player_ID) REFERENCES PLAYERS(Player_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
)

CREATE TABLE PLAYER_FITNESS_TESTS
(
    Fitness_Test_ID SMALLINT IDENTITY(1,1) PRIMARY KEY,
    Test_Date DATETIME2 NOT NULL,
    Test_Type VARCHAR(50) NOT NULL,
    Result VARCHAR(50) NOT NULL,
    Player_ID SMALLINT NULL,
    CHECK (Test_Type <> ''),
    CHECK (Result <> ''),
    FOREIGN KEY (Player_ID) REFERENCES PLAYERS(Player_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
)

CREATE TABLE LOANS
(
    Loan_ID SMALLINT IDENTITY(1,1) PRIMARY KEY,
    Loan_Start_Date DATE NOT NULL,
    Loan_End_Date DATE NOT NULL,
    Loan_Fee DECIMAL(15,2) NOT NULL,
    Player_ID SMALLINT NULL,
    Club_ID SMALLINT NULL,
    CHECK (Loan_Fee >= 0),
    FOREIGN KEY (Player_ID) REFERENCES PLAYERS(Player_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY (Club_ID) REFERENCES RIVAL_CLUBS(Club_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
)

CREATE TABLE TRANSFERS
(
    Transfer_ID SMALLINT IDENTITY(1,1) PRIMARY KEY,
    Transfer_Start_Date DATE NOT NULL,
    Transfer_End_Date DATE NOT NULL,
    Transfer_Fee DECIMAL(15,2) NOT NULL,
    Player_ID SMALLINT NULL,
    Club_ID SMALLINT NULL,
    CHECK (Transfer_Fee >= 0),
    FOREIGN KEY (Player_ID) REFERENCES PLAYERS(Player_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY (Club_ID) REFERENCES RIVAL_CLUBS(Club_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
)







