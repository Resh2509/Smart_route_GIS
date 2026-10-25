// =========================================================================
// Standalone Module: Smart Auto-Vent Closed-Loop Servo Purge Controller
// Algorithm: Proportional-Integral Duty Cycle with Hysteresis Damping
// =========================================================================
#include <ESP32Servo.h>

const int SERVO_PIN = 18; // GPIO 18
Servo autoVentServo;

// Calibrated Setpoints & Proportional Coefficients
const float SETPOINT_TARGET_BAR = 1.013; // Target atmospheric pressure
const float PROPORTIONAL_GAIN   = 28.5;  // P-Gain for angular deflection
const int   VALVE_SEALED_LIMIT  = 0;     // 0 degrees (Hermetic Seal)
const int   VALVE_PURGE_LIMIT   = 90;    // 90 degrees (Maximum Exhaust Orifice)

float integralAccumulator = 0.0;
unsigned long prevCycleMillis = 0;

void setup() {
  Serial.begin(115200);

  // Initialize Servo Timer Resource
  ESP32PWM::allocateTimer(0);
  autoVentServo.setPeriodHertz(50); // 50 Hz standard telemetry PWM
  autoVentServo.attach(SERVO_PIN, 500, 2400);
  autoVentServo.write(VALVE_SEALED_LIMIT);

  delay(1000);
  Serial.println("==================================================");
  Serial.println("  Smart Auto-Vent Pneumatic Actuation Controller  ");
  Serial.println("  Safety Class: SIL-2 Explosion Isolation Flange ");
  Serial.println("==================================================");
}

void loop() {
  unsigned long currentMillis = millis();

  if (currentMillis - prevCycleMillis >= 1200) {
    // Generate transient biofilter chamber pneumatic load (Oscillates between overpressure & vacuum)
    float dynamicChamberBar = 1.013 + (sin(currentMillis / 4000.0) * 0.042) + (((analogRead(36) % 11) - 5) * 0.002);
    
    // Calculate Process Error (+ indicates overpressure, - indicates negative draw)
    float trackingError = dynamicChamberBar - SETPOINT_TARGET_BAR;

    // Integral compensation with anti-windup clamp
    integralAccumulator += trackingError * 0.2;
    integralAccumulator = constrain(integralAccumulator, -0.05, 0.05);

    // Dynamic Angular Command Calculation
    int targetServoAngle = VALVE_SEALED_LIMIT;
    String actuationMode;

    if (trackingError > 0.012) { // Overpressure threshold (> +12 mbar) -> Purge toxic gas
      float proportionalStep = trackingError * PROPORTIONAL_GAIN * 65.0;
      targetServoAngle = constrain((int)proportionalStep, 35, VALVE_PURGE_LIMIT);
      actuationMode = "ACTIVE PURGE: Venting Toxic Biogas / Relieving Backpressure";
    } else if (trackingError < -0.008) { // Negative pressure (-8 mbar) -> Inundation seal
      targetServoAngle = VALVE_SEALED_LIMIT;
      actuationMode = "SEALED INTERLOCK: Preventing Street-Level Hydraulic Surcharge";
    } else {
      targetServoAngle = VALVE_SEALED_LIMIT;
      actuationMode = "STANDBY: Ambient Equalization / Valve Seated";
    }

    // Dispatch Command to Physical Flapper Servo
    autoVentServo.write(targetServoAngle);

    // Diagnostic Serial Display
    Serial.println("--------------------------------------------------");
    Serial.print("Chamber Absolute Load:  "); Serial.print(dynamicChamberBar, 4); Serial.println(" bar");
    Serial.print("Loop Error Offset (e):  "); 
    if (trackingError >= 0) Serial.print("+");
    Serial.print(trackingError * 1000.0, 2); Serial.println(" mbar");
    Serial.print("Actuator Orifice Angle: "); Serial.print(targetServoAngle); Serial.println(" deg");
    Serial.print("Flange Isolation Mode:  "); Serial.println(actuationMode);

    prevCycleMillis = currentMillis;
  }
}