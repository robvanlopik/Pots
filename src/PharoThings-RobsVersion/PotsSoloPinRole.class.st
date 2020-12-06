Class {
	#name : #PotsSoloPinRole,
	#superclass : #PotsPinRole,
	#instVars : [
		'value'
	],
	#category : #'PharoThings-RobsVersion'
}

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
