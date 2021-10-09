

# mosquitto_pub -h raspberrypi.local -t "raspberrypi/move" -m "forward"
# mosquitto_pub -h raspberrypi.local -t "raspberrypi/move" -m "stop"

import paho.mqtt.client as mqtt
import json

clientName = "pi"
serverAddress = "macseansc-pi"
mqttClient = mqtt.Client(clientName)

def connectionStatus(client, userdata, flags, rc):
    print("subscribing")
    mqttClient.subscribe("raspberrypi/mode")
    print("subscribed")

def messageDecoder(client, userdata, msg):
    message = msg.payload.decode(encoding='UTF-8')
    print(message)
    # if message == "mode1":
    #     print("Entered Mode 1!")
    # elif message == "mode2":
    #     print("Entered Mode 2!")
    # elif message == "mode3":
    #     print("Entered Mode 3!")
    # elif message == "mode4":
    #     print("Entered Mode 4!")
    # elif message == "mode5":
    #     print("Entered Mode 5!")
    # elif message == "1":
    #     print("Entered Mode 1!")
    # elif message == "2":
    #     print("Entered Mode 2!")
    # elif message == "3":
    #     print("Entered Mode 3!")
    # elif message == "4":
    #     print("Entered Mode 4!")
    # elif message == "5":
    #     print("Entered Mode 5!")
    # elif message == "Mode 1":
    #     print("Entered Mode 1!")
    # elif message == "Mode 2":
    #     print("Entered Mode 2!")
    # elif message == "Mode 3":
    #     print("Entered Mode 3!")
    # elif message == "Mode 4":
    #     print("Entered Mode 4!")
    # elif message == "Mode 5":
    #     print("Entered Mode 5!")
    # else:
    #     print("?!? Unknown message?!?")

# Set up calling functions to mqttClient
mqttClient.on_connect = connectionStatus
mqttClient.on_message = messageDecoder

# Connect to the MQTT server & loop forever.
# CTRL-C will stop the program from running.
mqttClient.connect(serverAddress)
mqttClient.loop_forever()

