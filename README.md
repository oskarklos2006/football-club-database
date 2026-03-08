# ⚽ Football Club Player Management Database

A relational database system designed for a professional football club's Sporting Director, coaches, data analysts and scouts. The database tracks player development, match performance, training, injuries, contracts, transfers and loans across multiple seasons.

---

## 📌 Overview

The system centralises all player-related data into one structured database, making it easier for club staff to monitor player growth, evaluate form, track injuries and prepare reports for management.

**Designed for:**
- Sporting Directors — transfer and contract decisions
- Coaches — training evaluation and match readiness
- Data Analysts — performance trends and impact scoring
- Scouts — player development tracking

---

## 🗄️ Database Schema

The database contains **15 tables** with full referential integrity:

| Table | Description |
|---|---|
| `PLAYERS` | Core player information and market value |
| `PLAYER_PERFORMANCE` | Match-level statistics per player |
| `PLAYER_SEASONS_SUMMARY` | Season totals per player |
| `FIXTURES` | Match results and metadata |
| `COMPETITIONS` | League, cup and international competitions |
| `SEASONS` | Season date ranges and labels |
| `RIVAL_CLUBS` | Opponent clubs from various leagues |
| `OWN_TEAMS` | Internal squads and training groups |
| `TRAININGS` | Training sessions with focus areas |
| `TRAINING_RATING` | Coach evaluations of players in training |
| `CONTRACTS` | Player salary and contract periods |
| `INJURIES` | Injury records and return-to-play dates |
| `PLAYER_FITNESS_TESTS` | Physical test results |
| `LOANS` | Temporary player loan agreements |
| `TRANSFERS` | Permanent player transfer records |

---

## 📁 File Structure

```
football-club-database/
├── CREATE_TABLE.sql       # Full schema with constraints and foreign keys
├── INSERT_TO.sql          # Sample data (Chelsea squad, fixtures, seasons)
├── DROP_TABLE.sql         # Clean drop script in correct dependency order
├── CONSTRAINS.sql         # Constraint testing and verification scripts
├── QUERIES.sql            # 9 advanced analytical queries
├── use_case_1a.sql        # Recording a match with player performances
├── use_case_1b.sql        # Reading match data (isolation level demo)
├── use_case_2a.sql        # Season summary aggregation (SERIALIZABLE)
├── use_case_2b.sql        # Concurrent insert during aggregation
├── use_case_3a.sql        # Read-only training reports (READ UNCOMMITTED)
├── use_case_3b.sql        # Updating training ratings with rollback
├── use_case_4a.sql        # Reading contract salary (READ COMMITTED)
├── use_case_4b.sql        # Updating contract salary concurrently
└── use_cases.txt          # Explanation of isolation levels per use case
```

---

## 🔍 Sample Analytical Queries

The `QUERIES.sql` file contains 9 advanced queries including:

- **Impact Score** — top 5 players by goals, assists, recoveries and passes combined with training rating and salary
- **Toughest Opponents** — clubs with lowest points-per-game against us
- **Goal Contribution Share** — each player's % of total team goals + assists
- **Big Game Performers** — impact per 90 minutes in matches with 2+ goal difference
- **Matchday Readiness** — average of last 3 training ratings before each fixture vs match output
- **Worst Referees** — referees associated with lowest points-per-game
- **Versatility Index** — players who appeared in most distinct competitions
- **Injury Burden** — days injured vs average training rating
- **Value for Money** — impact score per salary unit

---

## 🔒 Transaction Isolation Use Cases

The project includes 4 transaction scenarios demonstrating different SQL Server isolation levels:

| Use Case | Scenario | Isolation Level |
|---|---|---|
| 1 | Recording a match + player performances | READ UNCOMMITTED |
| 2 | Finalising season summary aggregations | SERIALIZABLE |
| 3 | Analytical read-only reporting | READ UNCOMMITTED |
| 4 | Updating player contract salary | READ COMMITTED |

---

## 🔧 Tech Stack

- **Database:** Microsoft SQL Server
- **Language:** T-SQL
- **Features:** Primary keys, foreign keys, CHECK constraints, transactions, isolation levels, aggregations, subqueries, JOINs, UNION ALL, window functions

---

## 🚀 How to Run

1. Open **SQL Server Management Studio (SSMS)**
2. Run `CREATE_TABLE.sql` to create all tables
3. Run `INSERT_TO.sql` to populate with sample data
4. Run `QUERIES.sql` to execute analytical queries
5. Use `DROP_TABLE.sql` to reset the database if needed

---

## 👤 Author

**Oskar Klos**  
[GitHub](https://github.com/oskarklos2006)
