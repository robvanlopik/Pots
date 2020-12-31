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

{ #category : #'as yet unclassified' }
PotsPWMRole >> rawValue: percentage forPin: pinid [
	"straight to the driver"
	driver writePWMValue: percentage into: pinid
]

{ #category : #'as yet unclassified' }
PotsPWMRole >> value: percentage forPin: pinid [
	"we take into account the range reported by the driver"
	| raw |
	raw := (percentage  * (self range) / 100.0 ) rounded.
	self rawValue: (raw min: (self range) max: 0) forPin: pinid
]
