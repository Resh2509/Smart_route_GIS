# AegisFlow-BioDrain
### Next-Generation Cyber-Physical Urban Flood Mitigation, Smart Drainage, Biofiltration & Digital Twin Platform

<p align="center">
  <strong>AI-Powered Drainage Intelligence • Autonomous Air-Release Research • Biofiltration • Worker Safety • Flood-Resilient Routing</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Domain-AI%20%7C%20IoT%20%7C%20Smart%20Cities-blue" alt="Domain"/>
  <img src="https://img.shields.io/badge/Hardware-ESP32-orange" alt="Hardware"/>
  <img src="https://img.shields.io/badge/Backend-FastAPI-green" alt="Backend"/>
  <img src="https://img.shields.io/badge/Mobile-Flutter-02569B" alt="Mobile"/>
  <img src="https://img.shields.io/badge/ML-XGBoost-red" alt="Machine Learning"/>
  <img src="https://img.shields.io/badge/Project-Prototype-purple" alt="Prototype"/>
</p>

## 1. Overview

**AegisFlow-BioDrain** is an AI-assisted, IoT-enabled urban drainage monitoring and flood mitigation platform designed to identify underground drainage problems, monitor hazardous conditions, improve stormwater management, and support safer municipal emergency response.

The system combines physical drainage monitoring, a modular biofiltration prototype, an ESP32-based sensing and control layer, machine learning diagnostics, a graph-based digital twin, and mobile reporting into one integrated architecture.

Instead of waiting for waterlogging to become visible on roads, AegisFlow-BioDrain aims to identify warning signs such as abnormal pressure differences, rising water levels, reduced flow, potential blockages, and filter fouling. The backend can correlate these observations with citizen reports and drainage network information to prioritize inspection and maintenance.

The proposed Smart Auto-Vent module investigates controlled air release under suitable hydraulic conditions. The biofiltration module combines debris screening, sediment settling, biological media, and activated carbon to support preliminary stormwater treatment.

The long-term objective is to develop a scalable, low-cost smart infrastructure platform that helps municipalities move from reactive drainage maintenance toward predictive monitoring and coordinated flood response.

> **Project principle:** Detect early, diagnose intelligently, mitigate cautiously, protect workers, and coordinate emergency response.

---

## 2. Problem Statement

Urban drainage networks frequently experience failures during intense rainfall because of accumulated debris, sediment deposition, inadequate drainage capacity, localized hydraulic restrictions, and limited underground visibility.

These problems can lead to:

- Street flooding and waterlogging.
- Reduced drainage flow caused by blockages and sediment accumulation.
- Hydraulic restrictions associated with trapped air under certain operating conditions.
- Poor stormwater quality due to debris and suspended sediment.
- Potential hazardous gas accumulation in stagnant or contaminated drainage environments.
- Unsafe conditions for sanitation workers and maintenance teams.
- Delayed identification of underground infrastructure failures.
- Emergency vehicles encountering flooded or inaccessible roads.
- Limited coordination between citizens, field engineers, and municipal authorities.

Conventional visual inspection and isolated sensor alerts may not provide enough information to distinguish the underlying cause of a drainage problem.

AegisFlow-BioDrain addresses this challenge through integrated sensing, condition classification, physical prototype testing, digital visualization, and emergency response planning.

## 3. Objectives

1. Monitor drainage pressure, flow, and water levels using IoT sensors.
2. Detect abnormal hydraulic conditions and identify possible blockages.
3. Investigate trapped-air detection and controlled air-release mechanisms.
4. Develop a modular biofilter for preliminary stormwater screening and treatment.
5. Monitor potential gas hazards using appropriate sensing equipment.
6. Apply machine learning to classify drainage conditions using sensor telemetry.
7. Build a FastAPI backend for sensor ingestion, incident management, and diagnostics.
8. Create a graph-based drainage digital twin for infrastructure visualization.
9. Develop a Flutter citizen portal for geotagged incident reporting.
10. Support municipal maintenance prioritization and flood-resilient route planning.
11. Improve maintenance traceability through incident status and field-response records.
12. Design the prototype for future expansion into larger drainage networks.

## 4. Key Features

### 4.1 IoT-Based Drainage Monitoring

The ESP32 collects sensor readings from a physical drainage testbench. Measurements can include:

- Inlet and outlet pressure.
- Differential pressure.
- Inlet and outlet flow.
- Chamber water level.
- Water-level rise rate.
- Acoustic vibration features.
- Gas sensor readings, where the relevant hardware is installed.

The telemetry is transmitted to the backend for storage, visualization, and diagnostic processing.

### 4.2 Smart Servo Auto-Vent

The Smart Auto-Vent is a proposed electromechanical module designed to investigate the controlled release of trapped air at suitable drainage high points.

Its design includes:

- A servo-operated valve mechanism.
- A pressure-monitoring subsystem.
- Water-level monitoring.
- A mechanical linkage and valve seat.
- Local controller logic.
- Manual override and fault-handling provisions.

The controller evaluates pressure, water level, and operating state before permitting an experimental valve action.

**Safety requirement:** The valve must not open solely because a pressure threshold is exceeded. Flood surcharge, wastewater backflow, hazardous gas, and actuator faults must be evaluated independently. The prototype must be tested for liquid ingress, pressure loading, and safe vent discharge before any field deployment.

### 4.3 Multi-Stage Biofiltration

The SmartDrain biofiltration module is designed for preliminary treatment of stormwater runoff.

The proposed stages are:

1. **Coarse debris screening:** A removable mesh retains larger plastics, leaves, and other debris.
2. **Sediment settling:** A baffled sump reduces flow velocity so heavier grit and sediment can settle.
3. **Biological media:** Bio-balls or suitable porous media provide a surface for microbial biofilm development.
4. **Activated carbon:** Granular activated carbon supports adsorption of selected dissolved compounds and some odor-causing substances.
5. **Controlled discharge and bypass:** A downstream outlet and appropriately designed bypass help prevent a clogged filter from creating dangerous upstream flooding.

The biofilter is intended to support debris management and preliminary stormwater treatment. Actual BOD, COD, contaminant removal, and hydraulic capacity must be established through testing. The module does not automatically make wastewater safe for discharge or reuse.

### 4.4 AI-Based Drainage Diagnostics

The proposed XGBoost diagnostic engine evaluates sensor-derived features to classify drainage conditions.

Potential inputs include:

- Differential pressure.
- Inlet and outlet flow difference.
- Water depth.
- Water-level rise rate.
- Acoustic features extracted from vibration signals.
- Filter condition indicators.
- Gas sensor readings, when available and calibrated for the intended purpose.

The model can support classification of:

- Normal drainage operation.
- Possible trapped-air or hydraulic restriction.
- Potential biofilter fouling.
- Suspected culvert blockage.
- Potential hazardous environmental conditions.

Machine learning results are treated as decision-support outputs, not definitive proof of a physical fault. Training data, independent validation, and field calibration are required before operational use.

### 4.5 Hazard Monitoring and Worker Safety

The system can integrate gas-sensing hardware to flag potentially dangerous drainage conditions.

Proposed sensors include:

- MQ-136: H₂S-oriented sensing applications.
- MQ-4: methane-oriented sensing applications.
- MQ-7: CO-oriented sensing applications, if included in the hardware configuration.

These low-cost sensors have limitations involving cross-sensitivity, environmental conditions, calibration, and measurement accuracy. They are not substitutes for certified occupational gas detectors.

Gas alerts should trigger appropriate warnings, restricted access, and professional assessment. The prototype must never be used to justify entry into a confined space without an approved confined-space safety procedure.

An activated-carbon hood alone cannot guarantee safe neutralization of H₂S, methane, or carbon monoxide.

### 4.6 Digital Twin and Drainage Network Visualization

The AegisFlow digital twin represents the drainage network as a graph:

**G = (V, E)**

Where:

- **V:** Manholes, inspection chambers, junctions, outlets, and monitoring stations.
- **E:** Drainage pipes and hydraulic connections.

The digital twin can visualize:

- Live or simulated sensor readings.
- Drainage node status.
- Suspected blockage locations.
- Water-level and surcharge indicators.
- Maintenance requirements.
- Citizen-reported incidents.
- Potential gas hazard zones.
- Route accessibility information.

A GIS-based interface can be developed using Leaflet or Mapbox, with backend data supplied through FastAPI.

### 4.7 Citizen Emergency Reporting

The Flutter citizen portal is designed to allow users to submit drainage and flooding reports.

Proposed reporting categories include:

- Street waterlogging.
- Drain blockage.
- Manhole surcharge.
- Manhole cover damage or structural collapse.
- Unusual drainage odors or suspected gas hazards.

Each incident can contain:

- Incident type.
- Geographic coordinates, when permitted.
- Description and optional photographic evidence.
- Timestamp.
- Severity assessment.
- Current resolution status.

The backend can correlate these reports with nearby sensor observations where reliable location and network data are available.

### 4.8 Municipal Operations Dashboard

The proposed municipal dashboard supports:

- Incident review and prioritization.
- Sensor status monitoring.
- Maintenance ticket creation.
- Field crew assignment.
- Incident progress tracking.
- Drainage network visualization.
- Historical incident analysis.
- Emergency route recommendations.

Role-based access controls should distinguish public reporting from authorized municipal operations.

Official government email domains alone are not sufficient authentication. Municipal access should use verified identities, secure authentication, role-based authorization, and appropriate administrative approval.

### 4.9 Flood-Resilient Emergency Routing

The routing engine models road segments and drainage-related hazards as a weighted graph.

Candidate algorithms include:

- Dijkstra's algorithm for shortest-path calculations.
- A* for heuristic-guided route search.
- NetworkX for graph management and route analysis.

The system can assign penalties or exclude road segments marked as inaccessible due to verified flood depths, closures, or active hazard restrictions.

Routing recommendations depend on the quality and freshness of road and hazard data. The system must not assume that a road is safe simply because no sensor alert exists.

---

## 5. System Architecture

The platform consists of four interconnected layers.

### Layer 1: Physical Sensing and Actuation

**Components:**
- ESP32 development board.
- Pressure sensors.
- Ultrasonic water-level sensor.
- Flow sensors.
- Optional acoustic sensing.
- Optional gas-sensing array.
- Servo-operated experimental valve.
- Biofilter chamber.
- Pump and recirculating water testbench.

**Responsibilities:**
- Acquire sensor readings.
- Check basic sensor validity.
- Run local safety interlocks.
- Operate approved prototype control states.
- Transmit telemetry.

### Layer 2: Backend and Machine Learning

**Technologies:**
- Python.
- FastAPI.
- Pydantic.
- SQLAlchemy.
- SQLite for initial development.
- XGBoost and scikit-learn.
- NetworkX.
- MQTT or HTTPS for telemetry transport.

**Responsibilities:**
- Receive sensor data.
- Validate and store telemetry.
- Generate diagnostic outputs.
- Manage incidents and maintenance records.
- Provide REST endpoints.
- Calculate candidate emergency routes.

### Layer 3: Citizen and Municipal Applications

**Technologies:**
- Flutter.
- Dart.
- REST APIs.
- WebSockets, where required.

**Responsibilities:**
- Collect citizen reports.
- Display incident status.
- Present sensor information.
- Show maintenance alerts.
- Provide authorized municipal workflows.

### Layer 4: GIS and Digital Twin

**Technologies:**
- Leaflet or Mapbox.
- NetworkX.
- Geospatial data sources.
- Optional PostGIS for future scaling.

**Responsibilities:**
- Display drainage nodes and edges.
- Show flood and blockage alerts.
- Associate reports with geographic locations.
- Evaluate candidate emergency routes.
- Support infrastructure maintenance decisions.

### Data Flow

```text
Drainage Testbench
       |
       v
ESP32 + Sensors
       |
       +----> Local Safety Interlocks
       |                 |
       |                 v
       |         Experimental Actuator
       |
       v
MQTT / HTTPS Telemetry
       |
       v
FastAPI Backend
       |
       +----> Database
       |
       +----> ML Diagnostics
       |
       +----> Incident Management
       |
       +----> Graph-Based Routing
       |
       v
GIS Digital Twin
       |
       +----> Citizen Flutter App
       |
       +----> Municipal Dashboard
```

## 6. Hardware Requirements

The following is a proposed bill of materials. Exact components should be selected based on availability, electrical compatibility, and prototype requirements.

| Component | Purpose |
|---|---|
| ESP32-WROOM-32 development board | Sensor acquisition and local control |
| Waterproof ultrasonic sensor, such as JSN-SR04T | Chamber water-level estimation |
| Two compatible pressure transducers | Inlet/outlet pressure monitoring |
| Two flow sensors, such as YF-S201 | Inlet/outlet flow measurement |
| Piezoelectric or contact microphone sensor | Acoustic vibration monitoring |
| MQ-136 gas sensor, optional | Preliminary H₂S-oriented gas indication |
| MQ-4 gas sensor, optional | Preliminary methane-oriented gas indication |
| MQ-7 gas sensor, optional | Preliminary CO-oriented gas indication |
| Metal-gear servo, such as MG996R | Experimental valve actuation |
| Suitable valve and mechanical linkage | Controlled airflow testing |
| Stainless steel mesh | Coarse debris screening |
| Bio-balls or porous biofilter media | Biological media support |
| Granular activated carbon | Adsorption of selected compounds |
| PVC/uPVC pipe and fittings | Drainage testbench construction |
| Water tank and compatible pump | Controlled recirculating testbench |
| Regulated power supply | Stable power delivery |
| Fuse and protected wiring | Electrical fault protection |
| Suitable enclosure | Protection of electronic components |

**Hardware safety notes**

- A standard MG996R must not be assumed waterproof or IP66-rated. Use a suitable protected actuator assembly for wet environments.
- Check the servo's actual stall current and use a compatible power supply. Do not power a high-current servo directly from the ESP32's 3.3 V pin.
- Verify every sensor's supply voltage and output logic before connecting it to the ESP32.
- Use appropriate signal conditioning and level shifting where required.
- MQ gas sensors require suitable heater power, warm-up, and calibration. Their raw outputs should not be treated as certified ppm measurements without a validated measurement method.
- Do not expose electronics to live wastewater or uncontrolled pressure during prototype testing.

## 7. Software Requirements

| Software | Purpose |
|---|---|
| Python 3.11+ | Backend and model development |
| FastAPI | REST API and backend services |
| Uvicorn | ASGI development server |
| SQLAlchemy | Database access |
| SQLite | Initial local persistence |
| Pydantic | Input validation and schemas |
| XGBoost | Drainage condition classification |
| scikit-learn | Preprocessing and model evaluation |
| pandas and NumPy | Telemetry processing |
| NetworkX | Drainage and road graph algorithms |
| Flutter SDK | Cross-platform mobile application |
| Dart | Flutter application development |
| Arduino IDE or PlatformIO | ESP32 firmware development |
| Git and GitHub | Version control |
| Leaflet or Mapbox | GIS visualization |
| MQTT broker, optional | Sensor messaging |
| ngrok, optional | Temporary remote demonstration access |

Version compatibility should be checked when setting up the development environment.

## 8. Proposed Repository Structure

The following is a recommended organization. Adapt it to the actual files in your repository rather than creating empty modules just to match this diagram.

```text
AegisFlow-BioDrain/
|
├── firmware/
│   ├── src/
│   │   ├── main.cpp
│   │   ├── sensors.cpp
│   │   ├── sensors.h
│   │   ├── actuator.cpp
│   │   └── safety_logic.cpp
│   └── README.md
|
├── backend/
│   ├── app/
│   │   ├── main.py
│   │   ├── api/
│   │   │   ├── telemetry.py
│   │   │   ├── incidents.py
│   │   │   ├── diagnostics.py
│   │   │   └── routing.py
│   │   ├── services/
│   │   │   ├── sensor_service.py
│   │   │   ├── diagnostic_service.py
│   │   │   └── routing_service.py
│   │   ├── models/
│   │   ├── schemas/
│   │   ├── database.py
│   │   └── config.py
│   ├── requirements.txt
│   └── README.md
|
├── ml/
│   ├── data/
│   ├── notebooks/
│   ├── train_model.py
│   ├── evaluate_model.py
│   └── README.md
|
├── biofilter/
│   ├── design/
│   ├── test_results/
│   └── README.md
|
├── digital_twin/
│   ├── graph_model.py
│   ├── gis/
│   └── README.md
|
├── mobile_app/
│   ├── lib/
│   └── README.md
|
├── docs/
│   ├── architecture.md
│   ├── hardware_setup.md
│   ├── api_documentation.md
│   ├── safety_and_testing.md
│   └── images/
|
├── tests/
│   ├── test_api.py
│   ├── test_diagnostics.py
│   └── test_routing.py
|
├── .env.example
├── .gitignore
├── requirements.txt
└── README.md
```

## 9. Installation and Setup

### Prerequisites

Install:

- Python 3.11 or a compatible supported version.
- Git.
- Visual Studio Code or another Python IDE.
- Flutter SDK if building the mobile application.
- Arduino IDE or PlatformIO if building the firmware.

### Step 1: Clone the Repository

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
cd AegisFlow-BioDrain
```

Replace the placeholder with your actual GitHub repository URL.

### Step 2: Create a Python Virtual Environment

On Windows PowerShell:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

If PowerShell blocks activation, use an appropriate local Python environment setup or activate the environment through your IDE.

On Linux or macOS:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

### Step 3: Install Backend Dependencies

If the repository has a root `requirements.txt`:

```bash
pip install -r requirements.txt
```

Alternatively, if dependencies are maintained under `backend/`:

```bash
pip install -r backend/requirements.txt
```

Do not maintain conflicting dependency lists without a clear reason.

### Step 4: Configure Environment Variables

Create a local `.env` file based on `.env.example`.

Example:

```dotenv
APP_NAME=AegisFlow-BioDrain
ENVIRONMENT=development
DATABASE_URL=sqlite:///./aegisflow.db
API_HOST=127.0.0.1
API_PORT=8000
```

Add authentication secrets, MQTT credentials, or external service keys only when those features are implemented.

**Never commit `.env` or real API keys to GitHub.**

### Step 5: Run the FastAPI Backend

If your FastAPI application is located at `backend/app/main.py`:

```bash
uvicorn backend.app.main:app --reload
```

If you run the command from inside the `backend` directory:

```bash
uvicorn app.main:app --reload
```

Use the command that matches the actual Python package structure.

The local API is normally available at:

- API base: `http://127.0.0.1:8000`
- Interactive API documentation: `http://127.0.0.1:8000/docs`
- Alternative API documentation: `http://127.0.0.1:8000/redoc`

These addresses are available only when the server is running locally.

### Step 6: Connect the ESP32

1. Install the required ESP32 board package.
2. Select the correct board and serial port.
3. Configure sensor pins in the firmware.
4. Check the sensor voltage and signal compatibility.
5. Test each sensor independently.
6. Configure Wi-Fi and telemetry settings securely.
7. Verify that the backend receives valid readings.
8. Test local actuator safety interlocks before enabling movement.

Keep hardware control disabled during initial software testing.

### Step 7: Run the Flutter Application

After creating or locating the Flutter application:

```bash
cd mobile_app
flutter pub get
flutter run
```

For a web build, if the project supports Flutter Web:

```bash
flutter run -d chrome
```

Configure the application to use the correct backend address. An Android emulator generally uses `10.0.2.2` to access the host machine's localhost. A physical phone normally needs the computer's reachable local-network address.

Do not expose a development server to the public internet without suitable authentication and security controls.

## 10. Sensor Telemetry Design

A proposed telemetry message can use JSON:

```json
{
  "device_id": "drain-node-001",
  "timestamp": "2026-10-26T00:00:00Z",
  "pressure_in": 101.2,
  "pressure_out": 98.7,
  "flow_in": 4.5,
  "flow_out": 3.1,
  "water_level_cm": 18.0,
  "level_rise_cm_s": 0.4,
  "acoustic_feature": 0.0,
  "gas_readings": {
    "h2s_sensor_raw": null,
    "methane_sensor_raw": null,
    "co_sensor_raw": null
  }
}
```

This is an illustrative schema, not a measurement from a deployed device.

All readings must include appropriate units, calibration information, and validation. Gas fields are represented as raw or unavailable values rather than falsely implying calibrated concentrations.

The backend should validate:

- Required fields.
- Device identity.
- Numeric ranges.
- Timestamps and stale data.
- Sensor faults and missing values.
- Authentication and authorization.
- Duplicate or out-of-order messages.

## 11. Hydraulic Feature Engineering

### Differential Pressure

For calibrated inlet and outlet measurements:

\[
\Delta P=P_{\mathrm{in}}-P_{\mathrm{out}}
\]

A persistent difference may indicate a hydraulic restriction, but it does not independently prove a blockage or trapped-air condition.

### Flow Difference

\[
\Delta Q=Q_{\mathrm{in}}-Q_{\mathrm{out}}
\]

A sustained difference can indicate temporary water storage, leakage, measurement errors, or changes in operating conditions.

### Water-Level Rise Rate

\[
\frac{dH}{dt}\approx\frac{H_t-H_{t-\Delta t}}{\Delta t}
\]

This feature helps identify rapidly rising chamber levels.

### Sensor Fusion

Pressure, flow, water level, and acoustic information can be combined to improve diagnostic confidence. The model should account for sensor uncertainty, changing rainfall intensity, pump operation, and different pipe geometries.

Thresholds must be calibrated for the testbench and validated before use in a real drainage network.

## 12. Machine Learning Methodology

### Proposed Model

**Algorithm:** XGBoost classifier.

**Task:** Multiclass classification of drainage conditions.

### Proposed Classes

| Class | Condition | Suggested response |
|---|---|---|
| 0 | Normal operation | Continue monitoring |
| 1 | Possible air-binding or hydraulic anomaly | Validate readings and inspect operating conditions |
| 2 | Potential biofilter fouling | Schedule filter inspection |
| 3 | Suspected drainage blockage | Raise a maintenance alert |
| 4 | Potential environmental gas hazard | Apply the approved safety response and professional assessment |

The class definitions are proposed and should be finalized alongside the training dataset.

### Training Workflow

1. Collect or simulate sensor telemetry under controlled conditions.
2. Label each record using known testbench conditions.
3. Check missing values, measurement errors, and class balance.
4. Create training, validation, and test datasets.
5. Train the XGBoost model.
6. Evaluate performance on unseen test data.
7. Review the confusion matrix and class-specific recall.
8. Save the model and preprocessing configuration.
9. Integrate inference into FastAPI.
10. Monitor model errors and retrain only with validated data.

### Evaluation Metrics

- Accuracy.
- Precision.
- Recall.
- Macro F1-score.
- Confusion matrix.
- False-negative rate for critical conditions.

A high overall accuracy is not sufficient when hazardous conditions are rare. Testing must specifically examine whether critical cases are missed.

**Important:** Do not report model accuracy or claim successful real-time prediction until measured results are available.

## 13. Smart Auto-Vent Control Strategy

The Smart Auto-Vent should operate as a locally controlled experimental mechanism rather than depending entirely on a remote server.

### Proposed Control States

- **IDLE:** Continue sensing while the valve remains in its validated safe state.
- **SUSPECTED AIR-BINDING:** Evaluate pressure, water level, and supporting sensor evidence.
- **VENT ELIGIBLE:** Permit a short controlled vent cycle only if validated operating conditions and safety interlocks are satisfied.
- **HIGH WATER LEVEL:** Inhibit unsafe valve actions and follow the tested high-water response.
- **GAS HAZARD:** Raise an alarm, restrict access, and follow the approved gas-management procedure. Do not automatically release hazardous gas into an occupied area.
- **SENSOR FAULT:** Report the fault and enter a predefined safe control state.
- **MANUAL OVERRIDE:** Allow an authorized operator to disable automatic actuation.

### Control Requirements

- Apply hysteresis to prevent rapid valve oscillation.
- Set a maximum actuation duration.
- Check sensor validity before actuation.
- Verify valve position where suitable feedback is available.
- Provide watchdog and communication-failure handling.
- Test for backflow, flooding, and loss of power.
- Keep local safety logic independent of cloud availability.

The exact opening and closing thresholds must be determined from the mechanical design and controlled testing. A single pressure threshold must not be assumed suitable for every drainage installation.

## 14. Biofilter Design and Testing

### Stage 1: Debris Screen

Use a removable screen to capture larger debris. Design the screen for inspection and cleaning.

### Stage 2: Sediment Sump

Use a baffled chamber to encourage grit and heavier suspended material to settle.

### Stage 3: Biological Media

Provide appropriate surface area and conditions for biofilm development. Biological performance depends on media characteristics, temperature, oxygen availability, loading, and retention time.

### Stage 4: Activated Carbon

Use suitable activated carbon for adsorption of selected compounds. Adsorption performance decreases as media becomes exhausted, so inspection and replacement criteria are required.

### Stage 5: Bypass and Discharge

Design a bypass path that reduces the chance of the treatment module causing upstream flooding when the screen or media becomes clogged.

### Recommended Experiments

- Compare inlet and outlet turbidity.
- Measure suspended solids where equipment is available.
- Measure BOD and COD through an appropriate laboratory method.
- Record pressure drop across the filter.
- Measure flow before and after filter loading.
- Observe sediment accumulation.
- Track performance as the media becomes fouled.
- Test bypass operation under controlled conditions.

Use clean, contained prototype water for early testing. Do not discharge experimental wastewater into a natural water body without appropriate treatment and authorization.

## 15. Digital Twin and Routing Logic

### Drainage Graph

Represent drainage infrastructure as nodes and connected pipe edges.

Each edge can contain:

- Length.
- Pipe diameter.
- Estimated capacity.
- Current condition.
- Sensor freshness.
- Blockage probability.
- Maintenance status.

Each node can contain:

- Geographic location.
- Water level.
- Pressure observations.
- Incident history.
- Associated biofilter status.

### Emergency Road Graph

Represent the road network separately from the drainage network.

Road edges can include:

- Travel distance.
- Estimated travel time.
- Flood-depth observations.
- Road closure status.
- Hazard restrictions.
- Vehicle-access constraints.

### Routing Workflow

1. Load the road graph.
2. Obtain current and timestamped hazard observations.
3. Identify verified closures and unsafe segments.
4. Apply exclusions or penalties to affected edges.
5. Calculate a candidate route using Dijkstra or A*.
6. Return the route and the data supporting the recommendation.
7. Mark the route as uncertain when hazard information is missing or stale.

The road graph should not assume that drainage pipes and roads share identical connections. Their relationship must be explicitly represented using geospatial links or documented mappings.

## 16. Proposed API Endpoints

The following routes are a suggested interface. They become available only after their corresponding handlers are implemented.

| Method | Endpoint | Purpose |
|---|---|---|
| GET | `/` | API status |
| GET | `/health` | Application health check |
| POST | `/api/telemetry` | Receive sensor telemetry |
| GET | `/api/telemetry/latest` | Retrieve recent readings |
| GET | `/api/telemetry/{device_id}` | Retrieve device observations |
| POST | `/api/diagnostics/predict` | Classify a validated sensor record |
| GET | `/api/nodes` | Retrieve drainage nodes |
| GET | `/api/edges` | Retrieve drainage connections |
| POST | `/api/incidents` | Create an incident report |
| GET | `/api/incidents` | List incidents |
| PATCH | `/api/incidents/{incident_id}` | Update incident status |
| POST | `/api/routes/plan` | Calculate a candidate route |
| GET | `/api/biofilters/status` | Retrieve filter condition information |

Protect sensitive endpoints with authentication and authorization. Validate all inputs, rate-limit public endpoints where appropriate, and log administrative actions.

## 17. Database Design

A relational database can store the following entities.

### Devices

- Device ID.
- Device type.
- Installation location.
- Active status.
- Last-seen timestamp.

### Telemetry

- Record ID.
- Device ID.
- Timestamp.
- Sensor values.
- Calibration or quality flags.

### Drainage Nodes and Edges

- Node ID.
- Geographic coordinates.
- Edge ID.
- Connected nodes.
- Pipe attributes.
- Current operational status.

### Incidents

- Incident ID.
- Incident category.
- Geographic location.
- Report description.
- Severity.
- Creation timestamp.
- Resolution status.
- Assigned team.

### Biofilter Maintenance

- Filter ID.
- Last inspection date.
- Differential pressure.
- Cleaning history.
- Media replacement history.
- Maintenance status.

### Diagnostic Results

- Prediction ID.
- Source telemetry record.
- Predicted class.
- Model version.
- Confidence or calibrated probability, if supported.
- Timestamp.

SQLite is suitable for an initial prototype. A larger deployment may require PostgreSQL with PostGIS, appropriate backup policies, and managed access controls.

## 18. Security and Privacy

AegisFlow-BioDrain is designed around the following security principles:

- Use HTTPS for communication outside a trusted local test environment.
- Store credentials and API secrets in environment variables or a secret manager.
- Implement role-based authorization for municipal operations.
- Verify the identity of IoT devices before accepting telemetry.
- Validate all API payloads.
- Protect administrative endpoints.
- Avoid storing unnecessary personal information.
- Obtain permission before accessing or storing a citizen's location.
- Define retention rules for location data, photographs, and incident history.
- Log important maintenance and administrative actions.
- Keep development credentials separate from deployment credentials.

For demonstrations, temporary tunneling tools should not be treated as substitutes for authentication, authorization, and secure deployment.

## 19. Safety and Standards-Aligned Design

Safety measures are essential because the project combines water, electricity, mechanical actuation, and potentially hazardous gases.

### Electrical Protection

- Use suitable regulated power supplies.
- Install appropriate fuses and overcurrent protection.
- Separate high-current actuator wiring from sensitive signal circuits where appropriate.
- Verify grounding and isolation requirements.
- Protect electronics from moisture.

### Mechanical Protection

- Secure pipe connections and pump fittings.
- Validate valve seating and actuator travel.
- Use suitable seals and corrosion-resistant materials.
- Test for leakage and unexpected movement.

### Gas Hazard Protection

- Treat low-cost gas sensors as preliminary indicators.
- Use suitable calibrated and certified instruments for occupational safety decisions.
- Never enter a hazardous chamber based solely on prototype readings.
- Do not direct potentially toxic vent exhaust toward people or buildings.

### Standards

Design and testing should reference the applicable requirements for the actual installation, which may include relevant IEC electrical-safety standards, enclosure-protection requirements, sensor manufacturer specifications, and local environmental and occupational-safety rules.

Formal standards compliance or certification must not be claimed unless the relevant requirements have been assessed and the necessary testing or certification has been completed.

## 20. Testing and Validation Plan

### Phase 1: Software Validation

- Verify API startup.
- Test valid and invalid payloads.
- Verify database persistence.
- Test diagnostic output handling.
- Test graph connectivity and route calculation.
- Verify authentication and authorization.

### Phase 2: Sensor Validation

- Compare readings against suitable reference instruments.
- Record sensor noise and drift.
- Test missing or disconnected sensors.
- Check timestamp handling.
- Verify units and calibration.

### Phase 3: Hydraulic Testbench

- Establish a normal-flow baseline.
- Introduce controlled debris obstruction.
- Measure pressure and flow changes.
- Observe water-level rise.
- Test filter loading and cleaning.
- Compare observed conditions with diagnostic predictions.

### Phase 4: Auto-Vent Validation

- Test valve movement without water pressure.
- Verify actuator limits and manual override.
- Test sensor faults and communication loss.
- Conduct controlled pressure and leak tests.
- Verify safe operation under high water levels.
- Test failure modes before any automatic actuation.

### Phase 5: Biofilter Validation

- Compare inlet and outlet water-quality measurements.
- Record flow and pressure drop.
- Test bypass operation.
- Track media fouling.
- Determine cleaning and replacement intervals.

### Phase 6: Integrated Demonstration

- Transmit testbench telemetry.
- Display readings in the backend.
- Run diagnostics on recorded or simulated data.
- Display a sample drainage network.
- Submit a simulated citizen incident.
- Generate a candidate maintenance or emergency route.

All tests should be documented with their setup, results, limitations, and supporting evidence.

## 21. Development Roadmap

### Milestone 1 — Physical Drainage Prototype

- Construct the pipe and chamber testbench.
- Integrate the ESP32 and selected sensors.
- Establish reliable pressure, flow, and water-level readings.
- Build the initial SmartDrain physical layout.

### Milestone 2 — Smart Auto-Vent and Biofilter

- Develop the experimental servo valve.
- Implement local safety interlocks.
- Assemble the debris screen and sediment sump.
- Add biological media and activated carbon.
- Test filter fouling and bypass behavior.

### Milestone 3 — Backend and AI Diagnostics

- Develop FastAPI telemetry endpoints.
- Store sensor data.
- Prepare labeled diagnostic datasets.
- Train and evaluate the XGBoost model.
- Implement fault and maintenance alerts.

### Milestone 4 — Digital Twin and Emergency Routing

- Model the drainage network as a graph.
- Visualize sensor status and suspected blockages.
- Build the road-routing graph.
- Integrate flood and road-closure information.
- Validate route recommendations.

### Milestone 5 — Citizen and Municipal Applications

- Develop Flutter incident reporting.
- Add incident status tracking.
- Implement secure municipal roles.
- Build the operations dashboard.
- Connect the mobile applications to the backend.

### Milestone 6 — Integrated Testing and Demonstration

- Validate sensor-to-dashboard communication.
- Test the prototype under controlled conditions.
- Evaluate model performance.
- Demonstrate incident-to-maintenance workflows.
- Document safety tests and limitations.
- Prepare evidence for project evaluation.

These milestones describe the proposed development plan; actual completion should be updated to match repository evidence and test results.

## 22. Expected Outcomes

When implemented and validated, the system aims to provide:

- Earlier identification of drainage abnormalities.
- Better visibility into underground infrastructure conditions.
- More structured maintenance prioritization.
- Preliminary debris and sediment management.
- Experimental evaluation of trapped-air mitigation.
- Improved tracking of potential environmental hazards.
- Better coordination between citizen reports and technical observations.
- Data-driven emergency routing recommendations.
- A reusable prototype architecture for future smart-city research.

Actual improvements in flood depth, response time, pollutant removal, and worker safety must be demonstrated through measured testing rather than assumed from the design.

## 23. Innovation and Impact

### Integrated Physical and Digital Infrastructure

Combines IoT sensing, machine learning, physical drainage experimentation, and network visualization.

### Active Mitigation Research

Investigates a controlled servo-operated air-release mechanism with local safety interlocks.

### Biofiltration Integration

Combines coarse screening, sediment settling, biological media, and adsorption within a modular prototype.

### Predictive Maintenance

Uses sensor trends and classification outputs to support inspection and maintenance planning.

### Connected Emergency Response

Links incident reporting with drainage observations, municipal workflows, and candidate routes.

### Frugal and Modular Design

Uses accessible development hardware and open-source software to support iterative experimentation and future scaling.

## 24. Limitations

- Sensor accuracy depends on calibration, installation, and environmental conditions.
- A pressure difference alone cannot reliably distinguish a blockage from trapped air.
- The ML model requires representative, labeled data and independent validation.
- Low-cost MQ sensors are not substitutes for certified toxic-gas instruments.
- Activated carbon does not guarantee safe treatment of all toxic gases or stormwater contaminants.
- Biological filtration requires suitable operating conditions and regular maintenance.
- A prototype-scale bypass does not automatically prove full-scale flood protection.
- A servo-operated valve is not a certified pressure-relief device unless appropriately designed and tested.
- Routing quality depends on accurate road, flood, and hazard data.
- Municipal deployment requires site-specific hydraulic engineering, permissions, maintenance planning, and safety assessment.

## 25. Future Enhancements

- Add LoRaWAN or other suitable long-range telemetry for distributed drainage nodes.
- Develop robust edge anomaly detection.
- Add rainfall forecasts and weather data integration.
- Evaluate digital-twin simulations of surcharge and flow.
- Incorporate calibrated gas detectors for controlled occupational-safety applications.
- Develop maintenance scheduling based on sensor history.
- Investigate GIS integration with authorized municipal infrastructure data.
- Add audit logs and stronger device identity management.
- Evaluate more advanced hydraulic simulation and sensor-fusion methods.
- Conduct extended field trials after appropriate engineering and safety review.

## 26. Contribution Guidelines

Contributions are welcome in hardware prototyping, embedded firmware, backend development, machine learning, GIS, Flutter, testing, and documentation.

Suggested workflow:

1. Fork the repository.
2. Create a feature branch.
3. Keep changes focused and documented.
4. Add tests for new backend or diagnostic functionality.
5. Document hardware assumptions and safety implications.
6. Open a pull request describing the changes and validation performed.

Never submit untested actuator logic as field-ready safety control.

## 27. License

Choose a license appropriate to the project's ownership and intended use before publishing. If a license has not yet been selected, the repository should not claim that it is open-source under a specific license.

For example, the MIT License may be considered for software components, but hardware designs, documentation, and third-party dependencies may require separate licensing review.

## 28. Acknowledgements

This project is developed as an urban drainage monitoring, flood mitigation, and smart infrastructure research initiative, with potential relevance to sanitation safety, resilient infrastructure, environmental management, and municipal emergency response.

The project is intended to support the objectives of innovation initiatives such as the AICTE Chhatra Vishwakarma Awards, subject to the applicable eligibility and submission requirements.

## 29. Conclusion

**AegisFlow-BioDrain** proposes a unified approach to smarter urban drainage through IoT sensing, AI-assisted diagnostics, experimental servo-actuated air release, modular biofiltration, digital-twin visualization, citizen reporting, and flood-aware emergency routing.

By connecting physical infrastructure with data-driven decision support, the project aims to help identify drainage problems earlier, prioritize maintenance, and improve coordination during urban flooding events.

Its long-term value depends on reliable sensor data, validated models, effective filtration testing, safe mechanical design, and transparent evaluation under realistic conditions.

**AegisFlow-BioDrain — Intelligent Drainage. Safer Infrastructure. Resilient Cities.**
