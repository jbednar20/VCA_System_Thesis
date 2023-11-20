import paho.mqtt.client as mqtt 
import time, sys, MQTT_Module, GLOBAL_FLAGS

IP, PORT, CLIENT_ID = MQTT_Module.cli_inputs() #Parse IP Address, Port Number, and MQTT Client type (CV, AV, RSU) via CLI inputs
client = mqtt.Client(CLIENT_ID)                    #Initialize MQTT Client w/ CLIENT_ID client name

MQTT_Module.link_callbacks(client) #Links custom MQTT callbacks from MQTT_Module for later use

client.connect(IP, PORT) #Connects given AV sensor (MQTT Client) instance to MQTT Broker
time.sleep(1)

client.subscribe("Vehicle_Readouts/Connected_Vehicle")  #Subscribe RSU (application) to Vehicle_Readouts/Connected_Vehicle topic (CV sensor readouts)
time.sleep(1)

client.subscribe("Vehicle_Readouts/Autonomous_Vehicle") #Subscribe RSU (application) to Vehicle_Readouts/Autonomous_Vehicle topic (AV sensor readouts)
time.sleep(1)

#Driver logic for RSU to listen for readout packets from CV or AV (sensors)

while True: 
    client.loop()

client.loop_stop()
client.disconnect()
