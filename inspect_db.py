
import sqlite3
from pathlib import Path

DB_PATH = Path(__file__).resolve().parent / "aegisflow.db"

if not DB_PATH.exists():
    raise FileNotFoundError(f"Database not found: {DB_PATH}")

with sqlite3.connect(DB_PATH) as conn:
    conn.row_factory = sqlite3.Row

    tables = conn.execute("""
        SELECT name
        FROM sqlite_master
        WHERE type = 'table'
        AND name NOT LIKE 'sqlite_%'
        ORDER BY name
    """).fetchall()

    print(f"Database: {DB_PATH}")
    print("\n=== TABLES ===")

    for table_row in tables:
        table = table_row["name"]

        # Table names come from SQLite's own table listing.
        quoted_table = '"' + table.replace('"', '""') + '"'

        print(f"\n--- {table} ---")

        columns = conn.execute(
            f"PRAGMA table_info({quoted_table})"
        ).fetchall()

        print("Columns:")
        for column in columns:
            print(
                f"  {column['name']} | "
                f"type={column['type']} | "
                f"not_null={column['notnull']} | "
                f"primary_key={column['pk']}"
            )

        count = conn.execute(
            f"SELECT COUNT(*) FROM {quoted_table}"
        ).fetchone()[0]

        print(f"Row count: {count}")

    print("\nInspection complete. No data was modified.")
