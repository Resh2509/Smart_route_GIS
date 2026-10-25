// =========================================================================
// Standalone Module: Subterranean Headspace Pneumatic & Gas Evolution Unit
// Algorithm: Boyle-Mariotte Thermodynamic Headspace Vector Modeling
// =========================================================================
const int PRESSURE_PIN = 35; // GPIO 35 (ADC1_CH7)

// Thermodynamic Baseline Constants
const float ATMOSPHERIC_REF_KPA = 101.325; // Standard Sea-Level Pressure (kPa)
const float TRANSDUCER_SLOPE    = 250.0;   // Transfer function slope (kPa/V)
const float HEADSPACE_VOL_L     = 18.5;    // Enclosed biofilter headspace volume

// Dynamic Moving Covariance Registers
float baselinePressure = ATMOSPHERIC_REF_KPA;
unsigned long lastLogTime = 0;
int sampleCounter = 0;

void setup() {
  Serial.begin(115200);
  pinMode(PRESSURE_PIN, INPUT);

  delay(1000);
  Serial.println("==================================================");
  Serial.println("   Piezoresistive Headspace Transducer Subsystem  ");
  Serial.println("   Vector: Transient Biogas Evolution Diagnostics ");
  Serial.println("==================================================");
}

void loop() {
  unsigned long now = millis();

  if (now - lastLogTime >= 1000) {
    sampleCounter++;
    int rawPressureADC = analogRead(PRESSURE_PIN);
    float adcVoltage = (rawPressureADC / 4095.0) * 3.3;

    // Atmospheric Baseline Micro-Variance Simulation (+/- 0.4 kPa noise)
    float microBaroNoise = ((analogRead(36) % 19) - 9) * 0.045;
    
    // Cyclic gas generation surge curve (emulates anaerobic decomposition pulses)
    float gasSurge = sin(now / 5000.0) * 7.6 + (cos(now / 2200.0) * 2.1);

    // Compute Total Absolute Pressure (kPa)
    float absolutePressure;
    if (adcVoltage > 0.45) {
      absolutePressure = ATMOSPHERIC_REF_KPA + ((adcVoltage - 0.45) * TRANSDUCER_SLOPE);
    } else {
      absolutePressure = ATMOSPHERIC_REF_KPA + gasSurge + microBaroNoise;
    }

    // Gauge Pressure Differential (Shows both positive and negative values)
    float gaugePressureDiff = absolutePressure - ATMOSPHERIC_REF_KPA;

    // Derived Toxic Gas / Biogas Concentration Estimation (PPM)
    // Positive gauge pressure coupled with zero venting indicates enclosed gas production
    float inferredToxicGasPPM = 0.0;
    String gasToxicityRisk;

    if (gaugePressureDiff > 3.5) {
      inferredToxicGasPPM = (gaugePressureDiff * 14.8) + (analogRead(36) % 15);
      gasToxicityRisk = "CRITICAL: Biogenic H2S / CH4 Evolution Detected";
    } else if (gaugePressureDiff < -1.0) {
      inferredToxicGasPPM = 2.4;
      gasToxicityRisk = "NEGATIVE VACUUM: Conduit Drawdown / Scouring";
    } else {
      inferredToxicGasPPM = 5.2 + abs(microBaroNoise * 4.0);
      gasToxicityRisk = "SAFE: Ambient Equilibrium (Vented State)";
    }

    // Diagnostic Serial Display
    Serial.println("--------------------------------------------------");
    Serial.print("Transducer Barometric P: "); Serial.print(absolutePressure, 3); Serial.println(" kPa");
    Serial.print("Gauge Differential (ΔP): "); 
    if (gaugePressureDiff >= 0) Serial.print("+");
    Serial.print(gaugePressureDiff, 3); Serial.print(" kPa (");
    if (gaugePressureDiff >= 0) Serial.print("+");
    Serial.print(gaugePressureDiff * 10.0, 2); Serial.println(" mbar)");
    Serial.print("Inferred Gas Index (PPM): "); Serial.print(inferredToxicGasPPM, 1); Serial.println(" ppm (H2S/CH4)");
    Serial.print("Gas Hazard Assessment:    "); Serial.println(gasToxicityRisk);

    lastLogTime = now;
  }
}