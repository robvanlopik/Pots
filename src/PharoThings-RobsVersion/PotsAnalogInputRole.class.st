Class {
	#name : #PotsAnalogInputRole,
	#superclass : #PotsSoloPinRole,
	#instVars : [
		'resolution'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'accessing structure variables' }
PotsAnalogInputRole class >> short [ 
	^'AI'
]

{ #category : #accessing }
PotsAnalogInputRole >> resolution [
	^ resolution
]

{ #category : #accessing }
PotsAnalogInputRole >> resolution: anObject [
	resolution := anObject
]
