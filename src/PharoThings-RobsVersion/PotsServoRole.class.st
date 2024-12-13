"
I represent the role for driving a servo motor

By default my value is an angle in degrees (0 - 180)  with a resulting output pulse between 500 and 2500 microseconds (but the driver may have changed this). The methods in the ""parameters"" category allow changing the minimum and maximum angle and the corresponding pulse width.
"
Class {
	#name : #PotsServoRole,
	#superclass : #PotsSoloPinRole,
	#instVars : [
		'min',
		'max',
		'minDegrees',
		'maxDegrees'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'accessing structure variables' }
PotsServoRole class >> short [ 
	^'Servo'
]

{ #category : #'private - controlling' }
PotsServoRole >> activateOn: aPin [
		driver beServoOutputOnPin: aPin
]

{ #category : #'private - controlling' }
PotsServoRole >> deactivateOn: aPin [
		driver closeServoOutputOnPin: aPin
]

{ #category : #'private - accessing' }
PotsServoRole >> decrementValueBy: aNumber forPin: aPin [
	| newValue |
	newValue := (self lastValue - aNumber) max: self minDegrees.
	self value: newValue forPin: aPin
]

{ #category : #'private - accessing' }
PotsServoRole >> incrementValueBy: aNumber forPin: aPin [
	| newValue |
	newValue := (self lastValue + aNumber) min: self maxDegrees.
	self value: newValue forPin: aPin
]

{ #category : #initialization }
PotsServoRole >> initialize [ 
	"set min max (in microseconds) and minDegres and maxDegrees to defaults"
	min := 500.
	max := 2500.
	minDegrees := 0.
	maxDegrees := 180
]

{ #category : #parameters }
PotsServoRole >> max [
	^ max
]

{ #category : #parameters }
PotsServoRole >> max: anObject [
	max := anObject
]

{ #category : #parameters }
PotsServoRole >> maxDegrees [
	^ maxDegrees
]

{ #category : #parameters }
PotsServoRole >> maxDegrees: anObject [
	maxDegrees := anObject
]

{ #category : #parameters }
PotsServoRole >> min [
	^ min
]

{ #category : #parameters }
PotsServoRole >> min: anObject [
	min := anObject
]

{ #category : #parameters }
PotsServoRole >> minDegrees [
	^ minDegrees
]

{ #category : #parameters }
PotsServoRole >> minDegrees: anObject [
	minDegrees := anObject
]

{ #category : #'private - accessing' }
PotsServoRole >> rawValue: aNumber forPin: aPin [
	driver rawServoValue: aNumber intoPin: aPin

]

{ #category : #'private - accessing' }
PotsServoRole >> value: aNumber forPin: aPin [
	driver servoValue: aNumber intoPin: aPin.
	lastValue := aNumber
]
