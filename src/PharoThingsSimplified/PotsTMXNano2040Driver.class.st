"
I serve as the Pots driver for the Arduino Nao 2040 over wifi.

I have a special problem because the base driver, TMXNano2040Driver, uses native pin numbering, while in Pots we decided to only use GPIO numbering. Trtanslation takes place in all gf my methods
"
Class {
	#name : 'PotsTMXNano2040Driver',
	#superclass : 'PotsTMXDriver',
	#category : 'PharoThingsSimplified-tests',
	#package : 'PharoThingsSimplified',
	#tag : 'tests'
}

{ #category : ' private - mode' }
PotsTMXNano2040Driver >> beDigitalInputOnPin: aPin [
	| d |
	
	d := TMXConstants pinFromGpio: aPin id.
	aPin currentRole class short = 'DI' ifTrue: [ ^self ].
	self closeCurrentRoleOfPin: aPin.
	baseDriver beDigitalInputOnPin: d.

]

{ #category : ' private - mode' }
PotsTMXNano2040Driver >> beDigitalOutputOnPin: aPin [
	| d |
	d := self dfromg: aPin id.
	aPin currentRole class short = 'DO' ifTrue: [  ^self ].
	self closeCurrentRoleOfPin: aPin.
	baseDriver bePWMOutputOnPin: d
]

{ #category : 'private - mode' }
PotsTMXNano2040Driver >> bePWMOutputOnPin: aPin [
	| d |
	
	d := self dfromg: aPin id.
	aPin currentRole class short = 'PWM' ifTrue: [  ^self ].
	self closeCurrentRoleOfPin: aPin.
	baseDriver bePWMOutputOnPin: d
]

{ #category : ' private - mode' }
PotsTMXNano2040Driver >> beServoOnPin: aPin [

	aPin currentRole class short = 'Servo' ifTrue: [  ^self ].
	self closeCurrentRoleOfPin: aPin.
	baseDriver attachServoToPin: (TMXConstants pinFromGpio: aPin id)
]

{ #category : ' private - mode' }
PotsTMXNano2040Driver >> beServoOnPin: aPin

beServoOnPin: aPin [
	"sero on TMX ddefalt to min=544 max=2400 "
	aPin currentRole class short = 'Servo' ifTrue: [  ^self ].
	self closeCurrentRoleOfPin: aPin.
	baseDriver beServoOutputOnPin: (self dfromg: aPin id)
]

{ #category : 'utilities' }
PotsTMXNano2040Driver >> dfromg: aGPIONumber [
	"return the corresponding d number"
	
	^TMXConstants pinFromGpio: aGPIONumber 
]

{ #category : 'io protocols' }
PotsTMXNano2040Driver >> digitalValue: onezero intoPin: aPin [

	^baseDriver digitalValue: onezero intoPin: (TMXConstants pinFromGpio: aPin id) 
]

{ #category : 'io protocols' }
PotsTMXNano2040Driver >> digitalValueFromPin: aPin [
	
	baseDriver digitalValueFromPin: (self dfromg: aPin id)
]

{ #category : 'utilities' }
PotsTMXNano2040Driver >> gfromd: aDNumber [
	"return Nano2040 d number from gpio nr"
	
	^TMXConstants gpioFromPinNr: aDNumber 
]

{ #category : 'private - initialization' }
PotsTMXNano2040Driver >> pinFromDNumber: aDNumber [
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

{ #category : 'io protocols' }
PotsTMXNano2040Driver >> pwmValue: aByte intoPin: aPin [

	^baseDriver pwmValue: aByte intoPin: (TMXConstants pinFromGpio: aPin id) 
]
