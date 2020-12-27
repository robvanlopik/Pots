Class {
	#name : #PotsSoloPinRole,
	#superclass : #PotsPinRole,
	#instVars : [
		'lastValue'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'as yet unclassified' }
PotsSoloPinRole >> activateOn: aPin [
		self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
PotsSoloPinRole >> deactivateOn: aPin [
	"only implement when cleanup after use is necessary"
]

{ #category : #accessing }
PotsSoloPinRole >> lastValue [
	^ lastValue
]

{ #category : #'as yet unclassified' }
PotsSoloPinRole >> value: aNmber forPin: aPin [
	"subclass decides whether to implement or not"
	Error signal: 'Pin ', aPin id asString, ' has no output role'
]

{ #category : #'as yet unclassified' }
PotsSoloPinRole >> valueForPin: aPin [
	"subclass decides whether to implement or not"
	Error signal: 'Pin ', aPin id asString, ' has no inputRole'
]
