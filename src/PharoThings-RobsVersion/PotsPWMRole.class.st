Class {
	#name : #PotsPWMRole,
	#superclass : #PotsSoloPinRole,
	#instVars : [
		'range'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'accessing structure variables' }
PotsPWMRole class >> short [ 
	^'PWM'
]

{ #category : #'as yet unclassified' }
PotsPWMRole >> activateOn: aPin [
	aPin controller driver setDPWMOutputOnPin: aPin
]
