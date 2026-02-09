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
		'i2cPins',
		'guard',
		'diDict',
		'aiDict',
		'i2cDict'
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

{ #category : ' private - mode' }
PotsTMXDriver >> beDigitalInputOnPin: aPin [
	
	aPin currentRole class short = 'DI' ifTrue: [ ^self ].
	self closeCurrentRoleOfPin: aPin.
	baseDriver beDigitalInputOnPin: aPin id.
]

{ #category : ' private - mode' }
PotsTMXDriver >> beDigitalOutputOnPin: aPin [

	aPin currentRole class short = 'DO' ifTrue: [  ^self ].
	self closeCurrentRoleOfPin: aPin.
	baseDriver bePWMOutputOnPin: aPin id
]

{ #category : 'modes' }
PotsTMXDriver >> bePWMOutputOnPin: aPin [

	aPin currentRole class short = 'PWM' ifTrue: [  ^self ].
	self closeCurrentRoleOfPin: aPin.
	baseDriver bePWMOutputOnPin: aPin id
]

{ #category : 'private - mode' }
PotsTMXDriver >> beServoOnPin: aPin [
	"sero on TMX ddefalt to min=544 max=2400 "
	aPin currentRole class short = 'Servo' ifTrue: [  ^self ].
	self closeCurrentRoleOfPin: aPin.
	baseDriver beServoOutputOnPin: aPin id
]

{ #category : ' private - mode' }
PotsTMXDriver >> closeAnalogInputOnPin: aPin [
	"stop reporting"
	self todo 
]

{ #category : ' private - mode' }
PotsTMXDriver >> closeCurrentRoleOfPin: aPin [
	"Servo can be detached.
	AI and DI don't have to be closed, but their reporting has to be stopped NOT CORRECT!!"
	self halt. "should not be called"
	aPin currentRole class short = 'Servo' ifTrue: [ 
		baseDriver detachServoFromPin: (TMXConstants pinFromGpio: aPin id). ^self].
	aPin currentRole class short = 'AI' ifTrue: [ 
			self closeAIOnPin: aPin . ^self].
	aPin currentRole class short = 'DI' ifTrue: [ 
			self closeDIOnPin: aPin . ^self].
]

{ #category : ' private - mode' }
PotsTMXDriver >> closeDigitalOutputOnPin: aPin [
	"first stop reporting, then remove from diDict"
	
	baseDriver disableDigitalReportingOnPin: (TMXConstants pinFromGpio: aPin id).
	50 milliSeconds wait.  "There may be announcements still under way"
	diDict removeKey: aPin id
]

{ #category : ' private - mode' }
PotsTMXDriver >> closePWMOnPin: aPin [
]

{ #category : ' private - mode' }
PotsTMXDriver >> closeServoOnPin: aPin [
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
	guard := Mutex new.
	aiDict := Dictionary new.
	diDict := Dictionary new.
	i2cDict := Dictionary new
]

{ #category : 'instance creation' }
PotsTMXDriver >> onIP: anIpAddressString port: aPortNumber [
	ip := anIpAddressString.
	port := aPortNumber
]

{ #category : 'private - updating' }
PotsTMXDriver >> processAIEvent: ann [
	"we received an AI announcement and update aiDict
	we also convert to volts"
	| value gpio |
	
	gpio := TMXConstants gpioFromPinNr: ann pinNr.
	value := (ann pinValue) * 3.4 / 4096.0 .
	guard critical: [aiDict at: gpio put: value]
	
]

{ #category : 'private - updating' }
PotsTMXDriver >> processDIEvent: ann [
	"we received an DI announcement and update the current entry in diDict
	"
	| value gpio |
	
	gpio := TMXConstants gpioFromPinNr: ann pinNr.
	value := ann pinValue.
	guard critical: [diDict at: gpio put: value]
	
	
]

{ #category : 'io protocols' }
PotsTMXDriver >> pwmValue: aByte intoPin: aPin [
	"with default freq=5000 and 8 bits resolution (on ESP32"
	^baseDriver pwmValue: aByte intoPin: aPin id
]

{ #category : 'initialization' }
PotsTMXDriver >> setup [
	baseDriver := TMXDriver onIP: ip port: port.

]
