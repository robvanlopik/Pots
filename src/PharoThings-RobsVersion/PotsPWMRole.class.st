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

{ #category : #'as yet unclassified' }
PotsPWMRole >> decrementValueBy: aNumber forPin: aPin [
	"increment but don't exceed limits; last value set to limit in that case"
	| newValue |
	newValue := (self lastValue - aNumber) max: 0.
	self value: newValue forPin:aPin
]

{ #category : #'as yet unclassified' }
PotsPWMRole >> incrementValueBy: aNumber forPin: aPin [
	"increment but don't exceed limits; last value set to limit in that case"
	| newValue |
	newValue := (self lastValue + aNumber) min: 100.
	self value: newValue forPin:aPin
]

{ #category : #accessing }
PotsPWMRole >> range [
	^ range
]

{ #category : #accessing }
PotsPWMRole >> range: anObject [
	range := anObject
]

{ #category : #'as yet unclassified' }
PotsPWMRole >> rawValue: aNumber forPin: pinid [
	"straight to the driver"
	driver rawPwmValue: aNumber intoPin: pinid
]

{ #category : #'as yet unclassified' }
PotsPWMRole >> value: aNumber forPin: aPin [
	driver pwmValue: aNumber intoPin: aPin.
	lastValue := aNumber
]
