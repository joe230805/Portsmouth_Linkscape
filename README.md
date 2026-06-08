# Portsmouth_Linkscape
Getting this project running requires a specific hardware configuration. This document aims to make that configuration easy to obtain in order to enable replicability.

### Arduino Setup:
Ensure 'analogue_polling', the Arduino code file is loaded onto the device.
In the analogue pins, connect three sliders in sequence, and then three knobs in sequence. Other analogue inputs will work, but knobs and sliders are the intended hardware.

### Raspberry Pi Setup:
The magnetic sensors should be plugged into pins 11, 13, 15, 16 & 18. These correlate to GPIO 17, 27, 22, 23 & 24 respectively using BCM numbering.

The Arduino should be connected to one of the Raspberry Pi's USB ports.
#### Setting up a Virtual Environment:
This is an important step, as it allows us to run send OSC messages and receive serial port messages.

In the console, ensure the module is installed:
`sudo apt-get install python3-venv`

Create a Virtual Environment:
`python3 -m venv osc-env`

Activate the Virtual Environment:
`source osc-env/bin/activate`

On the first time running, install python-osc and pyserial:
`pip install python-osc`
`pip install pyserial`

Now you can run the sensor_polling.py script in the Environment:
`python3 path/to/sensor_polling.py`

#### Installing & Running Supercollider:
Find official Supercollider installation instructions for Raspberry PI here:
[supercollider/README_RASPBERRY_PI.md at develop · supercollider/supercollider](https://github.com/supercollider/supercollider/blob/develop/README_RASPBERRY_PI.md)

To run the IDE, type in the console:
`scide`
From here:
- Open the audio_manager.scd script
- Start the server with Ctrl+B
- Evaluate the code with Ctrl+Enter