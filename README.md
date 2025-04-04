# Praca Naukowa: Porownanie Analizatorow Statycznych

## 📊 Database Setup and Analysis

### Prerequisites
- [Python 3.12+](https://www.python.org/downloads/)
- [Docker](https://docs.docker.com/engine/install/)

### Setup

1. Install Python dependencies:
   ```sh
   pip install -r requirements.txt
   ```

2. Start the MySQL database container:
   ```sh
   docker compose -f scripts/docker-compose.yml up -d --force-recreate
   ```

3. Load the metrics database schema:
   ```sh
   docker exec -i mysql-local mysql -uroot -prootpass metryki < src/sql/metryki.sql
   ```

4. Load additional views and functions:
   ```sh
   docker exec -i mysql-local mysql -uroot -prootpass metryki < src/sql/views.sql
   docker exec -i mysql-local mysql -uroot -prootpass metryki < src/sql/usefulViewsAndFunctions.sql
   docker exec -i mysql-local mysql -uroot -prootpass metryki < src/sql/consolidationMigrations.sql
   ```

5. Inspect the database tables and sample data:
   ```sh
   python scripts/db_inspector.py
   ```

   You can also run custom SQL queries:
   ```sh
   python scripts/db_inspector.py --query "SELECT * FROM measurementsPerMetricAndLanguage LIMIT 10"
   ```

6. To clear the database if needed:
   ```sh
   docker exec -i mysql-local mysql -uroot -prootpass metryki < src/sql/clear_database.sql
   ```

7. When finished, stop the database container:
   ```sh
   docker compose -f scripts/docker-compose.yml down
   ```

## 📚 Links
- [Journal formatting rules](https://www.e-informatyka.pl/index.php/einformatica/authors-guide/paper-requirements-and-recommendations/)
