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
PotsPWMRole >> rawValue: aNumber forPin: pinid [
	"straight to the driver"
	driver rawPwmValue: aNumber intoPin: pinid
]

{ #category : #'as yet unclassified' }
PotsPWMRole >> value: aNumber forPin: aPin [
	driver pwmValue: aNumber intoPin: aPin
]
