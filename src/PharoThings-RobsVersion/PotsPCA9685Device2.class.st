"
I am the driver for the PCA9685 16 port PWM/Servo extender
I am controlled through the I2C bus. There can be 62 of me on the bus

You can change myfrequency  (30 - 2000 Hz) and on/off ratio
??I start in sleep mode.
 
The internal clock is nominally 25 MHz. If you need more precise timing, you can alter this for use in the internal calculations (adjustedClockFrequency:).

Pin numbers run from 0 to 15, because that is what is used in the datasheet and also on the print

Main methods: 
wakeUp - start from sleep
frequency: - freqeuncy.Typically 50 Hz for driving servo motors, or up to 3000 Hz for LEDs
pwmForPin:  microSeconds: - on time, used for servos in range 500 - 2500
pwmForPin:  percentage: - percentage on time 
pinOn: and pinOff: - to turn a pin fully ON or OFF
"
Class {
	#name : 'PotsPCA9685Device2',
	#superclass : 'PotsI2CDevice',
	#instVars : [
		'clockFrequency'
	],
	#category : 'PharoThings-RobsVersion',
	#package : 'PharoThings-RobsVersion'
}

{ #category : 'instance creation' }
PotsPCA9685Device2 class >> defaultI2CAddress [
"on the adafruit board you can configure more driver ic's 
furthermmore iall of them also are on address 16r70"
	^16r40
]

{ #category : 'initialization' }
PotsPCA9685Device2 >> adjustedClockFrequency: aNumber [
	"change the clockfrequencyvalue used for calculating the PRESCALE value. It is sais the clock (nominally at 25 MHz) can also be 27 MHz. Adjust when the measured period of the signal is off (oscilloscope)."
	clockFrequency := aNumber
]

{ #category : 'as yet unclassified' }
PotsPCA9685Device2 >> allFree [
	" clear the ON and OFF bit and load registers with zero, effectively output zero"
	i2cConnection write16BitsAt: 16rFA data: 0.
	i2cConnection write16BitsAt: 16rFC data: 0.
]

{ #category : 'as yet unclassified' }
PotsPCA9685Device2 >> allOff [
	"turn all pins OFF" 

	| temp |
	temp := (i2cConnection read8BitsAt: 16rFD) bitOr: 2r00010000.
	i2cConnection write8BitsAt: 16rFD  data: temp
]

{ #category : 'accessing' }
PotsPCA9685Device2 >> allOn [
	"turn all pins ON; no need to read the registers first, because they are write only. Bit 4 high" 
	i2cConnection write8BitsAt: 16rFD  data: 2r00000000.
	i2cConnection write8BitsAt: 16rFB  data: 2r00010000
]

{ #category : 'accessing' }
PotsPCA9685Device2 >> allPinsOnAt: onTime offAt: offTime [
	"send PWM settings to all pins"

	i2cConnection write16BitsAt: 16rFA data: onTime.
	i2cConnection write16BitsAt: 16rFC data: offTime.
]

{ #category : 'accessing' }
PotsPCA9685Device2 >> beInverted [
	"invert all outputs; makes sense when using open drain configuration"

	| temp |
	temp := (i2cConnection read8BitsAt: 16r01) bitOr: 2r00010000. "mode 2 register, set bit 4 (counting from 0)"
	i2cConnection write8BitsAt: 16r01 data: temp
]

{ #category : 'accessing' }
PotsPCA9685Device2 >> beNonInverted [
	" cancel beInverted "
	| temp |
	temp := (i2cConnection read8BitsAt: 16r01) bitAnd: 2r11101111.
	i2cConnection write8BitsAt: 16r01 data: temp
]

{ #category : 'initialization' }
PotsPCA9685Device2 >> beOpenDrain [
	"make the outputs open drain. It can sink max. 25 mA. The adafruit board has 220 ohm resistors in series with the output. Bit 2 off register MODE2 must be 0"

	| oldMode |
	oldMode := i2cConnection read8BitsAt: 1. "MODE2 register"
	i2cConnection write8BitsAt: 1 data: (oldMode bitAnd: 2r11111011 ).
]

{ #category : 'initialization' }
PotsPCA9685Device2 >> beTotemPole [
	"set outputs to totempole, with a 25 mA sink and 10 mA source capability at 5V.
	set bit 2 of MODE2 register to 1"

	| oldMode |
	oldMode := i2cConnection read8BitsAt: 1.
	i2cConnection write8BitsAt: 1 data: (oldMode bitAnd: 2r00000100)
]

{ #category : 'controlling' }
PotsPCA9685Device2 >> connect [
	"initialisation"

	| temp |
	super connect.
	clockFrequency := 25000000. "default; when frequencies are off, as measured with an oscilloscope, you may adjust it later"
	self reset.
	temp := (i2cConnection read8BitsAt: 0) bitAnd: 16r7F.
	i2cConnection write8BitsAt: 0 data: (temp bitOr: 16r20). "set theRegister Auto-increment bit"
	self wakeUp
]

{ #category : 'accessing' }
PotsPCA9685Device2 >> connection [
	"comment stating purpose of message"

	^i2cConnection
]

{ #category : 'initialization' }
PotsPCA9685Device2 >> frequency: freq [
	"calculate and set the PRESCALE register 16rFE, limited to the range 3 to 255"

	|  prescaleValue oldMode newMode |
	clockFrequency ifNil: [ clockFrequency := 25000000 ].
	
	prescaleValue := ( (clockFrequency / (freq * 4096.0) - 1.0) rounded) min: 255 max: 3.

	oldMode := i2cConnection read8BitsAt: 0.
	newMode := oldMode bitAt: 5 put: 1. "set SLEEP to 1 bit 4 in doc, bit 5 in Pharo"
	"according to datasheet the ERESTARTbit cannot beset to 0"
	i2cConnection write8BitsAt: 0 data: newMode.	"go to sleep"
	i2cConnection write8BitsAt: 16rFE data: prescaleValue.
	i2cConnection write8BitsAt: 0 data: oldMode.
	1 milliSeconds wait.
	i2cConnection write8BitsAt: 0 data: (oldMode bitOr: 16r80). "set the RESTART bit"

]

{ #category : 'initialization' }
PotsPCA9685Device2 >> pin: aPinNumber onAt: onTime offAt: offTime [
	"set pin aPinNumber (numbered from 0 through 15, tocorrespond with the silk screen on the board
	to an onTime (0-4095) en offTime (0-4095. 16r06 is the register address of LED0"

	i2cConnection write16BitsAt: 16r06 + (4 * aPinNumber) data: onTime.
	i2cConnection write16BitsAt: 16r06 + 2 + (4 * aPinNumber) data: offTime.
]

{ #category : 'as yet unclassified' }
PotsPCA9685Device2 >> pinOff: pinNumber [
	" turn pin pinNumber full off"
	| temp |
	temp := (i2cConnection read8BitsAt: (16r09 + (4 * pinNumber))) bitOr: 2r00010000.
	i2cConnection write8BitsAt: (16r09 + (4 * pinNumber)) data: temp

]

{ #category : 'as yet unclassified' }
PotsPCA9685Device2 >> pinOn: pinNumber [
	" turn pin pinNumber full on"
	| temp |
	temp := (i2cConnection read8BitsAt: (16r07 + (4 * pinNumber))) bitOr: 2r00010000.
	i2cConnection write8BitsAt: (16r07 + (4 * pinNumber)) data: temp
]

{ #category : 'initialization' }
PotsPCA9685Device2 >> prescaleValue [
	"readd the prescalevalue used"
	^i2cConnection read8BitsAt: 16rFE
]

{ #category : 'operations' }
PotsPCA9685Device2 >> pwmForAllPinsMicroSeconds: aNumber [
	"For servo purposes set the pulse width of ALL pins to aNumber microseconds. 
	This only makes sense when the frequency is set tot 50-100 Hz, "

	| prescale ticks |
	prescale := self prescaleValue.
	ticks := (aNumber * clockFrequency / 1000000.0 / (prescale + 1)) rounded.
	ticks := (ticks min: 4095) max: 0.
	self allPinsOnAt: 0 offAt: ticks
]

{ #category : 'as yet unclassified' }
PotsPCA9685Device2 >> pwmForAllPinsPercentage: aPercentage [
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
PotsPCA9685Device2 >> pwmForPin: aPinNumber microSeconds: aNumber [
	"For servo purposes set the pulse width to aNumber microseconds. 
	This only makes sense when the frequency is set tot 50-100 Hz, "

	| prescale ticks |
	prescale := self prescaleValue.
	ticks := (aNumber * clockFrequency / 1000000.0 / (prescale + 1)) rounded.
	ticks := (ticks min: 4095) max: 0.
	self pin: aPinNumber onAt: 0 offAt: ticks
]

{ #category : 'initialization' }
PotsPCA9685Device2 >> pwmForPin: aPinNumber percentage: aPercentage [
	"set output for aPercentage percent of the time on. Special care is taken that values
	less than 0.01 and greater than 99.99 are treated as full off or full on"

	| ticks |
	(aPercentage < 0.01) ifTrue: [ self pin: aPinNumber onAt: 0 offAt: 4096. ^0 ].
	(aPercentage > 99.99) ifTrue: [  self pin: aPinNumber onAt: 4096 offAt: 0. ^100 ].
	ticks :=  4096.0 * aPercentage / 100.0.
	self pin: aPinNumber onAt: 0 offAt: ticks rounded
]

{ #category : 'initialization' }
PotsPCA9685Device2 >> pwmValuesAtPin: aPinNumber [
	"report an array off the registervalues in the order LED_ON_L, LED_ON_H, LED_OFF_L, LED_OFF_H"

	|values |
	values := Array new: 4.
	1 to: 4 do: [ :index | values at: index put: 
		(i2cConnection read8BitsAt: (index+ 5 + (4 * aPinNumber)))].
	                                                                              
	^values                                                                                                                             
]

{ #category : 'as yet unclassified' }
PotsPCA9685Device2 >> reg16Hex: regno [
	^(self connection read16BitsAt: regno) printStringRadix: 16
]

{ #category : 'as yet unclassified' }
PotsPCA9685Device2 >> regHex: regno [
	^(self connection read8BitsAt: regno) printStringRadix: 16
]

{ #category : 'initialization' }
PotsPCA9685Device2 >> reset [
	"reset MODE1_RESTART to MODE1 register"

	i2cConnection write8BitsAt: 0 data: 16r80.
	10 milliSeconds wait. "according to Adafruit"
]

{ #category : 'world state' }
PotsPCA9685Device2 >> sleep [
	"go into sleep mode; set sleep bit 16r10 high in MODE1 geister"

	| temp registerContents |
	temp := i2cConnection read8BitsAt: 0.
	registerContents := temp bitOr: 16r10.
	i2cConnection write8BitsAt: 0 data: registerContents.
	5 milliSeconds wait.
	
]

{ #category : 'initialization' }
PotsPCA9685Device2 >> wakeUp [
	"set sleepbit 16r10 low"

	| temp registerContent |
	temp := i2cConnection read8BitsAt: 0.
	registerContent := temp bitAnd: (16r10 bitInvert).
	i2cConnection write8BitsAt: 0 data: registerContent.
]
