"
I am a PotsDriver for the Telemetrix Nano 2040 driver
I translate Pots command to the base driver.

A notable difference is, that Pots uses GPIO numbers, wile the TMXDriver uses the native Arduino numbering.

The TMX driver knows about modes, but not for servo, where it uses attach and detach commands. Probably this has to do with the fact that only six servos are allowd.

I cannot read inputs directly but must wait for announcements, so to start with I subscribe to the following announcements from the baseDriver: 
- TMXAnalogInputEvent using #processAIEvent
- TMXDigitalInputEvent using #processDIEvent
- TMXI2CEvent using #processI2CEvent

Instance variable:
- ip	ip address of the nano
- port  port
- i2cPins ?
- guard semaphor to protect acces to the following dictionarie
- diDict digitlinput pins key gpio
- aiDict analog nput pins key: gpio
- i2cDict i2c results, key: i2c address
"
Class {
	#name : 'PotsTMXDriver',
	#superclass : 'PotsDriverDriver',
	#instVars : [
		'ip',
		'port',
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

{ #category : 'as yet unclassified' }
PotsTMXDriver >> beDigitalInputOnPin: aPin [
	| d |
	
	d := TMXConstants pinFromGpio: aPin id.
	aPin currentRole class short = 'DI' ifTrue: [ ^self ].
	self closeCurrentRoleOfPin: aPin.
	baseDriver beDigitalInputOnPin: d.
	"and get the announcements coming"
	diDict at: aPin id put: aPin.
	baseDriver enableDigitalReportingOnPin: d
]

{ #category : 'as yet unclassified' }
PotsTMXDriver >> beDigitalOutputOnPin: aPin [
.
	aPin currentRole class short = 'DO' ifTrue: [  ^self ].
	self closeCurrentRoleOfPin: aPin.
	baseDriver beDigitalOutputOnPin: (TMXConstants pinFromGpio: aPin id)
]

{ #category : 'as yet unclassified' }
PotsTMXDriver >> bePWMOutputOnPin: aPin [

	aPin currentRole class short = 'PWM' ifTrue: [  ^self ].
	self closeCurrentRoleOfPin: aPin.
	baseDriver bePWMOutputOnPin: (TMXConstants pinFromGpio: aPin id)
]

{ #category : 'as yet unclassified' }
PotsTMXDriver >> beServoOnPin: aPin [

	aPin currentRole class short = 'Servo' ifTrue: [  ^self ].
	self closeCurrentRoleOfPin: aPin.
	baseDriver attachServoToPin: (TMXConstants pinFromGpio: aPin id)
]

{ #category : 'as yet unclassified' }
PotsTMXDriver >> closeAIOnPin: aPin [
	"stop reporting"
	self todo 
]

{ #category : 'private-mode' }
PotsTMXDriver >> closeCurrentRoleOfPin: aPin [
	"Servo can be detached.
	AI and DI don't have to be closed, but their reporting has to be stopped"
	aPin currentRole class short = 'Servo' ifTrue: [ 
		baseDriver detachServoFromPin: (TMXConstants pinFromGpio: aPin id). ^self].
	aPin currentRole class short = 'AI' ifTrue: [ 
			self closeAIOnPin: aPin . ^self].
	aPin currentRole class short = 'DI' ifTrue: [ 
			self closeDIOnPin: aPin . ^self].
]

{ #category : 'as yet unclassified' }
PotsTMXDriver >> closeDIOnPin: aPin [
	"first stop reporting, then remove from diDict"
	
	baseDriver disableDigitalReportingOnPin: (TMXConstants pinFromGpio: aPin id).
	50 milliSeconds wait.  "There may be announcements coming"
	diDict removeKey: aPin id
]

{ #category : 'io protocols' }
PotsTMXDriver >> digitalValue: onezero intoPin: aPin [

	^baseDriver digitalValue: onezero intoPin: (TMXConstants pinFromGpio: aPin id) 
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

{ #category : 'as yet unclassified' }
PotsTMXDriver >> pinFromDNumber: aDNumber [
	"return a PotsPin using the dnumber. with roles DI and DO, currentRole DI and the Dnumber as altId"
	| gpio aPotsPin inputRole|
	inputRole := PotsDigitalInputRole new driver: self.
	gpio := TMXConstants gpioFromPinNr: aDNumber.
	aPotsPin := PotsActivePin new
						altId: aDNumber;
						id: gpio;
						currentRole:inputRole;
						addRole: inputRole ; 
						yourself.
	^aPotsPin
						
						
	
	
	
]

{ #category : 'as yet unclassified' }
PotsTMXDriver >> processAIEvent: ann [
	"we received an AI announcement and update the current role of the pin
	we also convert to volts"
	| value gpio |
	
	gpio := TMXConstants gpioFromPinNr: ann pinNr.
	"controller how do I get to the pin, i only have its number"
	
]

{ #category : 'as yet unclassified' }
PotsTMXDriver >> processDIEvent: ann [

]

{ #category : 'initialization' }
PotsTMXDriver >> providePinInfo [
	"return a dict of pins to the caller, with their poperties
as we use GPIO numbering we will use these as the key, but we fill it starting from the D-number 2-17 "
	| pinDict newPin|
	
	pinDict := Dictionary new.
	2 to: 17 do: [ :d | | pin |
		pin := self pinFromDNumber: d.
		pin addRole: (PotsDigitalOutputRole new driver: self).
		pin addRole: (PotsPWMRole new driver: self ).
		pin addRole: (PotsServoRole new driver: self).
		pinDict at: (pin id) put: pin].
	"pin 20 and 21 are input only"
	newPin := self pinFromDNumber: 20.
	pinDict at: (newPin id) put: newPin.
	newPin := self pinFromDNumber: 21.
	pinDict at: (newPin id) put: newPin.
	"dpin 18 and 19 are only SDA and SCL respectively, 
	according to one doc their GPIO nrs are 12 and 13 but this isn't in TMXConstants
	so we create them"
	pinDict at: 12 put: 
		(PotsActivePin new
		id: 12;
		altId: 'SDA';
		currentRole: (PotsI2CRole new driver: self);
		yourself).
	pinDict at: 13 put: 
		(PotsActivePin new
		id: 13;
		altId: 'SCL';
		currentRole: (PotsI2CRole new driver: self);
		yourself).
	(pinDict at: 12) addRole: ((pinDict at: 12) currentRole).
	(pinDict at: 13) addRole: ((pinDict at: 13) currentRole).
	^pinDict
]

{ #category : 'io protocols' }
PotsTMXDriver >> pwmValue: aByte intoPin: aPin [

	^baseDriver pwmValue: aByte intoPin: (TMXConstants pinFromGpio: aPin id) 
]

{ #category : 'initialization' }
PotsTMXDriver >> setup [
	baseDriver := TMXDriver onIP: ip port: port.
	baseDriver when: TMXDigitalInputEvent do: [ :ann | self processDIEvent: ann ] for: self. 
	baseDriver when: TMXAnalogInputEvent do: [ :ann | self processAIEvent: ann ] for: self. 
]
