import paho.mqtt.client as mqtt 
import time, sys, MQTT_Module, GLOBAL_FLAGS

IP, PORT, CLIENT_ID = MQTT_Module.cli_inputs() #Parse IP Address, Port Number, and MQTT Client type (CV, AV, RSU) via CLI inputs
 
client = mqtt.Client(CLIENT_ID) #Create CV (sensor) instance of MQTT Client 

MQTT_Module.link_callbacks(client)          #Link custom callbacks to MQTT Mosquitto/Paho Client

client.connect(IP, PORT)        #Connect CV (sensor) to MQTT Broker
time.sleep(1)

client.subscribe("Emergency/STOP_VRU") #Subscribe CV or AV (sensors) to Emergency_Actuation for RSU actuation messages
time.sleep(1)

client.loop_start() #Start loop to handle incoming messages 

while GLOBAL_FLAGS.emergency_flag == 0: 

    MQTT_Module.sensor_message(CLIENT_ID, client) #Send initial messaage
    time.sleep(0.1) #Send next readout message in 100 ms (10 messages per second)
    
    #print("EMERGENCY_FLAG = ", GLOBAL_FLAGS.emergency_flag)

client.loop_stop()
client.disconnect()
