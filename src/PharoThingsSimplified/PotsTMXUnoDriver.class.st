"
I drive the Arduino Uno using the Telemetrix  driver
"
Class {
	#name : 'PotsTMXUnoDriver',
	#superclass : 'PotsTMXDriver',
	#instVars : [
		'portName',
		'baudRate'
	],
	#category : 'PharoThingsSimplified-tests',
	#package : 'PharoThingsSimplified',
	#tag : 'tests'
}

{ #category : 'instance creation' }
PotsTMXUnoDriver >> onPort: aSerialPortName baudRate: aNumber [
	"just save the data to make a connection later"
	portName := aSerialPortName.
	baudRate := aNumber
]

{ #category : 'initialization' }
PotsTMXUnoDriver >> providePinInfo [
	"TMX has no idea of pin mode at startup. Maybe NARole is useful here"
	
	| pinDict |
	pinDict := super providePinInfo.
	baseDriver pins ai do: [ :id | (pinDict at: id) addRole: (PotsAnalogInputRole new driver: self;
																				refVoltage: 5.0;
																				resolution: 10;
																				yourself)].
	^pinDict
]

{ #category : 'initialization' }
PotsTMXUnoDriver >> setup [ 
	baseDriver := TMXUnoDriver new connectOnPort: portName baudRate: 115200.
]
