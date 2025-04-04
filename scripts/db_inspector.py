import argparse
import mysql.connector
from mysql.connector import errorcode
from tabulate import tabulate


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
            rows = cursor.fetchall()
            if rows:
                # Get column names
                column_names = [desc[0] for desc in cursor.description]
                print(tabulate(rows, headers=column_names, tablefmt="grid"))
            else:
                print("No data found.")

        # Check if our views exist
        print("\nChecking custom views:")
        views = [
            "licenses_with_tools", 
            "metric_values_with_connections", 
            "projects_with_metrics", 
            "used_metric_definitions",
            "measurementsPerMetricAndLanguage",
            "doubleMetricValues"
        ]
        
        for view in views:
            try:
                cursor.execute(f"SELECT COUNT(*) FROM `{view}`")
                count = cursor.fetchone()[0]
                print(f"  {view:30s}: {count} rows available")
            except mysql.connector.Error:
                print(f"  {view:30s}: Not available (view not created)")

        print("\n=== ANALYSIS EXAMPLES ===")
        
        # Example 1: Get metrics per language statistics
        print("\n1. Measurements per metric and language:")
        try:
            cursor.execute("""
                SELECT metricName, languageName, amount 
                FROM measurementsPerMetricAndLanguage 
                ORDER BY amount DESC
                LIMIT 10
            """)
            rows = cursor.fetchall()
            if rows:
                headers = ["Metric", "Language", "Measurement Count"]
                print(tabulate(rows, headers=headers, tablefmt="grid"))
            else:
                print("No data found.")
        except mysql.connector.Error as err:
            print(f"Error executing query: {err}")

        # Example 2: Get projects with most metrics
        print("\n2. Top projects with metrics:")
        try:
            cursor.execute("""
                SELECT p.projectName, COUNT(mv.uniqueID) as metricCount
                FROM projects p
                JOIN metricValues mv ON p.uniqueID = mv.projectID
                GROUP BY p.uniqueID
                ORDER BY metricCount DESC
                LIMIT 10
            """)
            rows = cursor.fetchall()
            if rows:
                headers = ["Project Name", "Metric Count"]
                print(tabulate(rows, headers=headers, tablefmt="grid"))
            else:
                print("No data found.")
        except mysql.connector.Error as err:
            print(f"Error executing query: {err}")

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


def run_custom_query(user, password, database, query):
    try:
        cnx = mysql.connector.connect(user=user, password=password, host="127.0.0.1", port=3306, database=database)
        cursor = cnx.cursor()
        
        cursor.execute(query)
        rows = cursor.fetchall()
        
        if rows:
            # Get column names
            column_names = [desc[0] for desc in cursor.description]
            print(tabulate(rows, headers=column_names, tablefmt="grid"))
        else:
            print("Query returned no results.")
            
        cursor.close()
        cnx.close()
    except mysql.connector.Error as err:
        print(f"Error executing query: {err}")
        exit(1)


def main():
    parser = argparse.ArgumentParser(description="Load and inspect the 'metryki' database in a Docker container.")
    parser.add_argument("--user", default="root", help="MySQL username")
    parser.add_argument("--password", default="rootpass", help="MySQL password")
    parser.add_argument("--host", default="127.0.0.1", help="MySQL host")
    parser.add_argument("--database", default="metryki", help="Database name")
    parser.add_argument("--query", help="Run a custom SQL query")
    args = parser.parse_args()

    if args.query:
        run_custom_query(args.user, args.password, args.database, args.query)
    else:
        inspect_database(args.user, args.password, args.database)


if __name__ == "__main__":
    main()