"
I represent the role for driving a servo motor

We must decide what values I can sassume
PiGPIO uses the on-time in microseconds, usually between 544 and 2400
Firmata??

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.


    Implementation Points
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

{ #category : #'private-mode' }
PotsServoRole >> activateOn: aPin [
		driver beServoOutputOnPin: aPin
]

{ #category : #'as yet unclassified' }
PotsServoRole >> decrementValueBy: aNumber forPin: aPin [
	| newValue |
	newValue := (self lastValue - aNumber) max: self minDegrees.
	self value: newValue forPin: aPin
]

{ #category : #'as yet unclassified' }
PotsServoRole >> incrementValueBy: aNumber forPin: aPin [
	| newValue |
	newValue := (self lastValue + aNumber) min: self maxDegrees.
	self value: newValue forPin: aPin
]

{ #category : #accessing }
PotsServoRole >> max [
	^ max
]

{ #category : #accessing }
PotsServoRole >> max: anObject [
	max := anObject
]

{ #category : #accessing }
PotsServoRole >> maxDegrees [
	^ maxDegrees
]

{ #category : #accessing }
PotsServoRole >> maxDegrees: anObject [
	maxDegrees := anObject
]

{ #category : #accessing }
PotsServoRole >> min [
	^ min
]

{ #category : #accessing }
PotsServoRole >> min: anObject [
	min := anObject
]

{ #category : #accessing }
PotsServoRole >> minDegrees [
	^ minDegrees
]

{ #category : #accessing }
PotsServoRole >> minDegrees: anObject [
	minDegrees := anObject
]

{ #category : #'as yet unclassified' }
PotsServoRole >> rawValue: aNumber forPin: aPin [
	driver rawServoValue: aNumber intoPin: aPin

]

{ #category : #'as yet unclassified' }
PotsServoRole >> value: aNumber forPin: aPin [
	driver servoValue: aNumber intoPin: aPin.
	lastValue := aNumber
]
