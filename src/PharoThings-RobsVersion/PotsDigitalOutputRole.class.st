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

{ #category : #'as yet unclassified' }
PotsDigitalOutputRole >> toggleValueForPin: aPin [
	aPin value: (aPin lastValue = 0 ) asBit
]

{ #category : #'as yet unclassified' }
PotsDigitalOutputRole >> value: oneOrZero forPin:  aPin [
	driver digitalValue: oneOrZero intoPin: aPin.
	lastValue := oneOrZero.
	
]
