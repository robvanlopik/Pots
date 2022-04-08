# A simpler variant of Pharo-of-Things

### Design Considerations

Roughly two years ago I came across Pharo of Things (PoT). Before that I already had Squeak running on an old Pi, partly from the Scratch installation that comes with the Pi. I liked the idea and started to experiment and to think how I could contribute. Around January 2020 I started to expand the Firmata driver.

After that I looked at an alternative for the WiringPi driver and started a driver on the basis of PiGPIO. I also started to have a deeper look at the design of PoT, because I saw it as a means to introduce electronics and microprocessor hobbyists to Smalltalk, especially because of its easy scripting capabilities. This led me to the following observations on the design of PoT.

# Observations (and comments)

The first thing I noticed was the use of TelePharo in most of the documentation. In my opinion this distracts from the learning of programming a microprocessor with sensors and is not necessary because modern Pi's are perfectly capable of running the full Pharo image and be used as the development platform. Besides, when using Firmata (or other drivers I developed) it is superfluous anyway. So, for me Telepharo would not be a priority to implement or teach. That is not to say that TelePharo is not a valuable and interesting piece of work on its own!

Next I found a number of things I did not like about the board model. These may not be important if you only look at the Raspberry Pi, but they become more evident when you try to accommodate different microprocessors with varying capabilities, like Arduino and Raspberry Pico.

-   There is no provision for more than one function per pin;
-   Pin functions are encoded in the board definition, which leads to a proliferation of Board subclasses;
-   pinId's are too complex;
-   Mode and function seem equivalent or overlapping;
-   Header and connector seem to be the same; their role in the model is too central;
-   No provision to prevent setting the mode of a pin that is used for e.g. I2C

I also noticed the complicated way pins (or GPIO's) are denoted. WiringPi introduced its own numbering scheme, but in general there usually is no discussion about how to name pins. Pins have numbers that function as ID's, but sometimes the numeric properties even matter, like on the Raspberry Pico where even numbered pins sometimes differ from odd numbered ones.

Next I did not like the central role of the connector as an object. In practice a board can have a connector or pads or holes or whatever. I understand the physical layout of the pins is needed for a visual inspector, but it should not be part of the basic model.

Finally: WiringPi severely limits the modes of different pins. Looking at Firmata and PiGPIO and the Pico, you see that pins can perform lots of different functions, In the present model these have to be statically declared in the definition of the connector. Every new use of pins leads to a different subclass of Board. Moreover the model uses two concepts, mode and function that somehow overlap.

Somewhere I found the term "peripheral"; I have no clear understanding whether this meaningfully differs from "device" or the pins used by a device.

# Starting points 

With the above in mind and based pn my experience with the different drivers, I laid out the following principles that an "improved" (and maybe "simplified" PoT should follow.

1.  Layout must be separated from the basic functional model;
2.  Pins are designated by their default GPIO numbers;
3.  Pins can have an alternate ID (like WiringPi numbers or Arduino analog inputs);
4.  Pins can have any number of functions; they know what functions they can perform;
5.  Pin properties are in principle determined by the driver (in the case of Firmata the driver can even ask for them);
6.  The driver is intermediate between the base driver (like WiringPi, Firmata, PiGPIO, Picod) and the board;
7.  Trying to remain compatible with the PotDevice model;
8.  Any device with some kind of GPIO pins can be a "board" even if it is itself a device on another "board";
9.  Pins receive the request (mostly #value and #value:) but their active Role is responsible for communicating this to the driver.

# Design

To be free to experiment, I did not try to fork PoT but started anew. I call it Pot*s* for *s*implified. I also changed some terminology. "Board" is replaced by "Controller" to abstract from its physical aspects. "Mode" and "function" are called "Role", because a pin knows different roles, but can only play one at the same time.

This leads to a very limited number of classes:

#### PotsController
Contains pins and the PotsDriver that will bring it to life. It also contains a layout that can be used to enable a graphical inspector. Because a controller instance derives its identity/behaviour from its driver, it probably does not have to be subclassed. (Note: layout not yet implemented)

#### PotsPin
Belongs to a PotsController and is identified by its GPIO ID, usually a number. A Pin can have different Roles, but only one can be active/current. A pin accepts requests, but they are acted upon by its current Role. A pin responds to #value and/or #value: . Depending on the role this translates to the appropriate driver commands. In principle values are "real life": volts for analog input, percentage for PWM, angle for servo. The Role, together with the driver, holds the necessary info for conversions.

#### PotsRole
A Role is a function a gpio pin can perform. We distinguish to kinds:
1.  SoloRole: the pin performs this role alone. Examples are digital I/O, PWM, servo, analog input. In this case the SoloRole communicates the intent with the PotsDriver on behalf of the Pin;
2.  EnsembleRole: The pin participates with other pins in a structured communication like SPI, I2C or UART. In that case a PotsConnection is created that communicates with the driver. (Only I2CConnection implemented until now)

#### PotsDriver
The PotsDriver sits between the controller and the software that really controls the hardware. Different devices have different base drivers, like WiringPi, Firmata, PiGPIO, Picod, that are supposed to maximally exploit the capabilities of their platforms. One function of the PotsDriver is to implement a common denominator of those functions, a common API.

During initialisation of the Controller the PotsDriver has the responsibility of telling it what pins exist and what roles they can perform. In fact, the PotsDriver **defines** its controller.

There are two kinds of PotsDrivers:

##### PotsDriverDriver
This functions like the intermediate driver in PoT. It translates the common API to specific driver actions.

##### PotsDeviceDriver
This presents the pins of a PotsDevice to the Controller and instructs the PotsDevice to perform its functions. The PotsDevice first has to be installed on another Controller.

In this way devices that behave like controllers can be used just like any other controller. Examples are port expanders. Specifivally the standaard 16x2 LCD device can be connected to an PCF8574 8-bits port expander. This is an I2CDevice and can also function as a controller, so there is no need for a separate i2c version of the LCDDevice.

#### PotsDevice
The PotDevice is a central part of PoT, and in Pots it is the same. It follows the same modeling. Special care is taken for claiming and releasing the needed gpio pins. In the case of I2C, pins are only released when all devipces on the bus have been closed.

# Testing

At the level of the device driver I have no tests. I wonder how people manage to test things other than using a breadboard and oscilloscope. I have tried setting up a PotsFakeDriver, but I am not sure that is the way to go. In PiGPIO I started writing tests with MockObject which seems promising.

# Layout/inspector

A PotsController has an attribute "layout". My intent is to have a somewhat generalized description of a PCB, something like a grid. From there you could develop inspectors. I didn't look into this for three reasons:
-   Personally I prefer voltmeter and oscilloscope;
-   Most of the time you would be interested in the temporal behavior of a pin;
-   I would want to do it with NewTools and was waiting for SerialPort to be available for Pharo9 and beyond.

When I come to this, I would also want to built in some timeline/oscilloscope function.

# Announcements

In PoT it was recognized that many devices would have some kind of loop to poll for input changes. All drivers I have written so far have an announcement mechanism for this function, so we need a framework to define devices that use announcements instead of their own polling loop.

## Error handling.

There is a lot that can go wrong in an IoT environment. In Smalltalk we often trust we can find the error with the debugger. This does not work well when you use external software/hardware. You really have to check what you send to an external program because otherwise the outcome is unpredictable. So you will have to raise some error. First I used #assert: (an idea I picked up from the AI-book by Alexandre Bergel). Then I noticed some discussion about the use of #assert: in the "bloc" channel on Discord and changed to #error, but maybe I should create something like PotsError. Other programming errors will happen when Roles don't exist; this can easily happen when you use another device or another version of Configurable Firmata. Anyway, something for consideration.

Another source of error is the data communication. How do you signal or recover in a real life application?

# Status

The basic classes are working and I have implemented a number of devices, that work with  PiGPIO. PicodDriver and Firmata. It runs in Pharo 9 and 10, 

Devices implemented:
-   ADS1015 - 4 channel ADC
-   BME280 -- temperature, humidity pressure (code 99% from PoT)
-   DS1307 -- real time clock + memory (99% from PoT)
-   PCA9685 -- 16 channel PWM/Servo driver (I2C) (still some errors, probably related to big-endianness)
-   PCF8574 -- 8 channel port extender (I2C)
-   HD44780 -- 16x2 LCD display (99% from PoT, works also with PCF8574 used as controller)
-   simple RGB LED.

### To Do

Cleanup.
Tests. 
Framework for announcements, devices using announcements.

April 2022
Rob van Lopik
