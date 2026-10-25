import sqlite3
from pathlib import Path
from server import pwd_context

DB_PATH = Path(__file__).resolve().parent / "aegisflow.db"

officers = [
    {
        "name": "S. Murugan, JE",
        "email": "murugan.officer@gcc.gov.in",
        "password": "admin123",
        "role": "municipal",
        "phone": "+91 94440 67890",
        "ward": "Madipakkam Lake Basin (Ward 188)",
        "department": "Engineering",
        "status": "Active",
        "is_on_duty": 1,
        "is_available": 1,
        "latitude": None,
        "longitude": None,
    },
    {
        "name": "M. Kumar, AE",
        "email": "kumar.officer@gcc.gov.in",
        "password": "admin123",
        "role": "municipal",
        "phone": "+91 94440 54321",
        "ward": "Taramani IT Corridor (Ward 179)",
        "department": "Engineering",
        "status": "Active",
        "is_on_duty": 1,
        "is_available": 1,
        "latitude": None,
        "longitude": None,
    },
]

conn = sqlite3.connect(DB_PATH, timeout=15)

try:
    conn.execute("BEGIN IMMEDIATE")

    existing = conn.execute(
        "SELECT email FROM users WHERE email IN (?, ?) COLLATE NOCASE",
        (officers[0]["email"], officers[1]["email"]),
    ).fetchall()

    if existing:
        raise RuntimeError(
            "Insertion cancelled. One or more officer emails already exist: "
            + ", ".join(row[0] for row in existing)
        )

    initial_count = conn.execute(
        "SELECT COUNT(*) FROM users"
    ).fetchone()[0]

    for officer in officers:
        password_hash = pwd_context.hash(officer.pop("password"))

        conn.execute(
            """
            INSERT INTO users (
                name, email, password_hash, role, phone, ward,
                department, status, is_on_duty, is_available,
                latitude, longitude
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """,
            (
                officer["name"],
                officer["email"],
                password_hash,
                officer["role"],
                officer["phone"],
                officer["ward"],
                officer["department"],
                officer["status"],
                officer["is_on_duty"],
                officer["is_available"],
                officer["latitude"],
                officer["longitude"],
            ),
        )

    final_count = conn.execute(
        "SELECT COUNT(*) FROM users"
    ).fetchone()[0]

    if final_count != initial_count + 2:
        raise RuntimeError("Unexpected user count; transaction will be rolled back.")

    conn.commit()
    print("SUCCESS: Both municipal officers were inserted.")
    print(f"Users before: {initial_count}")
    print(f"Users after:  {final_count}")

except Exception as exc:
    conn.rollback()
    print(f"FAILED: {exc}")
    print("Transaction rolled back; no partial insertion was committed.")
    raise

finally:
    conn.close()
