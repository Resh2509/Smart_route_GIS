markdown
 🌊 AegisFlow-BioDrain (AegisFlow)

 AI-Powered Topological Digital Twin, Subterranean Biofiltration & Autonomous Servo-Actuated Toxic Gas Mitigation Matrix

[![Platform](https://img.shields.io/badge/Platform-Flutter%20%7C%20FastAPI%20%7C%20ESP32-02569B?style=flat&logo=flutter)](https://flutter.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Cyber--Physical%20Digital%20Twin-4CAF50?style=flat)](#-system-architecture)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Vishwakarma Awards](https://img.shields.io/badge/AICTE-Chhatra%20Vishwakarma%20Awards%202026-orange?style=flat)](#-strategic-impact--vishwakarma-awards-alignment)



## 📌 Executive Overview

**AegisFlow-BioDrain** is an end-to-end cyber-physical municipal infrastructure and disaster mitigation platform engineered for high-density, flood-vulnerable urban corridors (such as the Velachery drainage basin in Chennai). 

Urban stormwater flooding, conduit backpressure, and toxic sewer gas asphyxiations are not disconnected events—they are downstream consequences of **subterranean air-binding, organic sludge decay, trash siltation, and fragmented civic communication**. 

AegisFlow solves this crisis holistically by integrating:
1. **IoT Edge Hydrodynamics & Hazardous Gas Inference:** Real-time pipe depth, flow velocity, and differential pressure tracking that diagnostically calculates anaerobic biogas accumulation ($\text{H}_2\text{S}$, $\text{CH}_4$, $\text{CO}$).
2. **Autonomous Smart Auto-Vent:** A high-torque servo-actuated flapper valve that dynamically relieves hydraulic air pockets and purges toxic gas pockets through an activated carbon hood, while sealing mechanically against street flood surcharge.
3. **SmartDrain Decentralized Biofiltration:** A multi-tier modular filter cartridge that captures urban trash and utilizes biological films to digest organic pollutants prior to downstream discharge.
4. **Topological WebGIS Digital Twin & Resilient Dispatch:** An asynchronous FastAPI engine and cross-platform Flutter dashboard that converts crowdsourced civic reports into localized field assignments and flood-resilient route corridors for emergency de-watering vehicles.



## 🚨 The Tri-Fold Urban Crisis

| Challenge | Real-World Consequence | AegisFlow-BioDrain Intervention |
| :--- | :--- | :--- |
| **1. Subterranean Air-Binding** | Pockets of trapped air at pipe crowns reduce effective conduit cross-section by **40% to 60%**, inducing early street surcharge. | **Smart Auto-Vent:** Servo-driven pressure-release valve automatically purges trapped air to restore full hydraulic capacity. |
| **2. Toxic Gas Asphyxiation** | Stagnant organic sludge ferments into lethal $\text{H}_2\text{S}$ and flammable $\text{CH}_4$, endangering sanitation personnel. | **Pneumatic Vector Inference & Purge:** Continuously tracks gas evolution via $\Delta P$ models and vents through an activated carbon scrubber. |
| **3. Untreated Runoff Siltation** | Storm runoff washes heavy solids, micro-plastics, and raw organic waste directly into vulnerable lake basins. | **Inline SmartDrain Biofilter:** Modular coarse screen, settling sump, and high-surface bio-ball media remediate runoff in-situ. |
| **4. Blind Municipal Dispatch** | Emergency response crews lack visibility into submerged streets and become stranded during transit. | **A* Topological Twin Rerouting:** Directs response fleets along real-time water-depth safe corridors ($<0.3\text{ m}$). |



## 🏗️ System Architecture

AegisFlow-BioDrain operates as a continuous, closed-loop cyber-physical pipeline across physical conduits, edge compute, backend intelligence, and client interfaces:




┌────────────────────────────────────────────────────────────────────────┐
│                        FLUTTER CLIENT APPLICATIONS                     │
│                                                                        │
│   [Citizen Emergency Portal]              [Municipal Operations]       │
│   • 2-Step Geotagged Hazard Logging       • Domain-Gated (@gcc.gov.in) │
│   • Auto Ward Officer Assignment          • Incident Operations Queue  │
│   • Direct PSTN Calling & Intercom        • Telemetry Overlays         │
│   • Real-Time Ticket Lifecycle            • Digital Twin Safe Routing  │
└───────────────────────────────────┬────────────────────────────────────┘
│ HTTP / REST / WebSockets
┌───────────────────────────────────▼────────────────────────────────────┐
│                         FASTAPI APPLICATION SERVER                     │
│                                                                        │
│   ├── JWT Stateless Auth & Domain-Enforced Isolation Engine            │
│   ├── Ward-Based Dynamic Officer Assignment Logic                      │
│   ├── Edge Telemetry Ingestion & Piezoresistive Diagnostic Pipeline    │
│   ├── XGBoost Multi-Class Hydraulic Classifier                         │
│   └── NetworkX Flood-Resilient Safe Corridor Router                    │
└───────────────────┬────────────────────────────────┬───────────────────┘
│ Embedded SQL                   │ Dynamic Telemetry
┌───────────────────▼──────────────┐   ┌─────────────▼───────────────────┐
│     SQLITE (aegisflow.db)        │   │       SUBTERRANEAN EDGE         │
│                                  │   │  (ESP32 + SmartDrain Chamber)   │
│ • users (Credentials, Roles)     │   │                                 │
│ • incidents (Tickets, Status)    │   │ • YF-S201 Turbine Flow Sensor   │
│ • telemetry_logs (Node Series)   │   │ • Analog Hydrostatic Depth      │
│ • biofilter_nodes (Valve States) │   │ • Piezoresistive Transducer     │
│                                  │   │ • MG996R Servo Smart Auto-Vent  │
│                                  │   │ • Multi-Stage Biofilter Media   │
└──────────────────────────────────┘   └─────────────────────────────────┘



---

## ⚙️ Core Technical Modules

### 1. 🧪 SmartDrain Inline Biofiltration
Integrated directly into stormwater collector nodes prior to open canal discharge:
* **Stage 1 (Coarse Screen):** 10 mm stainless steel bar screen trapping floating plastics, carry bags, and organic debris.
* **Stage 2 (Sedimentation Sump):** Low-velocity hydrodynamic settling basin for sand, heavy silt, and street grit.
* **Stage 3 (Biological Digestion Bed):** High-surface-area ($>800\text{ m}^2/\text{m}^3$) ceramic rings and bio-balls colonized by nitrifying and aerobic heterotrophic microflora that digest dissolved organic matter, reducing Biochemical Oxygen Demand (BOD) and Chemical Oxygen Demand (COD).
* **Stage 4 (Carbon Scrubbing Tier):** Granular Activated Carbon (GAC) for adsorption of volatile aromatic compounds and residual road runoff chemicals.
* **Passive Anti-Clog Bypass Weir:** Internal calibrated side-weir that diverts extreme flash-flood volumes ($>50\text{ mm/hr}$) past the filter bed, ensuring the filter itself never causes upstream waterlogging.

### 2. 🎛️ Servo-Actuated Smart Auto-Vent
An autonomous edge valve assembly mounted at the biofilter ceiling:
* **Actuation Mechanism:** MG996R high-torque waterproof servo operating a 3-inch counter-balanced flapper valve with an oil/chemical-resistant Viton seal.
* **Dynamic Operation States:**
  * **Purge State ($90^\circ$ Orifice):** When differential gauge pressure exceeds $+12\text{ mbar}$ and water level is below the crown, the servo opens, purging trapped air and venting toxic gases through a top-mounted activated carbon canister.
  * **Hydraulic Seal State ($0^\circ$ Locked):** When stormwater reaches peak capacity ($<5\text{ cm}$ clearance to ceiling), the servo drives to $0^\circ$ and holds under mechanical lock, preventing wastewater from spilling onto street pavements.

### 3. 🔍 Virtual Surrogate Gas & Blockage Diagnostic
To overcome the cost, fragility, and rapid moisture-saturation of sub-surface chemical gas probes, the system uses thermodynamic hydro-pneumatic inference:
* Correlates **near-zero flow rates** ($<0.5\text{ L/min}$), **continuous standing depth**, and **headspace differential pressure ($\Delta P$)**.
* Calculates an **Estimated Toxic Gas Index (PPM)** to detect anaerobic fermentation without dedicated gas sensors.
* Feeds physical parameters into an **XGBoost Classifier** on the backend to categorize conduit states: `Laminar Flow`, `Air-Binding`, `Biofilter Fouled`, `Culvert Blocked`, or `Critical Gas Pocket`.

### 4. 📱 Flutter Frontend & Digital Twin Hub
* **Citizen Emergency Portal:**
  * Personal domain access (`@gmail.com`, `@yahoo.com`).
  * 2-Step diagnostic reporting (Zone/Hazard Dropdown $\rightarrow$ Dynamic Context Prompts).
  * Direct one-touch PSTN telephone link and intercom to the assigned ward engineer.
* **Municipal Operations Command:**
  * Restricted government access (`@gcc.gov.in`, `@tn.gov.in`).
  * Live incident pipeline (`Dispatched`, `Pumping in Progress`, `Vent Active`, `Resolved`).
  * Real-time topological Digital Twin showing pipe surcharge levels, chamber pressure status, and water-depth-aware safe routing for de-watering vehicles.

---

## 💻 Tech Stack

| Layer | Technologies | Role & Capability |
| :--- | :--- | :--- |
| **Physical Edge & Actuation** | ESP32 (FreeRTOS), MG996R Servo, Viton Flange | 240 MHz dual-core processing, real-time PWM valve control, and local threshold safety overrides. |
| **Sensing Subsystem** | YF-S201, Analog Depth Strip, Piezoresistive Transducer | Real-time tracking of flow velocity, water level, and differential conduit pressure. |
| **Filtration Media** | Sintered Glass Rings, Bio-Balls, Acid-Washed GAC | Particulate entrapment, aerobic digestion, and chemical/odor adsorption. |
| **Backend & APIs** | FastAPI, Uvicorn, Python 3.11 | High-throughput asynchronous REST/WebSocket server with auto-generated OpenAPI documentation. |
| **Database Tier** | SQLite3 (`aegisflow.db`), SQLAlchemy | Zero-cloud-latency relational data store with ACID transaction integrity. |
| **Security & Identity** | PyJWT, Passlib (Bcrypt) | Stateless cryptographically signed JWT sessions and domain-isolated access control. |
| **Client Framework** | Flutter SDK (Dart) | Cross-platform codebase compiled for Google Chrome and native Android APK. |
| **Topological GIS & Routing** | WebGIS, Leaflet.js, NetworkX | Surcharge node mapping and graph-based flood-resilient emergency route calculation. |

---

## 🗄️ Database Schema (`aegisflow.db`)

┌─────────────────────────────────────────────────────────────────────────────────┐
│                             DATABASE SCHEMA OVERVIEW                            │
│                               (aegisflow.db)                                    │
└─────────────────────────────────────────────────────────────────────────────────┘

┌───────────────────────────────────────┐         ┌───────────────────────────────────────┐
│                 users                 │         │               incidents               │
├───────────────────┬───────────────────┤         ├───────────────────┬───────────────────┤
│ id                │ INTEGER [PK, AI]  │◄──┐     │ id                │ INTEGER [PK, AI]  │
│ name              │ TEXT [NN]         │   │     │ ticket_id         │ TEXT [UQ, NN]     │
│ email             │ TEXT [UQ, NN]     │   │     │ citizen_name      │ TEXT [NN]         │
│ password_hash     │ TEXT [NN]         │   │     │ locality          │ TEXT [NN]         │
│ role              │ TEXT [NN]         │   │     │ hazard_type       │ TEXT [NN]         │
│ phone             │ TEXT              │   │     │ street_address    │ TEXT [NN]         │
│ ward              │ TEXT              │   │     │ landmark          │ TEXT              │
│ department        │ TEXT              │   │     │ specific_details  │ TEXT              │
│ status            │ TEXT [DEF]        │   └─────┤ assigned_officer_id│ INTEGER [FK]     │
│ created_at        │ TIMESTAMP [DEF]   │         │ status            │ TEXT [DEF]        │
└───────────────────┴───────────────────┘         │ created_at        │ TIMESTAMP [DEF]   │
                                                  └───────────────────┴───────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                                 telemetry_logs                                  │
├───────────────────────────────┬─────────────────────────────────────────────────┤
│ log_id                        │ INTEGER [PK, AUTOINCREMENT]                     │
│ node_id                       │ TEXT [NOT NULL]                                 │
│ flow_rate                     │ REAL (L/min)                                    │
│ water_level                   │ REAL (Depth %)                                  │
│ chamber_pressure              │ REAL (Absolute kPa)                             │
│ gauge_differential            │ REAL (Delta P in mbar)                          │
│ inferred_gas_ppm              │ REAL (Surrogate H2S / CH4 Index)                │
│ classification                │ TEXT ('LAMINAR', 'AIR_BIND', 'CLOG', etc.)      │
│ recorded_at                   │ TIMESTAMP [DEFAULT CURRENT_TIMESTAMP]           │
└───────────────────────────────┴─────────────────────────────────────────────────┘

Key Legends:
• [PK] Primary Key       • [NN]  Not Null            • [DEF] Default Value Set
• [AI] Auto Increment    • [UQ]  Unique Constraint   • [FK]  Foreign Key (references users.id)
---

## 🚀 Quick Start & Installation

### Prerequisites

* **Hardware:** ESP32 Dev Board, YF-S201 Flow Sensor, Analog Depth Sensor, 5V Pressure Transducer, MG996R Servo, 5V/2A external power source.
* **Software:** Python 3.10+, Flutter SDK 3.x+, Arduino IDE 2.x+, Git.

---

### 1. Edge Firmware Setup (Arduino IDE)

1. Open Arduino IDE and install the **ESP32 Board Package** via Board Manager.
2. Install the **`ESP32Servo`** library by Kevin Harrington via Library Manager.
3. Connect the sensors to the ESP32:
* **Flow Sensor (Signal):** `GPIO 2`
* **Water Level Sensor (Signal):** `GPIO 34`
* **Pressure Sensor (Signal):** `GPIO 35`
* **Servo Motor (PWM Signal):** `GPIO 18`


4. Set the Serial Monitor baud rate to **`115200`**.
5. Compile and upload the sketch to your ESP32.

---

### 2. Backend Server Setup (FastAPI)

bash
# Clone the repository
git clone [https://github.com/your-username/AegisFlow-BioDrain.git](https://github.com/your-username/AegisFlow-BioDrain.git)
cd AegisFlow-BioDrain/backend

# Create and activate virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install fastapi uvicorn sqlalchemy passlib[bcrypt] pyjwt pydantic xgboost scikit-learn networkx

# Launch the FastAPI ASGI server
uvicorn server:app --host 0.0.0.0 --port 8000 --reload



* **API Documentation:** Navigate to `http://localhost:8000/docs` to view interactive OpenAPI Swagger docs.

---

### 3. Frontend Client Setup (Flutter)

bash
cd ../frontend

# Fetch Flutter dependencies
flutter pub get

# Run on Google Chrome (DevTools responsive viewport)
flutter run -d chrome

# (Optional) Build release Android APK
flutter build apk --release



---

## 🏆 Strategic Impact & Vishwakarma Awards Alignment

The **AICTE Chhatra Vishwakarma Awards** prioritize scalable, frugal, and sustainable engineering solutions that solve core societal challenges:

1. **Elimination of Sanitation Fatalities (Social Impact):**
Replaces hazardous blind manhole inspections with thermodynamic surrogate gas tracking and automated carbon-scrubbed venting, directly supporting worker safety initiatives.
2. **Flood Disaster Resilience (Civic Infrastructure):**
Removes trapped air pockets to recover up to 60% of lost culvert throughput, clearing urban street waterlogging before backpressure inundates residential neighborhoods.
3. **Decentralized Urban Water Remediation (Sustainability):**
Treats urban runoff at the collection manhole using passive biofiltration, trapping plastics and digesting organic pollutants before water reaches natural lakes.
4. **Frugal & High-Feasibility Innovation:**
Uses open-source software, low-cost microcontrollers, and standard plumbing components, keeping capital deployment costs low for tier-1 and tier-2 municipal corporations.



## 👥 Authors & Acknowledgments

* **Lead Developers:** Engineering Project Team, Panimalar Engineering College, Chennai.
* **Domain Focus:** Hydro-Informatics, Urban Inundation Modeling, Embedded Edge Computing, and Civic Governance Systems.
* **Submitted For:** AICTE Chhatra Vishwakarma Awards 2026.



