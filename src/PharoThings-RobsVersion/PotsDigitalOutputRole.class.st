Class {
	#name : #PotsDigitalOutputRole,
	#superclass : #PotsSoloPinRole,
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'accessing structure variables' }
PotsDigitalOutputRole class >> short [ 
	^'DO'
]

{ #category : #'private - controlling' }
PotsDigitalOutputRole >> activateOn: aPin [
	driver beDigitalOutputOnPin: aPin
]

{ #category : #'private - accessing' }
PotsDigitalOutputRole >> toggleValueForPin: aPin [
	aPin value: (aPin lastValue = 0 ) asBit
]

{ #category : #'private - accessing' }
PotsDigitalOutputRole >> value: oneOrZero forPin:  aPin [
	driver digitalValue: oneOrZero intoPin: aPin.
	lastValue := oneOrZero.
	
]
