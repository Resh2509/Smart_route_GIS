#include <ESP32Servo.h>

// ==================== Pin Definitions (ESP32) ====================
const int FLOW_SENSOR_PIN = 2;   // Pulse output from YF-S201
const int WATER_LEVEL_PIN = 34;  // Analog input from Water Level Sensor
const int PRESSURE_PIN    = 35;  // Analog input from Pressure Transducer
const int SERVO_PIN       = 18;  // PWM output for Servo Auto-Vent

// ==================== Calibration Constants ====================
const float FLOW_CALIBRATION_FACTOR = 7.5; // Pulses/sec per L/min for YF-S201
const float ESP32_VOLTAGE           = 3.3; // ESP32 ADC reference voltage
const int   ADC_RESOLUTION          = 4095; // ESP32 has a 12-bit ADC (0 to 4095)

// Pressure Sensor Specs (Scaled for voltage divider or 3.3V reference)
const float PRESSURE_VMIN = 0.5;   // Sensor baseline voltage
const float PRESSURE_VMAX = 4.5;   // Sensor maximum voltage
const float MAX_PRESSURE_KPA = 1200.0; // 1.2 MPa = 1200 kPa

// Servo Angles
const int VENT_CLOSED_ANGLE = 0;
const int VENT_OPEN_ANGLE   = 90;

// Thresholds for Biofilter & Gas Inundation
const float FLOW_STAGNANT_THRESHOLD  = 0.5;   // Below 0.5 L/min = stagnant
const float GAS_PRESSURE_THRESHOLD   = 108.0; // Over ~108 kPa = biogas pocket build-up

// ==================== Global Variables ====================
volatile unsigned long pulseCount = 0;
unsigned long lastSampleTime = 0;
Servo autoVentServo;

// Interrupt Service Routine for Flow Counter
void IRAM_ATTR pulseCounter() {
  pulseCount++;
}

void setup() {
  // Set Serial Monitor to 115200 baud to eliminate garbage characters
  Serial.begin(115200);
  delay(1000);

  // Setup Flow Sensor Pin
  pinMode(FLOW_SENSOR_PIN, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(FLOW_SENSOR_PIN), pulseCounter, RISING);

  // Setup Analog Inputs
  pinMode(WATER_LEVEL_PIN, INPUT);
  pinMode(PRESSURE_PIN, INPUT);

  // Setup Servo using ESP32 PWM allocation
  ESP32PWM::allocateTimer(0);
  autoVentServo.setPeriodHertz(50); // Standard 50Hz servo
  autoVentServo.attach(SERVO_PIN, 500, 2400);
  autoVentServo.write(VENT_CLOSED_ANGLE);

  Serial.println("==================================================");
  Serial.println(" AegisFlow-BioDrain: Multi-Sensor & Gas Matrix   ");
  Serial.println("==================================================");
}

void loop() {
  unsigned long currentTime = millis();

  // Update calculations and display once every second (1000 ms)
  if (currentTime - lastSampleTime >= 1000) {
    // 1. Calculate Flow Rate (L/min)
    detachInterrupt(digitalPinToInterrupt(FLOW_SENSOR_PIN));
    float flowRate = ((float)pulseCount / FLOW_CALIBRATION_FACTOR);
    pulseCount = 0;
    attachInterrupt(digitalPinToInterrupt(FLOW_SENSOR_PIN), pulseCounter, RISING);

    // 2. Read Water Level (Percentage)
    int rawWaterADC = analogRead(WATER_LEVEL_PIN);
    float waterLevelPercent = map(rawWaterADC, 0, ADC_RESOLUTION, 0, 100);
    waterLevelPercent = constrain(waterLevelPercent, 0, 100);

    // 3. Read Pressure Sensor (kPa)
    int rawPressureADC = analogRead(PRESSURE_PIN);
    float voltage = (rawPressureADC / (float)ADC_RESOLUTION) * ESP32_VOLTAGE;
    
    // Scale voltage to pressure
    float pressureKPa = 101.325; // Standard atmospheric pressure
    if (voltage >= PRESSURE_VMIN) {
      pressureKPa = 101.325 + ((voltage - PRESSURE_VMIN) / (PRESSURE_VMAX - PRESSURE_VMIN)) * MAX_PRESSURE_KPA;
    }

    // 4. Gas Accumulation Diagnostic Algorithm
    int gasRiskPercent = 0;
    String gasStatus = "NORMAL";

    if (flowRate <= FLOW_STAGNANT_THRESHOLD && waterLevelPercent > 10.0) {
      if (pressureKPa > GAS_PRESSURE_THRESHOLD) {
        gasRiskPercent = map((long)(pressureKPa * 10), (long)(GAS_PRESSURE_THRESHOLD * 10), 1250, 60, 100);
        gasRiskPercent = constrain(gasRiskPercent, 60, 100);
        gasStatus = "CRITICAL: Trapped Biogas Formed";
      } else if (pressureKPa > 103.0) {
        gasRiskPercent = map((long)(pressureKPa * 10), 1030, (long)(GAS_PRESSURE_THRESHOLD * 10), 20, 59);
        gasRiskPercent = constrain(gasRiskPercent, 20, 59);
        gasStatus = "WARNING: Moderate Gas Build-up";
      } else {
        gasRiskPercent = 10;
        gasStatus = "LOW: Passive Infiltration";
      }
    } else {
      gasRiskPercent = 5;
      gasStatus = "STABLE: Dynamic Flow";
    }

    // 5. Smart Auto-Vent Actuation
    if (gasRiskPercent >= 60) {
      autoVentServo.write(VENT_OPEN_ANGLE); // Purge gas accumulation
    } else {
      autoVentServo.write(VENT_CLOSED_ANGLE); // Seal chamber
    }

    // 6. Serial Monitor Output
    Serial.println("--------------------------------------------------");
    Serial.print("Water Flow Rate:      "); Serial.print(flowRate, 2); Serial.println(" L/min");
    Serial.print("Chamber Water Level:  "); Serial.print(waterLevelPercent, 1); Serial.println(" %");
    Serial.print("Internal Pressure:    "); Serial.print(pressureKPa, 2); Serial.println(" kPa");
    Serial.print("Estimated Gas Pocket: "); Serial.print(gasRiskPercent); Serial.println(" %");
    Serial.print("System Status:        "); Serial.println(gasStatus);
    Serial.print("Auto-Vent Servo:      ");
    if (gasRiskPercent >= 60) {
      Serial.println("OPEN (90 deg - Relieving Gas Pressure)");
    } else {
      Serial.println("CLOSED (0 deg - Chamber Sealed)");
    }

    lastSampleTime = currentTime;
  }
}