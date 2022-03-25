Class {
	#name : #PotsSoloPinRole,
	#superclass : #PotsPinRole,
	#instVars : [
		'lastValue'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #activation }
PotsSoloPinRole >> activateOn: aPin [
		self subclassResponsibility 
]

{ #category : #activation }
PotsSoloPinRole >> deactivateOn: aPin [
	"only implement when cleanup after use is necessary"
]

{ #category : #reporting }
PotsSoloPinRole >> disableReportingOnPin: aPin [
	"subclass can implement, else do nothing"
]

{ #category : #reporting }
PotsSoloPinRole >> enableReportingOnPin: aPin [
	"subclass can implement, else do nothing"
]

{ #category : #accessing }
PotsSoloPinRole >> lastValue [
	^ lastValue
]

{ #category : #accessing }
PotsSoloPinRole >> value: aNmber forPin: aPin [
	"subclass decides whether to implement or not"
	Error signal: 'Pin ', aPin id asString, ' has no output role'
]

{ #category : #accessing }
PotsSoloPinRole >> valueForPin: aPin [
	"subclass decides whether to implement or not"
	Error signal: 'Pin ', aPin id asString, ' has no inputRole'
]
