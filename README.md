# Praca Naukowa: Porownanie Analizatorow Statycznych

## 📊 Database Setup and Analysis

To run the database, load metrics data, and analyze it: 

1. Start the MySQL database container:
   ```sh
   docker compose -f scripts/docker-compose.yml up -d --force-recreate
   ```

2. Load the metrics database schema:
   ```sh
   docker exec -i mysql-local mysql -uroot -prootpass metryki < src/sql/metryki.sql
   ```

3. Inspect the database tables and sample data:
   ```sh
   python scripts/db_inspector.py
   ```

4. When finished, stop the database container:
   ```sh
   docker compose -f scripts/docker-compose.yml down
   ```

## 📚 Links
- [Journal formatting rules](https://www.e-informatyka.pl/index.php/einformatica/authors-guide/paper-requirements-and-recommendations/)
