"
I simulate a PotsDriver 
I supply pin data 
I react to pin commands


- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : 'PotsFakeDriver',
	#superclass : 'PotsDriver',
	#instVars : [
		'parameter',
		'pin2Value',
		'bit',
		'pwmValue',
		'i2cPins'
	],
	#category : 'PharoThingsSimplified',
	#package : 'PharoThingsSimplified'
}

{ #category : 'as yet unclassified' }
PotsFakeDriver class >> i2cPins [
	^#(2 3)
]

{ #category : 'accessing' }
PotsFakeDriver class >> parameter: anObject [
	^self new 
		parameter: anObject;
		yourself
]

{ #category : 'private-mode' }
PotsFakeDriver >> beDigitalInputOnPin: aPin [
]

{ #category : 'private-mode' }
PotsFakeDriver >> beDigitalOutputOnPin: aPin [
]

{ #category : 'private-mode' }
PotsFakeDriver >> bePWMOutputOnPin: aPin [
]

{ #category : 'private-mode' }
PotsFakeDriver >> beServoOutputOnPin: aPin [
]

{ #category : 'writing' }
PotsFakeDriver >> digitalValue: oneOrZero intoPin: aPin [
	bit := oneOrZero
]

{ #category : 'as yet unclassified' }
PotsFakeDriver >> digitalValueFromPin: aPin [
	^bit
]

{ #category : 'accessing' }
PotsFakeDriver >> i2cPins [
	^i2cPins 
]

{ #category : 'initialization' }
PotsFakeDriver >> initialize [ 
	super initialize.
	bit := 0
]

{ #category : 'accessing' }
PotsFakeDriver >> parameter [
	^parameter
]

{ #category : 'accessing' }
PotsFakeDriver >> parameter: anObject [
"get the paramater to use during initialisation by startBaseDriver"
	parameter := anObject
]

{ #category : 'initialization' }
PotsFakeDriver >> pin1 [ 	
	| pin role|
	role := PotsDigitalInputRole new driver: self.
	pin := PotsActivePin new id: 1; currentRole: role.
	pin addRole: role.
	^pin
]

{ #category : 'initialization' }
PotsFakeDriver >> pin2 [
	| pin role|
	role := PotsDigitalInputRole new driver: self.
	pin := PotsActivePin new id: 2; currentRole: role.
	pin addRole: role.
	pin addRole: (PotsDigitalOutputRole new driver: self).
	^pin
]

{ #category : 'initialization' }
PotsFakeDriver >> pin3 [
	| pin role|
	role := PotsDigitalInputRole new driver: self.
	pin := PotsActivePin new id: 3; currentRole: role.
	pin addRole: role.
	pin addRole: (PotsI2CRole new driver: self).
	^pin
]

{ #category : 'initialization' }
PotsFakeDriver >> pin4 [
	| pin role|
	role := PotsDigitalInputRole new driver: self.
	pin := PotsActivePin new id: 4; currentRole: role.
	pin addRole: role.
	pin addRole: (PotsI2CRole new driver: self).
	^pin
]

{ #category : 'initialization' }
PotsFakeDriver >> pin5 [
	| pin role|
	role := PotsDigitalInputRole new driver: self.
	pin := PotsActivePin new id: 5; currentRole: role.
	pin addRole: role.
	pin addRole: (PotsPWMRole new driver: self; range: 255; yourself).
	^pin
]

{ #category : 'initialization' }
PotsFakeDriver >> providePinInfo [
	"return a dictionary (key = id) of all pins with their attributes"
	| pinDict |
	pinDict := Dictionary new.
	pinDict at: 1 put: self pin1.
	pinDict at: 2 put: self pin2.
	pinDict at: 3 put: self pin3.
	pinDict at: 4 put: self pin4.
	pinDict at: 5 put: self pin5.
	
	^pinDict
]

{ #category : 'io protocols' }
PotsFakeDriver >> pwmValue: aNumber intoPin: aPin [
	pwmValue := aNumber

]

{ #category : 'initialization' }
PotsFakeDriver >> setup [ 	
	"do nothing"
]
