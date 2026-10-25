import sqlite3

conn = sqlite3.connect("aegisflow.db")
row = conn.execute(
    "SELECT sql FROM sqlite_master WHERE type='table' AND name='users'"
).fetchone()

print(row[0] if row else "Users table not found")
conn.close()
