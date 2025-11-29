import paho.mqtt.client as mqtt

client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2, 'id0001')

client.connect("mqtt", 1883, 60)

client.publish("TEST", "Mensaje de prueba")
client.disconnect()
