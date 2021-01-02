Class {
	#name : #PotsFirmataDriver,
	#superclass : #PotsDriver,
	#instVars : [
		'port',
		'baudRate',
		'modeDict'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'instance creation' }
PotsFirmataDriver class >> onPort: aSerialPortName baudRate: aNumber [
		"create new instance"
		^self new 
			onPort: aSerialPortName baudRate: aNumber
	
			
]

{ #category : #accessing }
PotsFirmataDriver >> baudRate [
	^ baudRate
]

{ #category : #accessing }
PotsFirmataDriver >> baudRate: anObject [
	baudRate := anObject
]

{ #category : #'private-mode' }
PotsFirmataDriver >> beDigitalInputOnPin: aPin [
	baseDriver pin: aPin id mode: FirmataConstants pinModeInput
]

{ #category : #'private-mode' }
PotsFirmataDriver >> beDigitalOutputOnPin: aPin [
	baseDriver pin: aPin id mode: FirmataConstants pinModeOutput
]

{ #category : #'private-mode' }
PotsFirmataDriver >> bePWMOutputOnPin: aPin [
	baseDriver pin: aPin id mode: FirmataConstants pinModePwm
]

{ #category : #'private-mode' }
PotsFirmataDriver >> beServoOutputOnPin: aPin [
	baseDriver pin: aPin id mode: FirmataConstants pinModeServo
]

{ #category : #'as yet unclassified' }
PotsFirmataDriver >> createPinWithFirmataInfo: id [
	"create a PotsPin from the info in capabilities, mapping and pinstate"
	| potsPin firmataPin |
	firmataPin := baseDriver firmataPin: id.
	
	potsPin := PotsActivePin new id: id.
	"we simply try all possible roles and add themto the the pin"
	"note: Firmata counts resolution in number of bits, so we convert to max value"
	firmataPin capabilities isEmpty ifTrue: [ ^potsPin currentRole: PotsNARole new  ].
	
	firmataPin capabilities do: [  :capability | 
		capability mode = FirmataConstants pinModeAnalog ifTrue: 
			[ potsPin addRole: (PotsAnalogInputRole new resolution: (2 ** capability resolution - 1))].
		capability mode = FirmataConstants pinModeI2C ifTrue: 
			[ potsPin addRole: PotsI2CRole new  ].
		capability mode = FirmataConstants pinModeInput ifTrue: 
			[ potsPin addRole: PotsDigitalInputRole new ].
		capability mode = FirmataConstants pinModeOutput ifTrue: 
			[ potsPin addRole: PotsDigitalOutputRole new ].	
		capability mode = FirmataConstants pinModePwm ifTrue: 
			[ potsPin addRole: (PotsPWMRole new range: (2 ** capability resolution - 1)) ].
		capability mode = FirmataConstants pinModeServo ifTrue: 
			[ potsPin addRole: (PotsServoRole new  )].
		].
	potsPin roles valuesDo: [ :role | role driver: self ].
	potsPin currentRole: (potsPin roles at: (modeDict at: firmataPin mode)).
	^potsPin

]

{ #category : #'io protocols' }
PotsFirmataDriver >> digitalValueFromPin: aPin [
	^baseDriver digitalRead: aPin id
]

{ #category : #'as yet unclassified' }
PotsFirmataDriver >> getCurrentModes [
	"send #queryPinState to all pins to get the current state filled in in FirmataPins
	Because the Arduino has to answer for each pin, we insert a delay of 30 milliseconds"
	0 to: (baseDriver maxPins - 1) do: [  :pin | baseDriver queryPinState: pin. 30 milliSeconds wait ].
]

{ #category : #initialization }
PotsFirmataDriver >> initialize [ 	super initialize.
	modeDict := Dictionary new.
	modeDict at: 0 put: 'DI';
				at: 1 put: 'DO';
				at: 2 put: 'AI';
				at: 3 put: 'PWM';
				at: 4 put: 'Servo';
				at: 6 put: 'I2C'.
	
]

{ #category : #'instance creation' }
PotsFirmataDriver >> onPort: aSerialPortName baudRate: aNumber [
	"just save the datato make a connection later"
	port := aSerialPortName.
	baudRate := aNumber
]

{ #category : #accessing }
PotsFirmataDriver >> port [
	^ port
]

{ #category : #accessing }
PotsFirmataDriver >> port: anObject [
	port := anObject
]

{ #category : #initialization }
PotsFirmataDriver >> providePinInfo [
	"This is called after the basedriver is connected; we return a dictionary with allpins, their current role and their available roles; also fill in the alternative id that is used for analog inputs"
	| pinDict |
	pinDict := Dictionary new.
	self getCurrentModes .
	0 to: (baseDriver maxPins - 1) do:
		[  :id | pinDict at: id put: (self createPinWithFirmataInfo: id)].
	^pinDict
]

{ #category : #'as yet unclassified' }
PotsFirmataDriver >> startBaseDriver [ 
	"start the Firmata driver and save it"
	"Note: probably we should do some error handling !!!"
	baseDriver := Firmata onPort: port baudRate: baudRate .
]

{ #category : #writing }
PotsFirmataDriver >> writeDigitalValue: oneOrZero into: aPin [
	baseDriver directDigitalWrite: aPin id value: oneOrZero
]
