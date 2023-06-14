

# Pots - Pharo-of-Things Simplified (DRAFT)

## Attribution

*This project is indebted to the Pharo-of-Things project (https://github.com/pharo-iot/PharoThings)  for ideas, modelling and code. Especially the pin and device model stem from Pot. It misses the remote capabilities of Telepharo. On the other hand it fully supports digital I/O, PWM and servo functions on  Raspberry Pi, Pico, Arduino and ESP32 devices. The design considerations are documented in Pot-to-Pots.md in this repo. In this readme no previous knowledge of PharoThings is presupposed. If you are acquainted with Pharo-of-Things you should know that the term `Board` has been replaced by `Controller` and `Mode` and `Function` coalesced into `Role`.*

## Main classes and relations between them

### Controller

A controller (class `PotsController`) is a concept that stands for a physical device like a Raspberry Pi, an Arduino microprocessor or even a 16-port Led driver like the PCA9685. A controller is brought to life by a driver (`PotsDriver`) that talks to the real hardware. A controller contains pins (`PotsPin`) which are the objects we manipulate for setting or retrieving the values of the physical device.

### Driver

The driver has two functions:

1. Communicate with the physical device. This can be through an existing driver (like PiGPIO for the Raspberry Pi or Firmata for an Arduino, PicodDriver for thee Raspberry Pico), or ESP32Driver for the ESP32 or through a device (`PotsDevice`) that has been defined for an existing controller (see under "Device"). We call this lower level driver the "base driver". The PotsDriver presents a common API to the Controller.
2. Provide the controller with a list of all pins with their ID's and their capabilities (possible roles). A controller is completely defined by its driver, so there will usually be no need to subclass `PotsController`.

#### Example code

The following code fragments would create four controllers, one for a Pi (with pigpiod running on the Pi), the second for an Arduino (loaded with a Firmata sketch), the third for a Raspberry Pico (with Picod daemon) and the last for an ESP32 running my own deaemon.toit :

```smalltalk
myPi := PotsController new driver: (PotsPiGPIODriver onIP: '192.168.1.92' port: 8888).
myArduino := PotsController new driver: (PotsFirmataDriver onPort: 'COM3' baudRate: 57600).
myPico := PotsController new driver: (PotsPicodDriver onPort: '/dev/ttyACM0').
myESP32 := PotsController new driver: (PotsESP32Driver brokerIP: 'mqtt://test.mosquitto.org' deviceName: 'test1').
```
If you are running this on the Raspberry Pi itself, you should use the localhost address 127.0.0.1.

### Pin

A controller has a number of pins (else it wouldn't be of much use). Pins are designated by their native Id's. Pins can have alternate id's; these are used by the Firmata and Picod driver to denote the analog pins (that can also be digital i/o pins, or i2c) and for the Pi you could use them for the WiringPi numbering scheme. 

Pins respond to the messages `value` or `value:`.  The result or parameter depends on the role the pins play. 

Roles are set by the messages `beDigitalInput`, `beDigitalOutput`, `beAnalogInput`, beAnalogOutput, `bePWMoutput` or `beServoOutput`.  

Values are returned and provided in meaningful units: 0/1 for digital pins, volts for analog i/o, percentage for PWM and degrees (0 - 180) for servo pins. If you know the internals, you can use `rawValue`.

### Role

Role (`PotsRole`) is a central concept. A role captures what  a pin can do, its capabilities. A pin has one current role (`currentRole`)  and a number of possible roles. The `beSomething` methods change the current role, after checking this role is available for that pin. The (current) role can also contain relevant parameters for that role, like the resolution for an analog input, or the minimum and maximum pulse width for a servo output. Until now we have only seen solo roles (`PotsSoloRole`). When a pin cooperates with other pins to perform a function, it has an ensemble role (see Device) and would normally not be individually addressed.

#### Example code

Let's start with a LED. Most Arduinos have a LED on pin 13 en on the Pico the internal LED is on GPIO 25; for the Pi you will have to connect a LED to  GPIO pin 13 (that is 33 on the connector), or simply use a volt meter. On an ESP32 there is often a LED on pin 2. We use `myController` instead of `myPi` or `myArduino`.

```smalltalk
led := myController pinWithId: 13. "or 25 for a Pico or 2 for ESP32"
led beDigitalOutput.
led value: 1.
led toggle.
led bePWMOutput. "This raises an error on an Arduino Uno,because pin 13 doesn't do PWM"
led value: 50
led incrementValueBy: 20.
```

For the Arduino you must connect a LED to a PWM capable pin. 

The following is only possible on Arduino, Pico:

```smalltalk
a0 := myArduino pinWithAltId: 0. "On an Arduino Uno this is pin 14, on the Pico it is gpio26"
a0 beAnalogInput. "note that analog pins can also do digital i/o"
a0 enableReporting. "This is specific to Firmata, not necessary on Pico"
measurement := a0 value. "The result is in Volts"
```
The ESP32 has no altId's defined so for analog input you can use pins 32, 33, 34, 35, 39 sand for analog output pins 25 and 26.
#### Inspector and PotsLayout
When you inspect an instance of PotsController, you get a list of the pins in numerical order. Each line has the following informatio: pin number, alternative pin number, current role, last value and permitted roles (named capabilities). To make this look more like the actual board or connector you can apply a PotsLayout to the controller like
```smalltalk
myArduino installLayout: : PotsLayout forArduinoUno.
```
There are definitions for the Pi3, Pico, ESP32-30pins and the Uno. The pins are now arranged in two columns with their details on the left and the right. From the code it will be evident how to make your own layout

### Devices

A `PotsDevice` is a software construct that simulates a real device. It uses one or more pins of the controller. These pins can be manipulated directly by the device code, or they can be used by a specific protocol (I2C only, at present), depending of the capabilities of the base drivers

A `PotsDevice` is instantiated with the method `installDevice: aDevice`, where `aDevice` is an instance of a `PotsDevice` that does not have to be working, but must know which pins to use. The pins are then "claimed" so they cannot be used by other devices.

A simple  example is the `PotsRGBLedDevice` that uses three pins to drive an RGB LED. It's only important method is `color:` that takes an instance of `Color` as argument. More complex is the `PotsHD44780Device` that drives the popular (and cheap) 16x2 Led display. It uses 6 pins: 4 for data and 2 for control. 

Devices that use inputs need something extra: either they should be made aware of a change in input (in Pharo that would be an Announcement) or the device code itself should contain a polling loop.  Firmata Picod and PiGPIO drivers support announcements of changes in digital inputs (essentially because the polling loop already has been implemented in the driver, or in the daemon code on the physical device). 

#### I2C devices

Many microprocessors have special hardware to support the I2C protocol. This is also true for the Raspberry Pi, Pico and Arduino-like boards. The protocol uses two pins of the controller (named SDA and SCL) and is supported by all three baseDrivers, PiGPIO, Picod and Firmata. The drivers know which pins to use and set these pins automatically to the `PotsI2CRole`.  The `PotsI2CDevice` manages the I2C communication and provides the functionality of the device in a useful way. For example,the `PotsDS1307Device` exposes the real time clock with messages like `dateAndTime` or `dayOfWeek`. Another example is `PotsBME280Device` that exposes the temperature, pressure and humidity sensor BME280 with messages like `readTemperature` and `readPressure1` Note that the code of these devices is almost identical to the code in Pharo-of-Things.

### Controllers on devices
Among the I2C devices we have  the `PotsPCA9685Device` and the `PotsPCF8574Device`. Both have pins that function as inputs or outputs, so the question arises what makes them different from a `Controller`? In fact, nothing, once you construct an appropriate driver. `PotsDriver` has two subclasses, the `PotsDriverDriver` and the `PotsDeviceDriver`. Up till now we used the first,  a driver that uses another driver. The second is a driver that uses a `PotsDevice`. A `PotsDeviceDriver` needs a working instance of the appropriate `PotsDevice`to start with. Using an installed 8-bits i2C-IO-extender like `PotsPCF8574` that is often used together with a standard 16x2 LCD (and even sold as one unit) you can control the `PotsHD44780Device` just like we did above.

#### Example code
First we look at the PCF8574 as a device. The chip has 8 pins that can be set to logical 1 or 0. When you write a 1 to a pin, you ran read it back, resulting in 1 if the pin is free or 0 when it is pulled down to ground. Actually, the pins cannot be addressed individually, but only all together. So, either you send a byte, or you read one. Often the chip is mounted with some additional circuitry, ready to drive an LCD display. In that case pin 3 is meant to drive the LCD backlight and is connected to the base of a npn-transistor, effectively pulling it to ground.

```smalltalk
ard := PotsController new driver: (PotsFirmataDriver onPort: 'COM3' baudRate: 57600).
pfc := ard installdevice: PotsPCF8574Device new. "create the device"
pfc writeByte: 2r10101010. "check the output with a voltmeter"
pfc writeByte: 16rFF. "set all pins to 1 so you can read back their state"
state := pfc readByte. "this would show   (16r..) as pin 3 was pulled down"
```
## To Do
No project is ever really finished. In this case there are practical to-do's like cleaning up (I worked on this stuff on and off for the last two years so many inconsistencies have crept in), adding devices, error handling, possibly adding controller devices. And there definitely must be more  tests, although a lot of functions depend on the physical device and its firmware. Maybe it makes sense to extend the announcement mechanisms of Firmata, PigPIO and Picod to the Pots 
framework as a whole.  

Small to-do's:
- pullup and pull down resisters on digital outputs; not difficult, but different for different types of controllers. Essentially, 
this is about the electrical behaviour of an output, so we would also like to capture the "totem pole" output of the PCA9685
- Users will centainly find many more

## Loading
In a playground execute
```smalltalk
Metacello new
    baseline: 'Pots';
    repository: 'github://robvanlopik/Pots:main';
    load.
```
This will also load the four drivers (PiGPIO, Picod, Firmata and ESP32). Also loaded is my fork of an FFI-based SerialPort driver by Pablo Tesone and the MQTT package by Sven van Caekenberghe.
```
