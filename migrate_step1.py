
import sqlite3
from pathlib import Path

DB_PATH = Path(__file__).resolve().parent / "aegisflow.db"

NEW_COLUMNS = {
    "locality": "TEXT",
    "hazard_type": "TEXT",
    "street_address": "TEXT",
    "landmark": "TEXT",
    "specific_details": "TEXT",
}

def migrate():
    if not DB_PATH.exists():
        raise FileNotFoundError(f"Database not found: {DB_PATH}")

    conn = sqlite3.connect(DB_PATH, timeout=10)
    conn.row_factory = sqlite3.Row

    try:
        conn.execute("PRAGMA foreign_keys = ON")
        conn.execute("BEGIN IMMEDIATE")

        # Confirm the expected tables exist before making changes.
        tables = {
            row["name"]
            for row in conn.execute("""
                SELECT name
                FROM sqlite_master
                WHERE type = 'table'
            """)
        }

        if not {"users", "incidents"}.issubset(tables):
            raise RuntimeError(
                "Expected users and incidents tables were not found."
            )

        # Capture existing records so we can verify they remain unchanged.
        before_count = conn.execute(
            "SELECT COUNT(*) FROM incidents"
        ).fetchone()[0]

        before_keys = conn.execute("""
            SELECT id, ticket_id
            FROM incidents
            ORDER BY id
        """).fetchall()

        before_users = conn.execute(
            "SELECT COUNT(*) FROM users"
        ).fetchone()[0]

        existing_columns = {
            row["name"]
            for row in conn.execute(
                "PRAGMA table_info(incidents)"
            )
        }

        # Add only missing columns. Existing columns and records stay intact.
        for column, sql_type in NEW_COLUMNS.items():
            if column not in existing_columns:
                conn.execute(
                    f'ALTER TABLE incidents ADD COLUMN "{column}" {sql_type}'
                )
                print(f"Added incidents.{column}")
            else:
                print(f"Already exists: incidents.{column}")

        # Backfill only the new descriptive fields when they are empty.
        # Keep the original location and description columns unchanged.
        conn.execute("""
            UPDATE incidents
            SET locality = location
            WHERE locality IS NULL OR TRIM(locality) = ''
        """)

        conn.execute("""
            UPDATE incidents
            SET specific_details = description
            WHERE (specific_details IS NULL
                   OR TRIM(specific_details) = '')
              AND description IS NOT NULL
        """)

        # Verify the original records were preserved.
        after_count = conn.execute(
            "SELECT COUNT(*) FROM incidents"
        ).fetchone()[0]

        after_keys = conn.execute("""
            SELECT id, ticket_id
            FROM incidents
            ORDER BY id
        """).fetchall()

        after_users = conn.execute(
            "SELECT COUNT(*) FROM users"
        ).fetchone()[0]

        if before_count != after_count:
            raise RuntimeError(
                "Incident count changed; rolling back migration."
            )

        if [tuple(r) for r in before_keys] != [
            tuple(r) for r in after_keys
        ]:
            raise RuntimeError(
                "Incident IDs or ticket IDs changed; rolling back."
            )

        if before_users != after_users:
            raise RuntimeError(
                "User count changed; rolling back migration."
            )

        conn.commit()

        print("\nMigration completed successfully.")
        print(f"Incidents preserved: {after_count}")
        print(f"Users preserved: {after_users}")
        print("Existing IDs and ticket IDs verified.")
        print("Users table and authentication fields were not modified.")

    except Exception:
        conn.rollback()
        print("\nMigration failed. Database changes were rolled back.")
        raise

    finally:
        conn.close()


if __name__ == "__main__":
    migrate()
