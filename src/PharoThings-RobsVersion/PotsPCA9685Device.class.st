"
I am the driver for the PCA9685 16 port PWM/Servo extender
I am controlled through the I2C bus. There can be 62 of me on the bus

You can change my frequency  (30 - 2000 Hz) and on/off ratio
I start in sleep mode.
 
The internal clock is nominally 25 MHz. If you need more precise timing, you can alter this for use in the internal calculations (#adjustedClockFrequency:).

Pin numbers run from 0 to 15, because that is what is used in the datasheet and also on the print

Main methods: 
- wakeUp - start from sleep
- frequency: - frequency. Typically 50 Hz for driving servo motors, or up to 3000 Hz for LEDs
- pwmForPin:  microSeconds: - on time, used for servos in range 500 - 2500
- pwmForPin:  percentage: - percentage on time 
- pinOn: and pinOff: - to turn a pin fully ON or OFF

Note: equally usable for servo's. with appropriate frequency and pulse length
"
Class {
	#name : 'PotsPCA9685Device',
	#superclass : 'PotsI2CDevice',
	#instVars : [
		'clockFrequency'
	],
	#category : 'PharoThings-RobsVersion',
	#package : 'PharoThings-RobsVersion'
}

{ #category : 'instance creation' }
PotsPCA9685Device class >> defaultI2CAddress [
"on the adafruit board you can configure more driver ic's 
furthermmore iall of them also are on address 16r70"
	^16r40
]

{ #category : 'initialization' }
PotsPCA9685Device >> adjustedClockFrequency: aNumber [
	"change the clockfrequencyvalue used for calculating the PRESCALE value. It is sais the clock (nominally at 25 MHz) can also be 27 MHz. Adjust when the measured period of the signal is off (oscilloscope)."
	clockFrequency := aNumber
]

{ #category : 'operations' }
PotsPCA9685Device >> allFree [
	" clear the ON and OFF bit and load registers with zero, effectively output zero"
	i2cConnection write16BitsAt: 16rFA data: 0.
	i2cConnection write16BitsAt: 16rFC data: 0.
]

{ #category : 'operations' }
PotsPCA9685Device >> allOff [
	"turn all pins OFF" 
	i2cConnection write16BitsAt: 16rFA data: 0.
	i2cConnection write16BitsAt: 16rFC data: 16r1000.
]

{ #category : 'accessing' }
PotsPCA9685Device >> allOn [
	"turn all pins ON; no need to read the registers first, because they are write only. Bit 4 high" 
	i2cConnection write8BitsAt: 16rFD  data: 2r00000000.
	i2cConnection write8BitsAt: 16rFB  data: 2r00010000
]

{ #category : 'accessing' }
PotsPCA9685Device >> allPinsOnAt: onTime offAt: offTime [
	"send PWM settings to all pins"

	i2cConnection write16BitsAt: 16rFA data: onTime.
	i2cConnection write16BitsAt: 16rFC data: offTime.
]

{ #category : 'accessing' }
PotsPCA9685Device >> beInverted [
	"invert all outputs; makes sense when using open drain configuration"
	| temp |
	temp := (i2cConnection read8BitsAt: 16r01).
	i2cConnection write8BitsAt: 16r01 data: (temp bitAt: 5 put: 1)
]

{ #category : 'accessing' }
PotsPCA9685Device >> beNonInverted [
	" cancel beInverted "
	| temp |
	temp := (i2cConnection read8BitsAt: 16r01).
	i2cConnection write8BitsAt: 16r01 data: (temp bitAt: 5 put: 0)
]

{ #category : 'initialization' }
PotsPCA9685Device >> beOpenDrain [
	"make the outputs open drain. It can sink max. 25 mA. The adafruit board has 220 ohm resistors in series with the output. Bit 2 off register MODE2 must be 0"

	| oldMode |
	oldMode := i2cConnection read8BitsAt: 1. "MODE2 register"
	i2cConnection write8BitsAt: 1 data: (oldMode bitAnd: 2r11111011 ).
]

{ #category : 'initialization' }
PotsPCA9685Device >> beTotemPole [
	"set outputs to totempole, with a 25 mA sink and 10 mA source capability at 5V.
	set bit 2 of MODE2 register to 1"

	| oldMode |
	oldMode := i2cConnection read8BitsAt: 1.
	i2cConnection write8BitsAt: 1 data: (oldMode bitAnd: 2r00000100)
]

{ #category : 'controlling' }
PotsPCA9685Device >> connect [
	"initialisation"
	super connect.
	clockFrequency := 25000000. "default; when frequencies are off, as measured with an oscilloscope, you may adjust it later"
	i2cConnection write8BitsAt: 0 data: 2r00100001. "AutoIncrement and AllCall"
	1 milliSeconds wait.
	self wakeUp.
	1 milliSeconds wait.
	i2cConnection write16BitsAt: 16rFA data: 0.
	i2cConnection write16BitsAt: 16rFC data: 16r10. "all OFF"
	 
	
	

]

{ #category : 'accessing' }
PotsPCA9685Device >> connection [
	"comment stating purpose of message"

	^i2cConnection
]

{ #category : 'initialization' }
PotsPCA9685Device >> frequency: freq [
	"calculate and set the PRESCALE register 16rFE, limited to the range 3 to 255"
	| prescaleValue |
	clockFrequency ifNil: [ clockFrequency := 25000000 ].
	prescaleValue := (clockFrequency / (freq * 4096.0) - 1.0) asInteger.
	self sleep.
	i2cConnection
		write8BitsAt: 16rFE
		data: (prescaleValue min: 255 max: 3).	"write PRESCALE register"	
	1 milliSeconds wait.
	"Adafruit now sets the autoincrement mode and restart"
	self wakeUp.
	self reset
]

{ #category : 'initialization' }
PotsPCA9685Device >> pin: aPinNumber onAt: onTime offAt: offTime [
	"set pin aPinNumber (numbered from 0 through 15, tocorrespond with the silk screen on the board
	to an onTime (0-4095) en offTime (0-4095. 16r06 is the register address of LED0"

	i2cConnection write16BitsAt: 16r06 + (4 * aPinNumber) data: onTime.
	i2cConnection write16BitsAt: 16r06 + 2 + (4 * aPinNumber) data: offTime.
]

{ #category : 'operations' }
PotsPCA9685Device >> pinOff: aPinNumber [
	" turn pin pinNumber full off"
	i2cConnection write16BitsAt: 16r06 + (4 * aPinNumber) data: 0.
	i2cConnection write16BitsAt: 16r06 + 2 + (4 * aPinNumber) data: 16r1000
]

{ #category : 'operations' }
PotsPCA9685Device >> pinOn: aPinNumber [
	" turn pin pinNumber full on"

	i2cConnection write16BitsAt: 16r06 + (4 * aPinNumber) data: 16r1000.
	i2cConnection write16BitsAt: 16r06 + 2 + (4 * aPinNumber) data: 0.
]

{ #category : 'initialization' }
PotsPCA9685Device >> prescaleValue [
	"read the prescalevalue used"
	^i2cConnection read8BitsAt: 16rFE
]

{ #category : 'operations' }
PotsPCA9685Device >> pwmForAllPinsMicroSeconds: aNumber [
	"For servo purposes set the pulse width of ALL pins to aNumber microseconds. 
	This only makes sense when the frequency is set tot 50-100 Hz, "

	| prescale ticks |
	prescale := self prescaleValue.
	ticks := (aNumber * clockFrequency / 1000000.0 / (prescale + 1)) rounded.
	ticks := (ticks min: 4095) max: 0.
	self allPinsOnAt: 0 offAt: ticks
]

{ #category : 'operations' }
PotsPCA9685Device >> pwmForAllPinsPercentage: aPercentage [
	"set output for ALL pins to aPercentage percent of the time on. 
	Special care is taken that values
	less than 0.01 and greater than 99.99 are treated as full off or full on"

	| ticks  |
	(aPercentage < 0.01) ifTrue: [ self allPinsOnAt: 0 offAt: 4096. ^0 ].  " moet beter"
	(aPercentage > 99.99) ifTrue: [  self allPinsOnAt: 4096 offAt: 0. ^100 ].
	ticks :=  4096.0 * aPercentage / 100.0.
	self allPinsOnAt: 0 offAt: ticks rounded "no staging, all start at 0"
]

{ #category : 'initialization' }
PotsPCA9685Device >> pwmForPin: aPinNumber microSeconds: aNumber [
	"For servo purposes set the pulse width to aNumber microseconds. 
	This only makes sense when the frequency is set tot 50-100 Hz, "

	| prescale ticks |
	prescale := self prescaleValue.
	ticks := (aNumber * clockFrequency / 1000000.0 / (prescale + 1)) rounded.
	ticks := (ticks min: 4095) max: 0.
	self pin: aPinNumber onAt: 0 offAt: ticks
]

{ #category : 'initialization' }
PotsPCA9685Device >> pwmForPin: aPinNumber percentage: aPercentage [
	"set output for aPercentage percent of the time on. Special care is taken that values
	less than 0.01 and greater than 99.99 are treated as full off or full on"

	| ticks |
	(aPercentage < 0.01) ifTrue: [ self pin: aPinNumber onAt: 0 offAt: 4096. ^0 ].
	(aPercentage > 99.99) ifTrue: [  self pin: aPinNumber onAt: 4096 offAt: 0. ^100 ].
	ticks :=  4096.0 * aPercentage / 100.0.
	self pin: aPinNumber onAt: 0 offAt: ticks rounded
]

{ #category : 'initialization' }
PotsPCA9685Device >> pwmValuesAtPin: aPinNumber [
	"report an array off the registervalues in the order LED_ON_L, LED_ON_H, LED_OFF_L, LED_OFF_H"

	|values |
	values := Array new: 4.
	1 to: 4 do: [ :index | values at: index put: 
		(i2cConnection read8BitsAt: (index+ 5 + (4 * aPinNumber)))].
	                                                                              
	^values                                                                                                                             
]

{ #category : 'utilties' }
PotsPCA9685Device >> reg16Hex: regno [
	^(self connection read16BitsAt: regno) printStringRadix: 16
]

{ #category : 'utilties' }
PotsPCA9685Device >> regHex: regno [
	^(self connection read8BitsAt: regno) printStringRadix: 16
]

{ #category : 'initialization' }
PotsPCA9685Device >> reset [
	"reset MODE1_RESTART to MODE1 register"
	| temp |
	temp := i2cConnection read8BitsAt: 0.
	i2cConnection write8BitsAt: 0 data: (temp bitAt: 8 put: 1).
	10 milliSeconds wait. "according to Adafruit"
]

{ #category : 'states' }
PotsPCA9685Device >> sleep [
	"go into sleep mode; set sleep bit 16r10 high in MODE1 geister"

	| temp  |
	temp := i2cConnection read8BitsAt: 0.
	i2cConnection write8BitsAt: 0 data: (temp bitAt: 5 put: 1).
	1 milliSeconds wait.
	
]

{ #category : 'states' }
PotsPCA9685Device >> wakeUp [
	"set sleepbit 16r10 low"

	| temp |
	temp := i2cConnection read8BitsAt: 0.
	"clear the SLEEP bit (4 in doc, 5 in our counting"
	i2cConnection write8BitsAt: 0 data: (temp bitAt: 5 put: 0)
]
