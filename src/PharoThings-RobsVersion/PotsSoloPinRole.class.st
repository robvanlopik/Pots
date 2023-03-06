"
I represent a role that a pin can play all by itself. In principle this means reading or writing a value.

Public API and Key Messages:
Reading or writing values, or changing a role, is accomplished by sending messages to a Pin, that translates the mesage to its current role. Thus methods  of roles should be considered private, with the exception of methods classified as ""parameters"" that are used to tweak the internal calulations of the role

Instance Variable
lastValue:	the last value written to the pin at the time this role was its current role


"
Class {
	#name : #PotsSoloPinRole,
	#superclass : #PotsPinRole,
	#instVars : [
		'lastValue'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'private - controlling' }
PotsSoloPinRole >> activateOn: aPin [
		self subclassResponsibility 
]

{ #category : #'private - controlling' }
PotsSoloPinRole >> deactivateOn: aPin [
	"only implement when cleanup after use is necessary"
]

{ #category : #'private - controlling' }
PotsSoloPinRole >> disableReportingOnPin: aPin [
	"subclass can implement, else do nothing"
]

{ #category : #'private - controlling' }
PotsSoloPinRole >> enableReportingOnPin: aPin [
	"subclass can implement, else do nothing"
]

{ #category : #'private - accessing' }
PotsSoloPinRole >> lastValue [
	^ lastValue
]

{ #category : #'private - accessing' }
PotsSoloPinRole >> toggleValueForPin: aPin [
	"catch-all for pin/roles that cannot be toggled"
	PotsError signal: 'Pin ', aPin id asString, 'cannot be toggled'
]

{ #category : #'private - accessing' }
PotsSoloPinRole >> value: aNmber forPin: aPin [
	"subclass decides whether to implement or not"
	PotsError signal: 'Pin ', aPin id asString, ' has no output role'
]

{ #category : #'private - accessing' }
PotsSoloPinRole >> valueForPin: aPin [
	"subclass decides whether to implement or not"
	PotsError signal: 'Pin ', aPin id asString, ' has no inputRole'
]
