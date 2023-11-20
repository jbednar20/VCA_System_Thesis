import paho.mqtt.client as mqtt 
import time as ts
import argparse, random, json, sys, GLOBAL_FLAGS

#Open-source web resources were used as examples for some of the below functions
#
#  cli_inputs() function based on https://stackoverflow.com/questions/11604653/how-to-add-command-line-arguments-with-flags-in-python3
#
#  on_log(), on_connect(), on_disconnect(), and link_callbacks() developed on examples in the below MQTT tutorial.
#  MQTT Tutorial: http://www.steves-internet-guide.com/mqtt-basics-course/

#Function: cli_inputs() parses inputs from CLI for use in codebaes
def cli_inputs(): 

    arg_parser = argparse.ArgumentParser() #Assign ArgumentParser() function to arg_parser handle

    arg_parser.add_argument("-ip", "--ip_address", help="IP Address")  #CLI input for IP Address (IPv4 or IPv6)
    arg_parser.add_argument("-p", "--port", help="Port Number")        #CLI input for Port Number 
    arg_parser.add_argument("-c", "--MQTT_client", help="MQTT Client") #CLI input for MQTT Client type (CV, AV, or RSU)
    arg_parser.add_argument("-qos", "--Quality_of_Service", help="Quality of Service")
    arg_parser.add_argument("-vru", "--Vulnerable_Road_User", help="Vulnerable Road User")

    args = arg_parser.parse_args() #Parse CLI arguements provided by the end-user

    IP = args.ip_address #Define IP Address via CLI Arguement
    
    PORT = int(args.port) #Define Port Number via CLI Arguement 
    
    GLOBAL_FLAGS.qos_flag = int(args.Quality_of_Service) 

    GLOBAL_FLAGS.is_vru_flag = int(args.Vulnerable_Road_User)

    if args.MQTT_client == 'CV':

        CLIENT_ID = 'Connected_Vehicle' #Define CLIENT_ID as 'Connected_Vehicle' for 'CV' MQTT_client CLI arguement

    elif args.MQTT_client == 'AV':

        CLIENT_ID = 'Autonomous_Vehicle' #Define CLIENT_ID as 'Autonomous_Vehicle' for 'AV' MQTT_client CLI arguement
    
    elif args.MQTT_client == 'RSU': 

        CLIENT_ID = 'Roadside_Unit' #Define CLIENT_ID as 'Roadside_Unit' for 'RSU' MQTT_client CLI arguement

    else:
        print("Invalid CLI arguments. Exiting program...") #If MQTT_client CLI arguement is invalid, exit the program
        sys.exit()

    return IP, PORT, CLIENT_ID #Return IP Address, Port Number, and CLIENT_ID to main MQTT_Client.py driver script 


#Function: link_callbacks() links custom callbacks to MQTT Mosquitto library
def link_callbacks(client):
    client.on_log = on_log
    client.on_connect = on_connect
    client.on_disconnect = on_disconnect
    client.on_message = on_message


#Function: on_log() is a custom Mosquitto callback that outputs log data to CLI
def on_log(client, userdata, level, buf):
    print("log: "+buf)


#Function: on_connect() is a custom Mosquitto callback - Connect to MQTT Broker
def on_connect(client, userdata, flags, rc):
    if rc==0:
        print("Connection OK")
    else:
        print("Connection FAIL. Error Code: ", rc)


#Function: on_disconnect() is a custom Mosquitto callback - Disconnect from MQTT Broker
def on_disconnect(client, userdata, flags, rc=0):
    print("Disconnected from MQTT Broker. Result Code: "+str(rc))
    #quit()


#Function: on_message() is a custom callback for what to do when a message is received via publish
def on_message(client, userdata, message):

    data = json.loads(message.payload) #Converts over-the-wire JSON to Python dictionary

    #PUBLISH EMERGENCY_STOP MESSAGE TO EMERGENCY_ACTUATION TOPIC
    if (data['ENTITY_ID'] == 'Connected_Vehicle' or data['ENTITY_ID'] == 'Autonomous_Vehicle') and data['STOP_VRU'] == True:

        actuation_message(client) #Publish EMERGENCY_STOP message to Emergency_Actuation topic 

        print("VRU DETECTED. SENDING EMERGENCY_STOP MESSAGE TO VEHICLES")
        print("")


    elif (data['ENTITY_ID'] == 'Roadside_Unit') and data['EMERGENCY_STOP'] == True:

        print("EMERGENCY_STOP RECEIVED -- Stopping Vehicle...")
        GLOBAL_FLAGS.emergency_flag = 1
        #print("EMERGENCY_FLAG = ", GLOBAL_FLAGS.emergency_flag)

    else:
        print("VEHICLE READOUTS NORMAL -- NO ISSUES")
        #print("EMERGENCY_FLAG = ", GLOBAL_FLAGS.emergency_flag)
        print("")


#Function: initialize_client declares a client instance for CV, AV, or RSU based on given inputs
def actuation_message(client): #VEHICLE FLAG == 1 --> Connected Vehicle; VEHICLE FLAG == 2 --> Autonomous Vehicle 
    #Set VEHICLE_ID --> Identifier for CV (Assume each insance of script is new CV simulation)

    topic = 'Emergency/STOP_VRU'
    CLIENT_ID = 'Roadside_Unit'

    #Define Python dictionary, which will be converted to JSON object below
    data = {
        'ENTITY_ID': CLIENT_ID,
        'TIMESTAMP': ts.time(),
        'EMERGENCY_STOP': True, 
        'SLOW_CAUTION': False,
        'STOP_VRU': None
    }

    message = json.dumps(data) #Convert Python dictionary to JSON object
    
    client.publish(topic, message, GLOBAL_FLAGS.qos_flag)


#Function: initialize_client declares a client instance for CV, AV, or RSU based on given inputs
def sensor_message(CLIENT_ID, client): #VEHICLE FLAG == 1 --> Connected Vehicle; VEHICLE FLAG == 2 --> Autonomous Vehicle 
    #Set VEHICLE_ID --> Identifier for CV (Assume each insance of script is new CV simulation)

    if CLIENT_ID == 'Connected_Vehicle': 

        topic = 'Vehicle_Readouts/Connected_Vehicle'

        if GLOBAL_FLAGS.is_vru_flag == 0:
            STOP_VRU_flag = False

        else:
            #Set STOP_VRU Flag via Random Number Generator
            if random.random() >= 0.98:
                STOP_VRU_flag = True
            else:
                STOP_VRU_flag = False

        #Define Python dictionary, which will be converted to JSON object below
        data = {
            'ENTITY_ID': CLIENT_ID,
            'TIMESTAMP': ts.time(),
            'EMERGENCY_STOP': None, 
            'SLOW_CAUTION': None,
            'STOP_VRU': STOP_VRU_flag
        }

        message = json.dumps(data) #Convert Python dictionary to JSON object


    if CLIENT_ID == 'Autonomous_Vehicle':

        topic = 'Vehicle_Readouts/Autonomous_Vehicle'

        #Set STOP_VRU Flag via Random Number Generator
        if GLOBAL_FLAGS.is_vru_flag == 0: #is_vru_flag == 0 --> Network test mode, send vehicle packets without stopping
            STOP_VRU_flag = False

        else: #is_vru_flag != 0 --> Simulation mode, send vehicle readouts with potential for VRUs
            #Set STOP_VRU Flag via Random Number Generator
            if random.random() >= 0.98:
                STOP_VRU_flag = True
            else:
                STOP_VRU_flag = False

        #Define Python dictionary, which will be converted to JSON object below
        data = {
            'ENTITY_ID': CLIENT_ID,
            'TIMESTAMP': ts.time(),
            'EMERGENCY_STOP': None,
            'SLOW_CAUTION': None,
            'STOP_VRU': STOP_VRU_flag
        }

        message = json.dumps(data) #Convert Python dictionary to JSON object

    client.publish(topic, message, GLOBAL_FLAGS.qos_flag)
