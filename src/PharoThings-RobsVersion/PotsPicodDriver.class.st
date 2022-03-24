Class {
	#name : #PotsPicodDriver,
	#superclass : #PotsDriverDriver,
	#instVars : [
		'port',
		'baudRate'
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
	"remove pins that don't exist: 23 and 24"
	pinDict removeKey: 23.
	pinDict removeKey: 24.
	"make 29 adc only"
	(pinDict at: 29) currentRole: (PotsAnalogInputRole new driver: self).
	"fill the role dictionaries of each pin"
	pinDict valuesDo: [ :pin | pin addRole: pin currentRole ]
	
]

{ #category : #initialization }
PotsPicodDriver >> startBaseDriver [ 	
	"start the PicodDriver with its parameters"
	baseDriver := PicodDriver new onPort: port baudRate: baudRate
]
