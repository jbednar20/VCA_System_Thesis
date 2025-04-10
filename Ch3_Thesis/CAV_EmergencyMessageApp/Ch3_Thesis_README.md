
# CAV_EmergencyMessageApp README 

The CAV Emergency Message Application (CAV_EmergencyMessageApp) provides a proof-of-concept prototype for MQTT-based emergency messaging betweeen an emulated connected vehicle (CV) acting as a sensor and an emulated roadside unit (RSU) device acting as an MQTT broker-based application. The intent of this README is to provide a brief overview of the codebase, along with basic instructions for how to use it. For detailed, step-by-step usage see Chapter 3, Section 4 of the thesis (full text available in root directory of this repo). 

## Overview of Files
The code for this project consists of four files, each of which is written in Python: 

1. **MQTT_Module.py** defines a library of common functions that are used by both the MQTT sensor (emulated CV) and the MQTT application (emulated RSU). These functions define the behavor of the MQTT sensor and the MQTT broker. This code should not be modified if one wants to run the prototype as executed in the thesis.

2. **GLOBAL_FLAGS.py** defines three flags: emergency_flag, qos_flag, and is_vru_flag. These global flags are defined in a seperate Python file to make them accessible to the **MQTT_Module.py**, along with the MQTT sensor and MQTT application code. The initial values for these flags should not be modified if one wants to run the prototype as executed in the thesis. For a detailed overview of functionality, see Chapter 3, Section 4 of the thesis. 

3. **MQTT_Sensors.py** defines the emulated CV behavior, which operates as an MQTT sensor in the context of this project. The user must pass inputs to **MQTT_Sensors.py**, as outlined in the execution example below. 

4. **MQTT_Application.py** defines the emulated RSU behavior, which operates as MQTT borker-based application in the context of this project. The user must pass inputs to **MQTT_Application.py**, as outlined in the execution example below. For a detailed overview of functionality, see Chapter 3, Section 4 of the thesis.

## Instructions 
To execute the CAV Emergency Message Application, please follow the below steps: 

1. Ensure that the machine you are using as the following Python libraries installed: time, sys, paho.mqtt.client, argparse, random, and json. The "pip install" command is a reliable way to accomplish this task.

2. On Linux-based systems, launch two instances of the terminal window. (On Windows, launching two instances of the command window is preferred). One instance will serve as execution platform for the MQTT sensor, and one instance will serve as the execution platform for the MQTT application. 

3. First, start-up the MQTT application instance by entering the following command into the selected terminal:

  python MQTT_Application.py -ip 127.0.0.1 -p 1883 -c RSU -qos 1 -vru 1

Note that the -ip flag defines the IP address (in this case localhost), -p defines the port, -c defines which client is used (RSU), -qos selects the MQTT QoS level, and -vru 1 assumes that a VRU will at some point present itself. 

4. Next, start the MQTT sensor instance by entering the following command into the other terminal:

  python MQTT_Sensors.py -ip 127.0.0.1 -p 1883 -c CV -qos 1 -vru 1

Note that the -ip flag defines the IP address (in this case localhost), -p defines the port, -c defines which client is used (CV), -qos selects the MQTT QoS level, and -vru 1 assumes that a VRU will at some point present itself. 

5. Allow the MQTT_Application and MQTT_Sensors programs to execute in each terminal. Execution will end once the CV has detected the presence of a VRU in the intersection and informs the RSU, which sends an emergency stop command. 

