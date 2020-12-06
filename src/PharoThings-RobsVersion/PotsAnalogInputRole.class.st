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

{ #category : #'as yet unclassified' }
PotsAnalogInputRole >> valueForPin: aPin [
	"get an analog input value 
	use Firmata-like selector"
	| driver |
	driver := 1
]
