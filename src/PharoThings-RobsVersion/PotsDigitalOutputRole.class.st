"
I represent the Digital Output Role (DO)

my values can be 0 or 1. Because I remember my last value, I can also satisfy the Pin command #toggle
"
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

{ #category : #'private - controlling' }
PotsDigitalOutputRole >> deactivateOn: aPin [
	driver closeDigitalOutputOnPin: aPin
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
