Class {
	#name : #PotsDigitalInputRole,
	#superclass : #PotsSoloPinRole,
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'accessing structure variables' }
PotsDigitalInputRole class >> short [ 
	^'DI'
]

{ #category : #'as yet unclassified' }
PotsDigitalInputRole >> activateOn: aPin [
		driver beDigitalInputOnPin: aPin
]

{ #category : #'as yet unclassified' }
PotsDigitalInputRole >> valueForPin: aPin [
	
	^lastValue := driver digitalValueFromPin: aPin
]
