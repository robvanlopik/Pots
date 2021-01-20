"
I am a driver for the PCF8574 8-bits port extender.
I make use of an already functioning instance of a PotsPCF8574Device 
I make my controller function with 8 independent digital i/o pins with id's 0 - 7

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.
ivars:
`device - the PotsPCF8574Device that performs my commands 
`ioMap - a Byte where each bits represent the function of each pin 
		(with 1 being input and 0 output. Note: this is contrary to Arduino modes, where 0 is input)


)

    Implementation Points
"
Class {
	#name : #PotsPCF8574Driver,
	#superclass : #PotsDriver,
	#instVars : [
		'device',
		'ioMask'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'private-mode' }
PotsPCF8574Driver >> beDigitalInputOnPin: aPin [

]

{ #category : #'private-mode' }
PotsPCF8574Driver >> beDigitalOutputOnPin: aPin [

]

{ #category : #writing }
PotsPCF8574Driver >> digitalValue: oneOrZero intoPin: aPin [
]

{ #category : #'io protocols' }
PotsPCF8574Driver >> digitalValueFromPin: aPin [
]

{ #category : #initialization }
PotsPCF8574Driver >> providePinInfo [
	"return a dict of pins to the caller, with their poperties"
	| pinDict |
	0 to: 7 do:
		[ :pinId | pinDict at: pinId put: 
			(PotsActivePin new 
			id: pinId;
			currentRole: (PotsDigitalOutputRole new driver: self)) ].
	pinDict valuesDo: [ :pin | pin addRole: (pin currentRole) ].
	pinDict valuesDo: [ :pin | pin addRole: (PotsDigitalInputRole new driver: self) ].
	^pinDict
	
]