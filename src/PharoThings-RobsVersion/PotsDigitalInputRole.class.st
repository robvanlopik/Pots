"
I play the Digital Input Role (DI)

my values can be 0 or 1
"
Class {
	#name : #PotsDigitalInputRole,
	#superclass : #PotsSoloPinRole,
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'accessing structure variables' }
PotsDigitalInputRole class >> short [ 
	^'DI'
]

{ #category : #'private - controlling' }
PotsDigitalInputRole >> activateOn: aPin [
		driver beDigitalInputOnPin: aPin
]

{ #category : #'private - controlling' }
PotsDigitalInputRole >> deactivateOn: aPin [
		driver closeDigitalInputOnPin: aPin
]

{ #category : #'private - accessing' }
PotsDigitalInputRole >> valueForPin: aPin [

	^lastValue := driver digitalValueFromPin: aPin
]
