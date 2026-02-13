"
I am a PotsDriver for the Telemetrix based  drivers,
I translate Pots commands to the base driver. On the side of the base driver I use the cached values of input signals

The TMX driver knows about modes, but not for servo, where it uses attach and detach commands. Probably this has to do with the fact that only six servos are allowd.

Instance variable:
- tmxStream - serial or socket to start the base driver
- i2cPins ?
- guard semaphor to protect acces to the following dictionarie

"
Class {
	#name : 'PotsTMXDriver',
	#superclass : 'PotsDriverDriver',
	#instVars : [
		'i2cPins'
	],
	#category : 'PharoThingsSimplified-tests',
	#package : 'PharoThingsSimplified',
	#tag : 'tests'
}

{ #category : 'instance creation' }
PotsTMXDriver class >> onIP: anIpAddressString [
	^self new 
		onIP: anIpAddressString port: 31335;
		yourself
]

{ #category : 'instance creation' }
PotsTMXDriver class >> onIP: anIpAddressString port: aPortNumber [
	^self new 
		onIP: anIpAddressString port: aPortNumber;
		yourself
]

{ #category : 'io protocols' }
PotsTMXDriver >> analogValueFromPin: aPin [

	| ref range |
	ref := aPin currentRole refVoltage.
	range := 2 ** (aPin currentRole resolution) - 1.
	^(self rawAnalogValueFromPin: aPin) * ref / range
]

{ #category : ' private - mode' }
PotsTMXDriver >> beDigitalInputOnPin: aPin [
	

	baseDriver beDigitalInputOnPin: aPin id.
]

{ #category : ' private - mode' }
PotsTMXDriver >> beDigitalOutputOnPin: aPin [
	baseDriver bePWMOutputOnPin: aPin id
]

{ #category : 'modes' }
PotsTMXDriver >> bePWMOutputOnPin: aPin [
	"use the driver default; maybe put these in PWMRole..."

	baseDriver bePWMOutputOnPin: aPin id
]

{ #category : 'private - mode' }
PotsTMXDriver >> beServoOnPin: aPin [
	"servo on TMX defalt to min=544 max=2400 , should store that inthe role"

	baseDriver beServoOutputOnPin: aPin id.
	"(aPin roles) at: 'Servo' "
]

{ #category : ' private - mode' }
PotsTMXDriver >> closeAnalogInputOnPin: aPin [
	"stop reporting"
	baseDriver disableAnalogReportingOnPin: aPin id
]

{ #category : ' private - mode' }
PotsTMXDriver >> closeDigitalInputOnPin: aPin [
	"stop reporting"
	baseDriver disableDigitalReportingOnPin: aPin id
]

{ #category : ' private - mode' }
PotsTMXDriver >> closeDigitalOutputOnPin: aPin [
"do nothing"

]

{ #category : ' private - mode' }
PotsTMXDriver >> closePWMOnPin: aPin [
"do nothing"
]

{ #category : ' private - mode' }
PotsTMXDriver >> closeServoOnPin: aPin [
	baseDriver detachServoFromPin: aPin id.
]

{ #category : 'io protocols' }
PotsTMXDriver >> connectToI2CDevice: deviceAddressInt [
	^baseDriver openI2C: deviceAddressInt
]

{ #category : 'utilities' }
PotsTMXDriver >> dfromg: aGPIONumber [
	"return the corresponding d number"
	
	^TMXConstants pinFromGpio: aGPIONumber 
]

{ #category : 'io protocols' }
PotsTMXDriver >> digitalValue: onezero intoPin: aPin [

	^baseDriver digitalValue: onezero intoPin: aPin id
]

{ #category : 'io protocols' }
PotsTMXDriver >> digitalValueFromPin: aPin [
	
	baseDriver digitalValueFromPin: aPin id
]

{ #category : 'accessing' }
PotsTMXDriver >> i2cPins [ 
	^i2cPins
]

{ #category : 'initialization' }
PotsTMXDriver >> initialize [

	super initialize .
	
]

{ #category : 'initialization' }
PotsTMXDriver >> providePinInfo [ 
	"return a pinDict with all pins info for digital i/o"
	| pinDict allPins |
	allPins := (baseDriver pins di) union: (baseDriver pins do).
	pinDict := Dictionary new.
	allPins do: [ :id | pinDict at: id put: 
			(PotsActivePin new
				id: id;
				currentRole: PotsNARole new	;
				yourself)
			].
	baseDriver pins di do: [ :id | (pinDict at: id) addRole: (PotsDigitalInputRole new driver: self) ].
	baseDriver pins do do: [ :id | (pinDict at: id) addRole: (PotsDigitalOutputRole new driver: self) ].
	baseDriver pins pwm do: [ :id | (pinDict at: id) addRole: (PotsPWMRole new driver: self) ].
	baseDriver pins servo do: [ :id | (pinDict at: id) addRole: (PotsServoRole new driver: self) ].
	^pinDict
]

{ #category : 'io protocols' }
PotsTMXDriver >> pwmValue: aByte intoPin: aPin [
	"with default freq=5000 and 8 bits resolution (on ESP32"
	^baseDriver pwmValue: aByte intoPin: aPin id
]
