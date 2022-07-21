"
I behave like a PotsPiGPIODriver, but my baseDriver is a MockObject
I also modify #providePinInfo so as not to access the baseDriver (returning 255 for the PWM range instead of asking the driver)

Th mock can be accessed as `self baseDriver`

The easiest is to instantiate a controller like:
``` Smalltalk
testPi := PotsController new driver: (MockPotsPiGPIODriver onIP: 'aString' port: 1234)
```
The IP=address and port number are not used but are returned by `testPi driver ip `and `testPi driver port` and can  be used to inject values into tests.


"
Class {
	#name : #MockPotsPiGPIODriver,
	#superclass : #PotsPiGPIODriver,
	#category : #'PharoThingsSimplified-Tests'
}

{ #category : #initialization }
MockPotsPiGPIODriver >> providePinInfo [
	"return a dict of pins to the caller, with their poperties"
	| pinDict i2cRole|
	i2cPins := OrderedCollection new.
	"first enumerate the pins"	
	pinDict := Dictionary new.
	2 to: 27 do:
		[ :pinId | pinDict at: pinId put: 
			(PotsActivePin new 
			id: pinId;
			currentRole: (PotsDigitalInputRole new
			driver: self)
			)
		].
	"next fill out the roles dictionaries. For readability we do it for each role separately"
	"first DI (already present"
	pinDict valuesDo: [  :pin| pin addRole: (pin currentRole) ].
	"the DO role is simple "
	pinDict valuesDo: [  :pin | pin addRole: (PotsDigitalOutputRole new driver: self) ].
	"for the PWM role we have the courtesy to ask the driver for its range
	note that the frequency can be set for pins separately, TODO??"
	pinDict valuesDo: [  :pin | pin addRole: 
		(PotsPWMRole new 
			driver: self; 
			range: 255)].
	"servo mode; PiGPIO sets min and max to 500 and 2500; frequency fixedd at 50 Hz"
	pinDict valuesDo: [  :pin | pin addRole:
		(PotsServoRole new 
			driver: self;
			min: 500;
			max: 2500;
			minDegrees: 0;
			maxDegrees: 180;
			yourself) ].
	i2cRole := PotsI2CRole new driver: self.
	(pinDict  at: 2) addRole: i2cRole.
	i2cPins add: (pinDict at: 2).
	(pinDict  at: 3) addRole: i2cRole.
	i2cPins add: (pinDict at: 3).
	^pinDict
]

{ #category : #initialization }
MockPotsPiGPIODriver >> startBaseDriver [ 
	baseDriver := MockObject new
]
