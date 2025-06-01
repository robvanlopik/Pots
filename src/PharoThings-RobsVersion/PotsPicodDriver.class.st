"
I am the intermediate driver for the Raspberry Pico.

Of special interest are the role changing commands (beXyzOnPin:); The PotsController model adheres to the pattern that you first must set the role for a pin before you can use it. The underlying PicodDriver seems to work the other way around. A role must close itself and a subsequent command establishes a new role.


"
Class {
	#name : 'PotsPicodDriver',
	#superclass : 'PotsDriverDriver',
	#instVars : [
		'port',
		'baudRate',
		'i2cPins'
	],
	#category : 'PharoThings-RobsVersion',
	#package : 'PharoThings-RobsVersion'
}

{ #category : 'initialization' }
PotsPicodDriver class >> onPort: aPortString [
	^self new onPort: aPortString
]

{ #category : 'io protocols' }
PotsPicodDriver >> analogValueFromPin: aPin [

	| ref range |
	ref := aPin currentRole refVoltage.
	range := 2 ** (aPin currentRole resolution) - 1.
	^(self rawAnalogValueFromPin: aPin) * ref / range
]

{ #category : 'as yet unclassified' }
PotsPicodDriver >> beAnalogInputOnPin: aPin [
]

{ #category : 'private-mode' }
PotsPicodDriver >> beDigitalInputOnPin: aPin [

	self closeCurrentRoleOfPin: aPin.
	baseDriver setGpioInput: aPin id
]

{ #category : 'private-mode' }
PotsPicodDriver >> beDigitalOutputOnPin: aPin [

	self closeCurrentRoleOfPin: aPin.
	baseDriver setGpioOutput: aPin id value: 0 "preset with 0"
]

{ #category : 'initialization' }
PotsPicodDriver >> bePWMOutputOnPin: aPin [

	"in principle PWM and Servo are equivalenet;
	 so of former role wa servo, no action is needed"

	aPin currentRole class = 'Servo' ifFalse: [ 
		self closeCurrentRoleOfPin: aPin ]
]

{ #category : 'initialization' }
PotsPicodDriver >> beServoOutputOnPin: aPin [

	"in principle PWM and Servo are equivalenet;
	 so of former role was PWM, no action is needed"

	aPin currentRole class = 'PWM' ifFalse: [ 
		self closeCurrentRoleOfPin: aPin ]
]

{ #category : 'as yet unclassified' }
PotsPicodDriver >> closeAnalogInputOnPin: aPin [
]

{ #category : 'private-mode' }
PotsPicodDriver >> closeCurrentRoleOfPin: aPin [

	"close the current role off the pin; called by beXyzOnPin:"

	| currentRoleShort |
	currentRoleShort := aPin currentRole class short.
	currentRoleShort = 'DI' ifTrue: [ ^ baseDriver closeGpio: aPin id].
	currentRoleShort = 'DO' ifTrue: [ ^ baseDriver closeGpio: aPin id].
	currentRoleShort = 'AI' ifTrue: [ ^ baseDriver analogClose: aPin id].
	currentRoleShort = 'PWM' ifTrue: [ ^ baseDriver servoPwmClose: aPin id].
	currentRoleShort = 'Servo' ifTrue: [ 
		^ baseDriver servoPwmClose: aPin id].
	"to do: close I2C role ; or doesn't this happen because an i2c connection closes itself and can release the pin?" 
]

{ #category : 'private-mode' }
PotsPicodDriver >> closeDigitalOutputOnPin: aPin [

]

{ #category : 'initialization' }
PotsPicodDriver >> closePWMOutputOnPin: aPin [

	"in principle PWM and Servo are equivalenet;
	 so of former role wa servo, no action is needed"

]

{ #category : 'initialization' }
PotsPicodDriver >> closeServoOutputOnPin:  aPin [

	"in principle PWM and Servo are equivalenet;
	 so of former role was PWM, no action is needed"


]

{ #category : 'controlling' }
PotsPicodDriver >> connect [ 
	"do nothing"
]

{ #category : 'io protocols' }
PotsPicodDriver >> connectToI2CDevice: i2cAddress [

	"return an I2CConnection that is specific to this I2C address
	First check whether an i2cChannel is already open. You cab tell by the deviceCount of one of the I2C pins
	If not open channel 0 on pins 0 and 1"

	(i2cPins at: 1) deviceCount = 1 ifTrue: [ 
		baseDriver
			i2cOpenChannel: 0
			sda: 0
			scl: 1
			baudRate: 100000 ].
	"i2cPins do: [ :pin | pin deviceCount: pin deviceCount + 1 ]."
	^ baseDriver i2cOpenConnectionOn: 0 i2cAddress: i2cAddress
]

{ #category : 'io protocols' }
PotsPicodDriver >> digitalValue: oneZero intoPin: aPin [

	^ baseDriver digitalWrite:  aPin id value: oneZero
]

{ #category : 'io protocols' }
PotsPicodDriver >> digitalValueFromPin: aPin [

	^ baseDriver digitalRead: aPin id
]

{ #category : 'finalization' }
PotsPicodDriver >> disconnect [

	baseDriver disconnect
]

{ #category : 'accessing' }
PotsPicodDriver >> i2cPins [ 
	^i2cPins 
]

{ #category : 'initialization' }
PotsPicodDriver >> onPort: aPortName [
	"use default baudrate of 230400"
	
	self onPort: aPortName baudRate: 230400
]

{ #category : 'initialization' }
PotsPicodDriver >> onPort: aPortName baudRate: aNumber [
	"just save the data to make the connection later"
	port := aPortName.
	baudRate := aNumber
]

{ #category : 'initialization' }
PotsPicodDriver >> providePinInfo [

	"return a dict of pins to the caller, with their poperties"

	| pinDict i2cRole |
	"first enumerate all pins"
	pinDict := Dictionary new.
	0 to: 29 do: [ :pinId |
		pinDict at: pinId put: (PotsActivePin new
				 id: pinId;
				 currentRole: (PotsDigitalInputRole new driver: self)) ].

	"make 29 adc only"
	(pinDict at: 29) currentRole: (PotsAnalogInputRole new
			 driver: self;
			 refVoltage: 3.3;
			 resolution: 12;
			 yourself).
	"fill the role dictionaries of each pin"
	pinDict valuesDo: [ :pin | pin addRole: pin currentRole ].
	"all pins can be DO, except 29"
	0 to: 28 do: [ :id |
		(pinDict at: id) addRole: (PotsDigitalOutputRole new driver: self) ].
	"servo"
	0 to: 28 do: [ :id |
		(pinDict at: id) addRole: (PotsServoRole new
				 driver: self )].
	"pwm"
	0 to: 28 do: [ :id |
		(pinDict at: id) addRole: (PotsPWMRole new
				 driver: self;
				 range: 100;
				 yourself) ].

	"almost all pins can play an i2c role and there are 2 channels.
	 Due to the limitations of the present Controller model,
	we settle for one channel (0) and fixed pins: 0 for sda and
	1 for scl -- to be defined in #onnectToI2CDevice"
	i2cPins := OrderedCollection new.
	i2cRole := PotsI2CRole new driver: self.
	(pinDict at: 0) addRole: i2cRole.
	i2cPins add: (pinDict at: 0).
	(pinDict at: 1) addRole: i2cRole.
	i2cPins add: (pinDict at: 1).
	"analog inputs 26, 27, 28, 29 are a0 through a3"
	0 to: 3 do: [ :id |
		(pinDict at: id + 26)
			altId: id;
			addRole: (PotsAnalogInputRole new
					 driver: self;
					 refVoltage: 3.2; "to be measured"
					 resolution: 12; "number of bits!!"
					 yourself) ].


	"remove pins that don't exist: 23 and 24"
	pinDict removeKey: 23.
	pinDict removeKey: 24.
	^ pinDict
]

{ #category : 'io protocols' }
PotsPicodDriver >> pwmValue: aNumber intoPin: aPin [

	"no conversion needed as the base driver already uses percentages
	default frequency 1000"

	^baseDriver pwmOnPin: aPin id value: aNumber frequency: 1000
]

{ #category : 'io protocols' }
PotsPicodDriver >> rawAnalogValueFromPin: aPin [
"the basedriver uses seperate analog pin numbers"
	^ baseDriver analogRead: aPin altId
]

{ #category : 'io protocols' }
PotsPicodDriver >> rawPwmValue: aNumber intoPin: aPin [
	self pwmValue: aNumber intoPin: aPin
]

{ #category : 'io protocols' }
PotsPicodDriver >> rawServoValue: aNumber intoPin: aPin [

	baseDriver servoOnPin: aPin id pulseWidth: aNumber
	
]

{ #category : 'initialization' }
PotsPicodDriver >> setup [

	"start the PicodDriver with its parameters"

	baseDriver := PicodDriver new connectOnPort: port baudRate: baudRate.
	
]
