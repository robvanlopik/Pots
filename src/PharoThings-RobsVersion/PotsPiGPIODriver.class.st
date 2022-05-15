"
I am a PotsDriver that uses the PiGPIO driver to communicate with a Raspberry Pi.
To start with I only serve modern Pi's.
I support DI, DO, PWM, Servo and I2C
I2C is standard on BCM pin numbers 2 and 3

I use the PiGPIOd daemon, that first has to be started on the Pi with:
`sudo pigpiod`

You create a new instance by providing the IP-address of the Pi (or 127.0.0.1 for the local Pi) and the port number (default 8888).

after starting the controller will ask for the pin information
"
Class {
	#name : #PotsPiGPIODriver,
	#superclass : #PotsDriverDriver,
	#instVars : [
		'ip',
		'port',
		'i2cPins'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'instance creation' }
PotsPiGPIODriver class >> onIP: anIpAddressString port: aPortNumber [
	^self new 
		onIP: anIpAddressString port: aPortNumber;
		yourself
]

{ #category : #controlling }
PotsPiGPIODriver >> beDigitalInputOnPin: aPin [
	baseDriver pin: aPin id mode: 0
	
]

{ #category : #controlling }
PotsPiGPIODriver >> beDigitalOutputOnPin: aPin [
	baseDriver pin: aPin id mode: 1
	
]

{ #category : #controlling }
PotsPiGPIODriver >> bePWMOutputOnPin: aPin [
	
]

{ #category : #initialization }
PotsPiGPIODriver >> connect [
	
]

{ #category : #'io protocols' }
PotsPiGPIODriver >> connectToI2CDevice: i2cAddress [
	"return an I2CConnection that is specific to this I2C address"
		^baseDriver openI2C: i2cAddress
]

{ #category : #'io protocols' }
PotsPiGPIODriver >> digitalValue: oneOrZero intoPin: aPin [ 
	baseDriver digitalWrite: aPin id value: (oneOrZero bitAnd: 1)
]

{ #category : #'io protocols' }
PotsPiGPIODriver >> digitalValueFromPin: aPin [
	^baseDriver digitalRead: aPin id
]

{ #category : #finalization }
PotsPiGPIODriver >> disconnect [ 
		baseDriver closeConnection
]

{ #category : #accessing }
PotsPiGPIODriver >> i2cPins [
	^i2cPins 
]

{ #category : #accessing }
PotsPiGPIODriver >> ip [
	^ ip
]

{ #category : #accessing }
PotsPiGPIODriver >> ip: anObject [
	ip := anObject
]

{ #category : #'instance creation' }
PotsPiGPIODriver >> onIP: anIpAddressString port: aPortNumber [
	"save to later connect"
	ip := anIpAddressString .
	port := aPortNumber .
]

{ #category : #accessing }
PotsPiGPIODriver >> port [
	^ port
]

{ #category : #accessing }
PotsPiGPIODriver >> port: anObject [
	port := anObject
]

{ #category : #initialization }
PotsPiGPIODriver >> providePinInfo [
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
			range: (baseDriver pwmRangeOnPin: pin id ))].
	"servo mode; PiGPIO sets min and max to 500 and 2500; frequency fixedd at 50 Hz"
	pinDict valuesDo: [  :pin | pin addRole:
		(PotsServoRole new 
			driver: self;
			min: 500;
			max: 2500;
			yourself) ].
	i2cRole := PotsI2CRole new driver: self.
	(pinDict  at: 2) addRole: i2cRole.
	i2cPins add: (pinDict at: 2).
	(pinDict  at: 3) addRole: i2cRole.
	i2cPins add: (pinDict at: 3).
	^pinDict
]

{ #category : #'io protocols' }
PotsPiGPIODriver >> pwmValue: aNumber intoPin: aPin [
	"convert percentage to driver units (usually 8 bits, but can be different"
	| range rawNumber|
	range := aPin currentRole range.
	rawNumber := (aNumber * range / 100.0) rounded.
	baseDriver pin: aPin id pwmWrite: (rawNumber min: range max: 0)
]

{ #category : #'io protocols' }
PotsPiGPIODriver >> rawPwmValue: aNumber intoPin: aPin [
	baseDriver pin: aPin id pwmWrite: aNumber
]

{ #category : #'io protocols' }
PotsPiGPIODriver >> rawServoValue: aNumber intoPin: aPin [

	" for PiGPIO the raw value is an integer between min and max "
	baseDriver pin: aPin id servoPulsewidth: aNumber "microseconds"
]

{ #category : #'io protocols' }
PotsPiGPIODriver >> servoValue: aNumber intoPin: aPin [
]

{ #category : #initialization }
PotsPiGPIODriver >> startBaseDriver [ 
	"start the PiGPIO driver with its parameters"
	"Note: we might want to do some error checking at this point"
	baseDriver := PiGPIO onIP: ip port: port
]
