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
	#name : #PotsFakeDriver,
	#superclass : #PotsDriver,
	#instVars : [
		'parameter',
		'pin2Value'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #accessing }
PotsFakeDriver class >> parameter: anObject [
	^self new 
		parameter: anObject;
		yourself
]

{ #category : #accessing }
PotsFakeDriver >> parameter [
	^parameter
]

{ #category : #accessing }
PotsFakeDriver >> parameter: anObject [
"get the paramater to use during initialisation by startBaseDriver"
	parameter := anObject
]

{ #category : #accessing }
PotsFakeDriver >> pin1 [ 	
	| pin role|
	role := PotsDigitalInputRole new.
	pin := PotsActivePin new id: 1; currentRole: role.
	pin addRole: role.
	^pin
]

{ #category : #accessing }
PotsFakeDriver >> pin2 [
	| pin role|
	role := PotsDigitalOutputRole new.
	pin := PotsActivePin new id: 2; currentRole: role.
	pin addRole: role.
	^pin
]

{ #category : #'as yet unclassified' }
PotsFakeDriver >> providePinInfo [
	"return a dictionary (key = id) of all pins with their attributes"
	| pinDict |
	pinDict := Dictionary new.
	pinDict at: 1 put: self pin1.
	pinDict at: 2 put: self pin2.
	
	
	^pinDict
]

{ #category : #operations }
PotsFakeDriver >> readDigitalValueFrom: aPin [
	^(aPin id) bitAnd: 1
]

{ #category : #writing }
PotsFakeDriver >> writeDigitalValue: oneOrZero into: aPin [
	[aPin id = 2] ifTrue: [pin2Value := oneOrZero]
]
