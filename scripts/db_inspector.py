import argparse
import mysql.connector
from mysql.connector import errorcode


def inspect_database(user, password, database):
    try:
        cnx = mysql.connector.connect(user=user, password=password, host="127.0.0.1", port=3306, database=database)
        cursor = cnx.cursor()

        cursor.execute("SHOW TABLES")
        tables = cursor.fetchall()
        print("\nTables in database:")
        for table in tables:
            print(" -", table[0])

        print("\nRow counts for each table:")
        for table in tables:
            table_name = table[0]
            cursor.execute(f"SELECT COUNT(*) FROM `{table_name}`")
            count = cursor.fetchone()[0]
            print(f"  {table_name:20s}: {count}")

        sample_tables = ['projects', 'metricNames', 'metricValues']
        for table_name in sample_tables:
            print(f"\nSample data from '{table_name}':")
            cursor.execute(f"SELECT * FROM `{table_name}` LIMIT 5")
            for row in cursor.fetchall():
                print(row)

        cursor.close()
        cnx.close()
    except mysql.connector.Error as err:
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Access denied: Check your username or password.")
        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("Database does not exist.")
        else:
            print(err)
        exit(1)


def main():
    parser = argparse.ArgumentParser(description="Load and inspect the 'metryki' database in a Docker container.")
    parser.add_argument("--user", default="root", help="MySQL username")
    parser.add_argument("--password", default="rootpass", help="MySQL password")
    parser.add_argument("--host", default="127.0.0.1", help="MySQL host")
    parser.add_argument("--database", default="metryki", help="Database name")
    parser.add_argument("--load-dump", help="Path to SQL dump file to load (optional)")
    args = parser.parse_args()

    inspect_database(args.user, args.password, args.database)


if __name__ == "__main__":
    main()