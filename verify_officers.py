import sqlite3

conn = sqlite3.connect("aegisflow.db")
conn.row_factory = sqlite3.Row

print("TOTAL USERS:", conn.execute(
    "SELECT COUNT(*) FROM users"
).fetchone()[0])

rows = conn.execute("""
    SELECT id, name, email, role, ward, status,
           is_on_duty, is_available
    FROM users
    ORDER BY id
""").fetchall()

print("\nUSER DETAILS:")
for row in rows:
    print(dict(row))

print("\nINCIDENT COUNT:", conn.execute(
    "SELECT COUNT(*) FROM incidents"
).fetchone()[0])

conn.close()
