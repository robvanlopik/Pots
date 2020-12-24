Class {
	#name : #PotsDigitalOutputRole,
	#superclass : #PotsSoloPinRole,
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'accessing structure variables' }
PotsDigitalOutputRole class >> short [ 
	^'DO'
]

{ #category : #'as yet unclassified' }
PotsDigitalOutputRole >> activateOn: aPin [
	driver beDigitalOutputOnPin: aPin
]
