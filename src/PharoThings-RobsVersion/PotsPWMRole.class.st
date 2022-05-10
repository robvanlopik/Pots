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

{ #category : #'private - controlling' }
PotsPWMRole >> activateOn: aPin [
	driver bePWMOutputOnPin: aPin
]

{ #category : #'private - accessing' }
PotsPWMRole >> decrementValueBy: aNumber forPin: aPin [
	"increment but don't exceed limits; last value set to limit in that case"
	| newValue |
	newValue := (self lastValue - aNumber) max: 0.
	self value: newValue forPin:aPin
]

{ #category : #'private - accessing' }
PotsPWMRole >> incrementValueBy: aNumber forPin: aPin [
	"increment but don't exceed limits; last value set to limit in that case"
	| newValue |
	newValue := (self lastValue + aNumber) min: 100.
	self value: newValue forPin:aPin
]

{ #category : #parameters }
PotsPWMRole >> range [
	^ range
]

{ #category : #parameters }
PotsPWMRole >> range: anObject [
	range := anObject
]

{ #category : #'private - accessing' }
PotsPWMRole >> rawValue: aNumber forPin: pinid [
	"straight to the driver"
	driver rawPwmValue: aNumber intoPin: pinid
]

{ #category : #'private - accessing' }
PotsPWMRole >> value: aNumber forPin: aPin [
	driver pwmValue: aNumber intoPin: aPin.
	lastValue := aNumber
]
