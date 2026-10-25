
import os
import math
import sqlite3
import secrets
from contextlib import asynccontextmanager
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Literal, Optional

import jwt
from passlib.context import CryptContext
from fastapi import (
    Depends,
    FastAPI,
    HTTPException,
    Query,
    status,
)
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from pydantic import BaseModel, EmailStr, Field, field_validator


# ============================================================
# CONFIGURATION
# ============================================================

BASE_DIR = Path(__file__).resolve().parent
DB_PATH = BASE_DIR / "aegisflow.db"

JWT_SECRET_KEY = os.getenv(
    "AEGISFLOW_JWT_SECRET",
    "DEV-ONLY-CHANGE-THIS-SECRET-BEFORE-DEPLOYMENT",
)
JWT_ALGORITHM = "HS256"
JWT_EXPIRE_MINUTES = int(
    os.getenv("AEGISFLOW_JWT_EXPIRE_MINUTES", "60")
)

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
bearer_scheme = HTTPBearer(auto_error=False)

OFFICIAL_DOMAINS = {"gcc.gov.in", "tn.gov.in"}

DEFAULT_ENGINEER_LAT = 12.9750
DEFAULT_ENGINEER_LON = 80.2200


# ============================================================
# DATABASE
# ============================================================

def get_db():
    """Yield a SQLite connection and always close it."""
    conn = sqlite3.connect(
        str(DB_PATH),
        timeout=15,
    )
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON")
    conn.execute("PRAGMA busy_timeout = 15000")

    try:
        yield conn
    finally:
        conn.close()


def initialize_database():
    """Create the schema and seed initial development accounts."""
    conn = sqlite3.connect(str(DB_PATH), timeout=15)
    conn.row_factory = sqlite3.Row

    try:
        conn.execute("PRAGMA foreign_keys = ON")
        conn.execute("PRAGMA journal_mode = WAL")

        conn.executescript("""
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                email TEXT UNIQUE NOT NULL COLLATE NOCASE,
                password_hash TEXT NOT NULL,
                role TEXT NOT NULL
                    CHECK(role IN ('citizen', 'municipal')),
                phone TEXT,
                ward TEXT,
                department TEXT,
                status TEXT DEFAULT 'Active',
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

                -- Operational fields used for officer routing.
                is_on_duty INTEGER NOT NULL DEFAULT 0,
                is_available INTEGER NOT NULL DEFAULT 0,
                latitude REAL,
                longitude REAL
            );

            CREATE TABLE IF NOT EXISTS incidents (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                ticket_id TEXT UNIQUE NOT NULL,
                citizen_name TEXT NOT NULL,
                citizen_phone TEXT,
                location TEXT NOT NULL,
                coords TEXT NOT NULL,
                severity TEXT NOT NULL,
                description TEXT,
                assigned_officer_id INTEGER,
                status TEXT DEFAULT 'Pending Deployment'
                    CHECK(status IN (
                        'Pending Deployment',
                        'Dispatched',
                        'Drain Cleared'
                    )),
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

                FOREIGN KEY (assigned_officer_id)
                    REFERENCES users(id)
            );

            CREATE INDEX IF NOT EXISTS idx_incidents_created
                ON incidents(created_at DESC);

            CREATE INDEX IF NOT EXISTS idx_incidents_officer
                ON incidents(assigned_officer_id);

            CREATE INDEX IF NOT EXISTS idx_users_routing
                ON users(role, is_on_duty, is_available);
        """)

        # Seed only when the users table is empty.
        count = conn.execute(
            "SELECT COUNT(*) FROM users"
        ).fetchone()[0]

        if count == 0:
            seed_users = [
                (
                    "K. Rajesh, AE",
                    "rajesh.officer@gcc.gov.in",
                    pwd_context.hash("admin123"),
                    "municipal",
                    "+91 94440 12345",
                    "Ward 178 - Velachery South",
                    "Engineering",
                    "Active",
                    1,
                    1,
                    DEFAULT_ENGINEER_LAT,
                    DEFAULT_ENGINEER_LON,
                ),
                (
                    "Arun Kumar",
                    "arun.citizen@gmail.com",
                    pwd_context.hash("user123"),
                    "citizen",
                    "+91 98840 54321",
                    None,
                    None,
                    "Active",
                    0,
                    0,
                    None,
                    None,
                ),
            ]

            conn.executemany("""
                INSERT INTO users (
                    name, email, password_hash, role, phone,
                    ward, department, status, is_on_duty,
                    is_available, latitude, longitude
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, seed_users)

        conn.commit()

    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()


@asynccontextmanager
async def lifespan(app: FastAPI):
    initialize_database()
    yield


# ============================================================
# FASTAPI APPLICATION
# ============================================================

app = FastAPI(
    title="AegisFlow API",
    description=(
        "Urban flood digital twin, incident management, "
        "and municipal emergency response backend."
    ),
    version="1.0.0",
    lifespan=lifespan,
)

# Requested permissive CORS configuration.
# For production, replace "*" with explicitly trusted origins.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ============================================================
# REQUEST MODELS
# ============================================================

class CitizenRegistration(BaseModel):
    name: str = Field(min_length=2, max_length=120)
    email: EmailStr
    password: str = Field(min_length=8, max_length=72)
    phone: Optional[str] = Field(default=None, max_length=25)
    ward: Optional[str] = Field(default=None, max_length=120)


class LoginRequest(BaseModel):
    email: EmailStr
    password: str = Field(min_length=1, max_length=72)
    portal_type: Literal["citizen", "municipal"]


class IncidentCreate(BaseModel):
    citizen_name: str = Field(min_length=2, max_length=120)
    location: str = Field(min_length=2, max_length=250)
    coords: str = Field(min_length=3, max_length=80)
    severity: str = Field(min_length=1, max_length=30)
    description: Optional[str] = Field(default=None, max_length=3000)

    @field_validator("coords")
    @classmethod
    def validate_coords(cls, value: str) -> str:
        parse_coords(value)
        return value.strip()


# ============================================================
# VALIDATION AND HELPERS
# ============================================================

def normalized_email(email: str) -> str:
    return email.strip().lower()


def email_domain(email: str) -> str:
    return normalized_email(email).rsplit("@", 1)[-1]


def is_official_email(email: str) -> bool:
    return email_domain(email) in OFFICIAL_DOMAINS


def parse_coords(coords: str) -> tuple[float, float]:
    """Parse 'latitude, longitude' and validate geographic bounds."""
    try:
        parts = coords.split(",")
        if len(parts) != 2:
            raise ValueError

        lat = float(parts[0].strip())
        lon = float(parts[1].strip())

        if not (-90 <= lat <= 90 and -180 <= lon <= 180):
            raise ValueError

        if not math.isfinite(lat) or not math.isfinite(lon):
            raise ValueError

        return lat, lon
    except (ValueError, TypeError):
        raise HTTPException(
            status_code=422,
            detail="coords must be a valid 'latitude, longitude' string.",
        )


def haversine_km(
    lat1: float,
    lon1: float,
    lat2: float,
    lon2: float,
) -> float:
    """Calculate straight-line geographic distance in kilometres."""
    radius_km = 6371.0

    p1 = math.radians(lat1)
    p2 = math.radians(lat2)
    dlat = math.radians(lat2 - lat1)
    dlon = math.radians(lon2 - lon1)

    a = (
        math.sin(dlat / 2) ** 2
        + math.cos(p1) * math.cos(p2)
        * math.sin(dlon / 2) ** 2
    )
    return radius_km * 2 * math.atan2(
        math.sqrt(a), math.sqrt(max(0.0, 1 - a))
    )


def public_user(row: sqlite3.Row) -> dict:
    """Return safe profile fields; never expose password hashes."""
    return {
        "id": row["id"],
        "name": row["name"],
        "email": row["email"],
        "role": row["role"],
        "phone": row["phone"],
        "ward": row["ward"],
        "status": row["status"],
    }


def create_access_token(user: sqlite3.Row) -> str:
    now = datetime.now(timezone.utc)

    payload = {
        "sub": str(user["id"]),
        "role": user["role"],
        "iat": now,
        "exp": now + timedelta(minutes=JWT_EXPIRE_MINUTES),
    }

    return jwt.encode(
        payload,
        JWT_SECRET_KEY,
        algorithm=JWT_ALGORITHM,
    )


def get_current_user(
    credentials: Optional[HTTPAuthorizationCredentials] = Depends(
        bearer_scheme
    ),
    conn: sqlite3.Connection = Depends(get_db),
) -> dict:
    if not credentials:
        raise HTTPException(
            status_code=401,
            detail="Bearer token required.",
            headers={"WWW-Authenticate": "Bearer"},
        )

    try:
        payload = jwt.decode(
            credentials.credentials,
            JWT_SECRET_KEY,
            algorithms=[JWT_ALGORITHM],
        )
        user_id = int(payload["sub"])
    except (jwt.InvalidTokenError, KeyError, TypeError, ValueError):
        raise HTTPException(
            status_code=401,
            detail="Invalid or expired token.",
            headers={"WWW-Authenticate": "Bearer"},
        )

    row = conn.execute(
        """
        SELECT id, name, email, role, phone, ward, status
        FROM users
        WHERE id = ?
        """,
        (user_id,),
    ).fetchone()

    if row is None or row["status"] != "Active":
        raise HTTPException(
            status_code=401,
            detail="Account not found or inactive.",
        )

    return dict(row)


def require_role(*roles: str):
    def dependency(user: dict = Depends(get_current_user)) -> dict:
        if user["role"] not in roles:
            raise HTTPException(
                status_code=403,
                detail="You are not authorized to access this resource.",
            )
        return user

    return dependency


def find_available_officer(
    conn: sqlite3.Connection,
    latitude: Optional[float] = None,
    longitude: Optional[float] = None,
):
    """Return the nearest active, on-duty and available engineer."""
    officers = conn.execute("""
        SELECT id, name, email, phone, ward, department,
               latitude, longitude
        FROM users
        WHERE role = 'municipal'
          AND status = 'Active'
          AND is_on_duty = 1
          AND is_available = 1
        ORDER BY id ASC
    """).fetchall()

    if not officers:
        return None, None

    def distance(officer):
        if (
            latitude is None
            or longitude is None
            or officer["latitude"] is None
            or officer["longitude"] is None
        ):
            return float("inf")

        return haversine_km(
            latitude,
            longitude,
            officer["latitude"],
            officer["longitude"],
        )

    # Officers without coordinates rank after officers with coordinates
    # when an incident's location is supplied.
    selected = min(officers, key=distance)
    km = distance(selected)

    return selected, (km if math.isfinite(km) else None)


def make_ticket_id(conn: sqlite3.Connection) -> str:
    """Generate a unique AF-XXXX ticket identifier."""
    for _ in range(20):
        ticket_id = f"AF-{secrets.randbelow(10000):04d}"
        exists = conn.execute(
            "SELECT 1 FROM incidents WHERE ticket_id = ?",
            (ticket_id,),
        ).fetchone()

        if not exists:
            return ticket_id

    raise HTTPException(
        status_code=503,
        detail="Could not generate a unique ticket. Please retry.",
    )


# ============================================================
# BASIC HEALTH CHECK
# ============================================================

@app.get("/")
def root():
    return {
        "application": "AegisFlow",
        "status": "running",
        "docs": "/docs",
    }


@app.get("/health")
def health():
    return {
        "status": "healthy",
        "database": "SQLite",
    }


# ============================================================
# AUTHENTICATION
# ============================================================

@app.post(
    "/api/auth/register-citizen",
    status_code=status.HTTP_201_CREATED,
)
def register_citizen(
    payload: CitizenRegistration,
    conn: sqlite3.Connection = Depends(get_db),
):
    email = normalized_email(str(payload.email))

    if is_official_email(email):
        raise HTTPException(
            status_code=403,
            detail=(
                "Government organizational emails cannot register "
                "as citizen accounts."
            ),
        )

    existing = conn.execute(
        "SELECT id FROM users WHERE email = ?",
        (email,),
    ).fetchone()

    if existing:
        raise HTTPException(
            status_code=409,
            detail="An account with this email already exists.",
        )

    try:
        cursor = conn.execute("""
            INSERT INTO users (
                name, email, password_hash, role, phone, ward, status
            )
            VALUES (?, ?, ?, 'citizen', ?, ?, 'Active')
        """, (
            payload.name.strip(),
            email,
            pwd_context.hash(payload.password),
            payload.phone,
            payload.ward,
        ))
        conn.commit()

        row = conn.execute(
            """
            SELECT id, name, email, role, phone, ward, status
            FROM users WHERE id = ?
            """,
            (cursor.lastrowid,),
        ).fetchone()

        return {
            "message": "Citizen registered successfully.",
            "user": public_user(row),
        }

    except sqlite3.IntegrityError:
        conn.rollback()
        raise HTTPException(
            status_code=409,
            detail="Could not create the account; email may already exist.",
        )


@app.post("/api/auth/login")
def login(
    payload: LoginRequest,
    conn: sqlite3.Connection = Depends(get_db),
):
    email = normalized_email(str(payload.email))
    domain = email_domain(email)

    # Enforce organizational-domain rules for the municipal portal.
    if payload.portal_type == "municipal" and domain not in OFFICIAL_DOMAINS:
        raise HTTPException(
            status_code=403,
            detail=(
                "Municipal login requires an @gcc.gov.in "
                "or @tn.gov.in email address."
            ),
        )

    # Government-domain identities cannot enter the citizen portal.
    if payload.portal_type == "citizen" and domain in OFFICIAL_DOMAINS:
        raise HTTPException(
            status_code=403,
            detail="Government accounts cannot use the citizen portal.",
        )

    row = conn.execute(
        "SELECT * FROM users WHERE email = ?",
        (email,),
    ).fetchone()

    # Use a generic error for unknown users and incorrect passwords.
    if row is None or not pwd_context.verify(
        payload.password, row["password_hash"]
    ):
        raise HTTPException(
            status_code=401,
            detail="Invalid email or password.",
        )

    if row["status"] != "Active":
        raise HTTPException(
            status_code=403,
            detail="This account is inactive.",
        )

    if row["role"] != payload.portal_type:
        raise HTTPException(
            status_code=403,
            detail="This account is not authorized for the selected portal.",
        )

    # Defense in depth: also validate the stored municipal identity.
    if row["role"] == "municipal" and not is_official_email(row["email"]):
        raise HTTPException(
            status_code=403,
            detail="Municipal account has an invalid organizational domain.",
        )

    return {
        "access_token": create_access_token(row),
        "token_type": "bearer",
        "expires_in": JWT_EXPIRE_MINUTES * 60,
        "user": public_user(row),
    }


# ============================================================
# MUNICIPAL OFFICER ROUTING
# ============================================================

@app.get("/api/officers/available")
def available_officer(
    coords: Optional[str] = Query(
        default=None,
        description="Optional 'latitude, longitude' incident coordinates.",
    ),
    conn: sqlite3.Connection = Depends(get_db),
    user: dict = Depends(require_role("municipal")),
):
    latitude = longitude = None

    if coords:
        latitude, longitude = parse_coords(coords)

    officer, distance_km = find_available_officer(
        conn, latitude, longitude
    )

    if officer is None:
        return {
            "available": False,
            "officer": None,
            "message": "No on-duty available municipal engineer found.",
        }

    return {
        "available": True,
        "officer": {
            "id": officer["id"],
            "name": officer["name"],
            "email": officer["email"],
            "phone": officer["phone"],
            "ward": officer["ward"],
            "department": officer["department"],
            "distance_km": (
                round(distance_km, 2)
                if distance_km is not None
                else None
            ),
        },
    }


# ============================================================
# INCIDENT MANAGEMENT
# ============================================================

@app.post(
    "/api/incidents",
    status_code=status.HTTP_201_CREATED,
)
def create_incident(
    payload: IncidentCreate,
    conn: sqlite3.Connection = Depends(get_db),
    user: dict = Depends(require_role("citizen", "municipal")),
):
    latitude, longitude = parse_coords(payload.coords)

    try:
        # BEGIN IMMEDIATE serializes competing SQLite write transactions.
        conn.execute("BEGIN IMMEDIATE")

        officer, distance_km = find_available_officer(
            conn, latitude, longitude
        )
        ticket_id = make_ticket_id(conn)

        # The request schema has no citizen_phone field, so use the
        # authenticated citizen's phone when the creator is a citizen.
        citizen_phone = None
        if user["role"] == "citizen":
            citizen_phone = user["phone"]

        if officer is not None:
            incident_status = "Dispatched"
            assigned_officer_id = officer["id"]
        else:
            incident_status = "Pending Deployment"
            assigned_officer_id = None

        cursor = conn.execute("""
            INSERT INTO incidents (
                ticket_id, citizen_name, citizen_phone, location,
                coords, severity, description, assigned_officer_id, status
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (
            ticket_id,
            payload.citizen_name.strip(),
            citizen_phone,
            payload.location.strip(),
            payload.coords.strip(),
            payload.severity.strip(),
            payload.description,
            assigned_officer_id,
            incident_status,
        ))

        incident_id = cursor.lastrowid
        conn.commit()

        return {
            "message": (
                "Incident created and officer assigned."
                if officer is not None
                else "Incident recorded; no available officer was found."
            ),
            "incident": {
                "id": incident_id,
                "ticket_id": ticket_id,
                "citizen_name": payload.citizen_name.strip(),
                "citizen_phone": citizen_phone,
                "location": payload.location.strip(),
                "coords": payload.coords.strip(),
                "severity": payload.severity.strip(),
                "description": payload.description,
                "assigned_officer_id": (
                    officer["id"] if officer is not None else None
                ),
                "assigned_officer_name": (
                    officer["name"] if officer is not None else None
                ),
                "status": incident_status,
            },
            "routing": {
                "assigned": officer is not None,
                "distance_km": (
                    round(distance_km, 2)
                    if distance_km is not None
                    else None
                ),
            },
        }

    except HTTPException:
        conn.rollback()
        raise
    except sqlite3.Error:
        conn.rollback()
        raise HTTPException(
            status_code=500,
            detail="Database error while recording the incident.",
        )


@app.get("/api/incidents")
def list_incidents(
    conn: sqlite3.Connection = Depends(get_db),
    user: dict = Depends(require_role("municipal")),
):
    rows = conn.execute("""
        SELECT
            i.id,
            i.ticket_id,
            i.citizen_name,
            i.citizen_phone,
            i.location,
            i.coords,
            i.severity,
            i.description,
            i.assigned_officer_id,
            i.status,
            i.created_at,
            u.name AS assigned_officer_name,
            u.phone AS assigned_officer_phone
        FROM incidents AS i
        LEFT JOIN users AS u
            ON u.id = i.assigned_officer_id
        ORDER BY i.created_at DESC, i.id DESC
    """).fetchall()

    return {
        "count": len(rows),
        "incidents": [dict(row) for row in rows],
    }


# ============================================================
# DIGITAL TWIN STATE
# ============================================================

@app.get("/api/v1/twin-state")
def twin_state(
    rainfall_mm_hr: float = Query(default=75.0, ge=0, le=500),
):
    """
    Demonstration response shape for frontend integration.

    Replace the illustrative values with the actual drainage sensor
    feed, Member 1 model inference, Member 2 hydraulic outputs, and
    a route generated by a validated routing service.
    """

    # Illustrative calculation ONLY, not a trained flood model.
    # It must not be treated as a real forecast or a safety decision.
    illustrative_depth = round(
        min(1.5, rainfall_mm_hr * 0.003),
        3,
    )

    if illustrative_depth >= 0.8:
        severity = "High"
    elif illustrative_depth >= 0.4:
        severity = "Moderate"
    else:
        severity = "Low"

    return {
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "location": "Velachery, Chennai",
        "data_quality": {
            "mode": "illustrative_demo",
            "is_live_sensor_data": False,
            "is_trained_model_prediction": False,
            "message": (
                "Replace demonstration values with validated live "
                "telemetry and model inference before operational use."
            ),
        },
        "weather": {
            "rainfall_mm_hr": rainfall_mm_hr,
            "source": "API query parameter; not independently verified",
        },
        "drainage_telemetry": [
            {
                "node_id": "N003",
                "water_level_m": 0.45,
                "flow_lpm": 18.2,
                "pressure_bar": 0.31,
                "source": "illustrative_demo",
            },
            {
                "node_id": "N011",
                "water_level_m": 0.62,
                "flow_lpm": 12.7,
                "pressure_bar": 0.46,
                "source": "illustrative_demo",
            },
        ],
        "member1_prediction": {
            "model": "Physics-Guided Spatio-Temporal GNN",
            "predicted_flood_depth_m": illustrative_depth,
            "severity": severity,
            "forecast_horizon_minutes": 60,
            "source": "illustrative_demo_not_model_inference",
        },
        "member2_hydraulics": {
            "surcharge_status": "SIMULATED_SURCHARGE",
            "blockage_status": "SIMULATED_PARTIAL_BLOCKAGE",
            "source": "illustrative_demo_not_hydraulic_solver",
        },
        "safest_vehicle_route": {
            "verified": False,
            "message": (
                "No operationally verified safe route is available "
                "from the demonstration backend."
            ),
            "coordinates": [
                [80.2200, 12.9750],
                [80.2180, 12.9735],
                [80.2150, 12.9720],
            ],
            "coordinate_order": "longitude, latitude",
            "source": "illustrative_demo_not_routed",
        },
    }
