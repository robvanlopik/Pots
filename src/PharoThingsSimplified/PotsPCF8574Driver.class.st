"
I am a driver for the PCF8574 8-bits port extender.
I make use of an already functioning instance of a PotsPCF8574Device 
I allow my controller to function with 8 independent digital i/o pins with id's 0 - 7

example
```
pe := mypi installDevice: PotsPCF8574Device new
pe readByte
peController := PotsController new driver: (PotsPCF8574Driver usingDevice: pe)
d7 :=  peController pinWithId: 7
d7 value: 0
```
 
Internal Representation and Key Implementation Points.
ivars:
`device - the PotsPCF8574Device that performs my commands 
`ioMap - a Byte where each bit represent the function of each pin 
		(with 1 being input and 0 output. Note: this is contrary to Arduino modes, where 0 is input)

    Implementation Points
"
Class {
	#name : 'PotsPCF8574Driver',
	#superclass : 'PotsDeviceDriver',
	#instVars : [
		'ioMask',
		'stateMask'
	],
	#classInstVars : [
		'device'
	],
	#category : 'PharoThingsSimplified',
	#package : 'PharoThingsSimplified'
}

{ #category : 'as yet unclassified' }
PotsPCF8574Driver class >> onDevice: aPotsPCF8574Device [
	device := aPotsPCF8574Device
]

{ #category : 'as yet unclassified' }
PotsPCF8574Driver class >> usingDevice: aPotsPCF8574Device [
	^self basicNew usingDevice: aPotsPCF8574Device
]

{ #category : 'private-mode' }
PotsPCF8574Driver >> beDigitalInputOnPin: aPin [
	ioMask := ioMask bitAt: (aPin id + 1) put: 1.
	self digitalValue: 1 intoPin: aPin

]

{ #category : 'private-mode' }
PotsPCF8574Driver >> beDigitalOutputOnPin: aPin [
	ioMask := ioMask bitAt: (aPin id + 1) put: 0.
	"and set output to zero"
	self digitalValue: 0 intoPin: aPin.

]

{ #category : 'writing' }
PotsPCF8574Driver >> digitalValue: oneOrZero intoPin: aPin [
	stateMask := stateMask bitAt: (aPin id + 1) put: oneOrZero.
	baseDevice writeByte: stateMask
]

{ #category : 'io protocols' }
PotsPCF8574Driver >> digitalValueFromPin: aPin [
	^(baseDevice readByte) bitAt: (aPin id + 1)
]

{ #category : 'initialization' }
PotsPCF8574Driver >> providePinInfo [
	"return a dict of pins to the caller, with their poperties"
	| pinDict |
	pinDict := Dictionary new.
	0 to: 7 do:
		[ :pinId | pinDict at: pinId put: 
			(PotsActivePin new 
			id: pinId;
			currentRole: (PotsDigitalOutputRole new driver: self)) ].
	pinDict valuesDo: [ :pin | pin addRole: (pin currentRole) ].
	pinDict valuesDo: [ :pin | pin addRole: (PotsDigitalInputRole new driver: self) ].
	^pinDict
	
]

{ #category : 'initialization' }
PotsPCF8574Driver >> setup [
	
	ioMask := 0. "start with outputEvents "
	stateMask := 0.
	baseDevice writeByte: 0. "and set them to 0"
]

{ #category : 'as yet unclassified' }
PotsPCF8574Driver >> usingDevice: aPotsPCF8574Device [ 
	
	baseDevice := aPotsPCF8574Device.
	self setup
]
