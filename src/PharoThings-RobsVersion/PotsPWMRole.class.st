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
	driver bePWMOutputOnPin: aPin
]

{ #category : #accessing }
PotsPWMRole >> range [
	^ range
]

{ #category : #accessing }
PotsPWMRole >> range: anObject [
	range := anObject
]
