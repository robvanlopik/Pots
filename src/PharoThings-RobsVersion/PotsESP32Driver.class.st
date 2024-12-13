"
I am a driver for the EPS32 board, to be used in Pots. 
Basically I forward to ESP32Driver but with PotsPin replaced by its id.
And I implement getPinfo to flesh out the controller configuration
"
Class {
	#name : #PotsESP32Driver,
	#superclass : #PotsDriverDriver,
	#instVars : [
		'deviceName',
		'brokerIP',
		'i2cPins'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'instance creation' }
PotsESP32Driver class >> brokerIP: aBrokerAddress deviceName: aName [

	^self new
		brokerIP: aBrokerAddress;
		deviceName: aName ;
		yourself
]

{ #category : #'analog io' }
PotsESP32Driver >> analogValue: aValue intoPin: aPin [
	baseDriver analogValue: aValue intoPin: aPin id
]

{ #category : #'analog io' }
PotsESP32Driver >> analogValueFromPin: aPin [
	^baseDriver analogValueFromPin: aPin id
]

{ #category : #'analog io' }
PotsESP32Driver >> beAnalogInputOnPin: aPin [
	baseDriver beAnalogInputOnPin: aPin id
]

{ #category : #'analog io' }
PotsESP32Driver >> beAnalogOutputOnPin: aPin [
	^baseDriver beAnalogOutputOnPin: aPin id
]

{ #category : #'analog io' }
PotsESP32Driver >> beDigitalInputOnPin: aPin [
	^baseDriver beDigitalInputOnPin: aPin id
]

{ #category : #'digital io' }
PotsESP32Driver >> beDigitalOutputOnPin: aPin [
	^baseDriver beDigitalOutputOnPin: aPin id
]

{ #category : #pwm }
PotsESP32Driver >> bePWMOutputOnPin: aPin [
	^baseDriver bePWMOutputOnPin: aPin id
]

{ #category : #'private - controlling' }
PotsESP32Driver >> beServoOutputOnPin: aPin [
		^baseDriver beServoOutputOnPin: aPin id
]

{ #category : #accessing }
PotsESP32Driver >> brokerIP [

	^ brokerIP
]

{ #category : #accessing }
PotsESP32Driver >> brokerIP: anObject [

	brokerIP := anObject
]

{ #category : #initialization }
PotsESP32Driver >> connect [
	
]

{ #category : #'io protocols' }
PotsESP32Driver >> connectToI2CDevice: deviceAddressInt [
	^baseDriver openI2C: deviceAddressInt
	
]

{ #category : #accessing }
PotsESP32Driver >> deviceName [

	^ deviceName
]

{ #category : #accessing }
PotsESP32Driver >> deviceName: anObject [

	deviceName := anObject
]

{ #category : #'digital io' }
PotsESP32Driver >> digitalValue: oneOrZero intoPin: aPin [
	^baseDriver digitalValue: oneOrZero intoPin: aPin id
]

{ #category : #'digital io' }
PotsESP32Driver >> digitalValueFromPin: aPin [
	^baseDriver digitalValueFromPin: aPin id
]

{ #category : #finalization }
PotsESP32Driver >> disconnect [
		
]

{ #category : #accessing }
PotsESP32Driver >> i2cPins [

	^ i2cPins
]

{ #category : #initialization }
PotsESP32Driver >> providePinInfo [
	"This is called after setup and returns a pinDict dictionary"
	"the id is the index and the value is a fully filled out PotsActivePin"
	"the ESP32 has no altId's and all pins can be DI, that is also their defaul state"
	| pinDict allIds|
	i2cPins := OrderedCollection new.
	pinDict := Dictionary new.
	"first fill out the dictionary"
	allIds := baseDriver pinList.
	allIds do: [ :id | pinDict at: id put:
		(PotsActivePin new
		id: id;
		currentRole: (PotsDigitalInputRole new driver: self)) ].
	"next fill the roledis, one by one"
	"first the default DI"
	pinDict valuesDo: [  :pin | pin addRole: (pin currentRole) ].
	"DO and PWM and maybe servo as well??"
	baseDriver outputList do: [ :id |
		(pinDict at: id) addRole: (PotsDigitalOutputRole new driver: self).
		(pinDict at: id) addRole: (PotsPWMRole new driver: self).
		(pinDict at: id) addRole: (PotsServoRole new driver: self)].
	"ADC"
	baseDriver adcList do: [ :id |
		 (pinDict at: id) addRole: (PotsAnalogInputRole new driver: self)].
	"DAC"
	baseDriver dacList do: [ :id |
		 (pinDict at: id) addRole: (PotsAnalogOutputRole new driver: self)].
	"I2C"
	baseDriver i2cList do: [ :id |
		(pinDict at: id) addRole: (PotsI2CRole new driver: self).
			i2cPins add: (pinDict at: id) ].
	^pinDict
]

{ #category : #pwm }
PotsESP32Driver >> pwmValue: aPercentage intoPin: aPin [
	baseDriver pwmValue: aPercentage intoPin: aPin id
]

{ #category : #'io protocols' }
PotsESP32Driver >> rawServoValue: aNumber intoPin: aPin [

	baseDriver servoOnPin: aPin id pulseWidth: aNumber
]

{ #category : #'io protocols' }
PotsESP32Driver >> servoValue: aNumber intoPin: aPin [
	| min max minDegrees maxDegrees raw|
	min := aPin currentRole min.
	max := aPin currentRole max.
	minDegrees := aPin currentRole minDegrees .
	maxDegrees := aPin currentRole maxDegrees.
	raw := aNumber * (max - min) / (maxDegrees - minDegrees ) + min.
	self rawServoValue: raw intoPin: aPin
]

{ #category : #initialization }
PotsESP32Driver >> setup [
	baseDriver := ESP32Driver new
		deviceName: deviceName;
		brokerIP: brokerIP;
		setup
]
