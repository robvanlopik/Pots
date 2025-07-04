"
I am the intermediate driver between a PotsController and Firmata
An instance can be created by the class method `#onPort:baudRate:`.
This is presented as argument to the `#driver:` method of the Controller

Eventually I start the vaseDriver (Firmata)


After that
- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	baudRate:		<Object>
	i2cPins:		<Object>
	modeDict:		<Object>
	port:		<Object>


    Implementation Points
"
Class {
	#name : 'PotsFirmataDriver',
	#superclass : 'PotsDriverDriver',
	#instVars : [
		'port',
		'baudRate',
		'modeDict',
		'i2cPins'
	],
	#category : 'PharoThings-RobsVersion',
	#package : 'PharoThings-RobsVersion'
}

{ #category : 'instance creation' }
PotsFirmataDriver class >> onPort: aSerialPortName baudRate: aNumber [
		"create new instance"
		^self new 
			onPort: aSerialPortName baudRate: aNumber
	
			
]

{ #category : 'io protocols' }
PotsFirmataDriver >> analogValueFromPin: aPin [
	"we use continuous pin numbers and translate conform analog mapping"
	| measurement ref range|
	ref := aPin currentRole refVoltage.
	range := aPin currentRole resolution.
	measurement := baseDriver analogRead: aPin altId .
	^measurement * ref / range
]

{ #category : 'accessing' }
PotsFirmataDriver >> baseDriver [
	^baseDriver
]

{ #category : 'accessing' }
PotsFirmataDriver >> baudRate: anObject [
	baudRate := anObject
]

{ #category : 'role changing' }
PotsFirmataDriver >> beDigitalInputOnPin: aPin [
	baseDriver pin: aPin id mode: FirmataConstants pinModeInput.
	baseDriver activateDigitalPort: ((aPin id) // 8)
]

{ #category : 'role changing' }
PotsFirmataDriver >> beDigitalOutputOnPin: aPin [
	baseDriver pin: aPin id mode: FirmataConstants pinModeOutput
]

{ #category : 'role changing' }
PotsFirmataDriver >> bePWMOutputOnPin: aPin [
	baseDriver pin: aPin id mode: FirmataConstants pinModePwm
]

{ #category : 'role changing' }
PotsFirmataDriver >> beServoOutputOnPin: aPin [
	baseDriver pin: aPin id mode: FirmataConstants pinModeServo
]

{ #category : 'io protocols' }
PotsFirmataDriver >> connectToI2CDevice: i2cAddress [
	"return an I2CConnection that is specific to this I2C address"
		^baseDriver openI2C: i2cAddress
]

{ #category : 'initialization' }
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
			[ potsPin addRole: (PotsAnalogInputRole new
									 resolution: (2 ** capability resolution - 1);
									 refVoltage: 5.0)].
		capability mode = FirmataConstants pinModeI2C ifTrue: 
			[ potsPin addRole: PotsI2CRole new. i2cPins add: potsPin ].
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
	"fill the altId for analog pins "
	potsPin altId: (firmataPin analogPinNumber ).
	^potsPin

]

{ #category : 'io protocols' }
PotsFirmataDriver >> digitalValue: oneOrZero into: aPin [
	baseDriver directDigitalWrite: aPin id value: oneOrZero
]

{ #category : 'io protocols' }
PotsFirmataDriver >> digitalValue: oneOrZero intoPin: aPin [
	baseDriver directDigitalWrite: aPin id value: oneOrZero
]

{ #category : 'io protocols' }
PotsFirmataDriver >> digitalValueFromPin: aPin [
	^baseDriver digitalRead: aPin id
]

{ #category : 'role changing' }
PotsFirmataDriver >> disableAnalogReportingOnPin: aPin [
	baseDriver deactivateAnalogPin: aPin id
]

{ #category : 'finalization' }
PotsFirmataDriver >> disconnect [ 
	baseDriver disconnect
	
]

{ #category : 'role changing' }
PotsFirmataDriver >> enableAnalogReportingOnPin: aPin [
	baseDriver activateAnalogPin: aPin altId. "use the analog pin number"
	20 milliSeconds wait. "make sure the first reading is ready"
]

{ #category : 'initialization' }
PotsFirmataDriver >> getCurrentModes [
	"send #queryPinState to all pins to get the current state filled in in FirmataPins
	Because the Arduino has to answer for each pin, we insert a delay of 30 milliseconds"
	0 to: (baseDriver maxPins - 1) do: [  :pin | baseDriver queryPinState: pin. 30 milliSeconds wait ].
]

{ #category : 'accessing' }
PotsFirmataDriver >> i2cPins [
	^i2cPins
]

{ #category : 'initialization' }
PotsFirmataDriver >> initialize [ 
	super initialize.
	modeDict := Dictionary new.
	modeDict at: 0 put: 'DI';
				at: 1 put: 'DO';
				at: 2 put: 'AI';
				at: 3 put: 'PWM';
				at: 4 put: 'Servo';
				at: 6 put: 'I2C'.
	i2cPins := OrderedCollection new
]

{ #category : 'instance creation' }
PotsFirmataDriver >> onPort: aSerialPortName baudRate: aNumber [
	"just save the data to make a connection later"
	port := aSerialPortName.
	baudRate := aNumber
]

{ #category : 'accessing' }
PotsFirmataDriver >> port [
	^ port
]

{ #category : 'accessing' }
PotsFirmataDriver >> port: anObject [
	port := anObject
]

{ #category : 'initialization' }
PotsFirmataDriver >> providePinInfo [
	"This is called after the basedriver is connected; we return a dictionary with allpins, their current role and their available roles; also fill in the alternative id that is used for analog inputs"
	| pinDict |
	pinDict := Dictionary new.
	self getCurrentModes .
	0 to: (baseDriver maxPins - 1) do:
		[  :id | pinDict at: id put: (self createPinWithFirmataInfo: id)].
	^pinDict
]

{ #category : 'io protocols' }
PotsFirmataDriver >> pwmValue: aNumber intoPin: aPin [
	"convert percentage to driver units (usually 8 bits, but can be different"
	| range rawNumber|
	range := aPin currentRole range.
	rawNumber := (aNumber * range / 100.0) rounded.
	baseDriver analogWrite: aPin id value: (rawNumber min: range max: 0)
]

{ #category : 'io protocols' }
PotsFirmataDriver >> rawAnalogValueFromPin: aPin [
	"we use continuous pin numbers and translate conform analog mapping"
	^baseDriver analogRead: aPin altId 
]

{ #category : 'io protocols' }
PotsFirmataDriver >> rawPwmValue: aNumber intoPin: aPin [
	baseDriver analogWrite: aPin id value: aNumber
]

{ #category : 'initialization' }
PotsFirmataDriver >> setup [ 
	"start the Firmata driver and save it"
	"Note: probably we should do some error handling !!!"
	baseDriver := Firmata onPort: port baudRate: baudRate .
]
