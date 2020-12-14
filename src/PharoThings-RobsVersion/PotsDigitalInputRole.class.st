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
PotsDigitalInputRole >> valueForPin: aPin [
	| driver |
	driver := aPin controller driver.
	^driver readDigitalValueFrom: aPin
]
