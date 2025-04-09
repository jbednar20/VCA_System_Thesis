
# CAV_EmergencyMessageApp README 

The CAV Emergency Message Application (CAV_EmergencyMessageApp) provides a proof-of-concept prototype for MQTT-based emergency messaging betweeen an emulated connected vehicle (CV) acting as a sensor and an emulated roadside unit (RSU) device acting as an MQTT broker-based application. The intent of this README is to provide a brief overview of the codebase, along with basic instructions for how to use it. For detailed, step-by-step usage see Chapter 3, Section 4 of the thesis (full text available in root directory of this repo). 

The code for this project consists of four files, each of which is written in Python: 

1. **MQTT_Module.py** defines a library of common functions that are used by both the MQTT sensor (emulated CV) and the MQTT application (emulated RSU). These functions define the behavor of the MQTT sensor and the MQTT broker. This code should not be modified if one wants to run the prototype as executed in the thesis.

2. **GLOBAL_FLAGS.py** defines three flags: emergency_flag, qos_flag, and is_vru_flag. These global flags are defined in a seperate Python file to make them accessible to the **MQTT_Module.py**, along with the MQTT sensor and MQTT application code. The initial values for these flags should not be modified if one wants to run the prototype as executed in the thesis. F
