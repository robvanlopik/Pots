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

{ #category : #'as yet unclassified' }
PotsAnalogInputRole >> activateOn: aPin [
	driver beAnalogInputOnPin: aPin
]

{ #category : #'as yet unclassified' }
PotsAnalogInputRole >> disableReportingOnPin: aPin [
	"forr the time being only for Firmata; but ther drivers have no AI role"
	driver disableAnalogReportingOnPin: aPin
]

{ #category : #'as yet unclassified' }
PotsAnalogInputRole >> enableReportingOnPin: aPin [
	"forr the time being only for Firmata; but ther drivers have no AI role"
	driver enableAnalogReportingOnPin: aPin
]

{ #category : #'as yet unclassified' }
PotsAnalogInputRole >> notifyDriverForPin: aPin [
		
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
