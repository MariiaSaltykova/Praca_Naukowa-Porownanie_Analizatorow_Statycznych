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

4. Inspect the database tables and sample data:
   ```sh
   python scripts/db_inspector.py
   ```

5. When finished, stop the database container:
   ```sh
   docker compose -f scripts/docker-compose.yml down
   ```

## 📚 Links
- [Journal formatting rules](https://www.e-informatyka.pl/index.php/einformatica/authors-guide/paper-requirements-and-recommendations/)
