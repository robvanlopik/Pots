Class {
	#name : #PotsPicodDriver,
	#superclass : #PotsDriverDriver,
	#instVars : [
		'port',
		'baudRate',
		'i2cPins'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'as yet unclassified' }
PotsPicodDriver >> disconnect [

	baseDriver disconnect
]

{ #category : #initialization }
PotsPicodDriver >> onPort: aPortName [
	"use default baudrate of 230400"
	
	self onPort: aPortName baudRate: 230400
]

{ #category : #initialization }
PotsPicodDriver >> onPort: aPortName baudRate: aNumber [
	"just save the data to make the connection later"
	port := aPortName.
	baudRate := aNumber
]

{ #category : #initialization }
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
				 driver: self;
				 min: 500;
				 max: 2500;
				 yourself) ].
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
	i2cRole := PotsI2CRole new driver: self.
	(pinDict at: 0) addRole: i2cRole.
	i2cPins add: (pinDict at: 0).
	(pinDict at: 1) addRole: i2cRole.
	i2cPins add: (pinDict at: 1).
	"analog inputs 26, 27, 28, 29 are a0 through a3"
	0 to: 3 do: [ :id | (pinDict at: id + 26) altId: id;
											addRole: (PotsAnalogInputRole new
			 driver: self; refVoltage: 3.3; resolution: 12; yourself)].


	"remove pins that don't exist: 23 and 24"
	pinDict removeKey: 23.
	pinDict removeKey: 24.
	^ pinDict
]

{ #category : #initialization }
PotsPicodDriver >> startBaseDriver [ 	
	"start the PicodDriver with its parameters"
	baseDriver := PicodDriver new onPort: port baudRate: baudRate
]
