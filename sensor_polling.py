import RPi.GPIO as GPIO
import time
import serial
from pythonosc import udp_client

GPIO.setmode(GPIO.BCM)

class Sensor:
    def __init__(self, pin, name):
        
        self.SENSOR_PIN = pin

        GPIO.setup(self.SENSOR_PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)

        self.SC_IP = "127.0.0.1"
        self.SC_PORT = 57121
        self.osc = udp_client.SimpleUDPClient(self.SC_IP, self.SC_PORT)
        self.name = name

        self.last_state = GPIO.input(self.SENSOR_PIN)

    def pollSignal(self):
        try:
            if GPIO.input(self.SENSOR_PIN) == GPIO.LOW:
                print(self.SENSOR_PIN, "Looking for Magnet")
                self.osc.send_message(self.name, 0)
            else:
                print(self.SENSOR_PIN, "Detected Magnet")
                self.osc.send_message(self.name, 1)
        
        except KeyboardInterrupt:
            pass

p11_sensor = Sensor(17, "/magnet1")
p13_sensor = Sensor(27, "/magnet2")
p15_sensor = Sensor(22, "/magnet3")
p16_sensor = Sensor(23, "/magnet4")
p18_sensor = Sensor(24, "/magnet5")

osc_client = udp_client.SimpleUDPClient("127.0.0.1", 57121)
ser = serial.Serial('/dev/ttyACM0', 9600)

while True:
    p11_sensor.pollSignal()
    p13_sensor.pollSignal()
    p15_sensor.pollSignal()
    p16_sensor.pollSignal()
    p18_sensor.pollSignal()
    
    line = ser.readline().decode('utf-8', errors='ignore').strip()
    if line:
        try:
            values = list(map(int, line.split(',')))

            v1, v2, v3, v4, v5 = values
            print([v1, v2, v3, v4, v5])
            osc_client.send_message("/analogs", [v1, v2, v3, v4, v5])
        
        except :
            print("no values")