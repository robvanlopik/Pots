"
I represent a pin (external connection) of a controller board
I have two subclasses. 
The passivePin is about ground and power pins and only serves in layouts
The PotsActivePin is equivalent to what Pot calls PotGPIO.

For the rest, see class comment of PotsActivePin
"
Class {
	#name : 'PotsPin',
	#superclass : 'Object',
	#instVars : [
		'controller'
	],
	#category : 'PharoThings-RobsVersion',
	#package : 'PharoThings-RobsVersion'
}

{ #category : 'inspector extensions' }
PotsPin >> altIdString [
	^self subclassResponsibility
]

{ #category : 'inspector extensions' }
PotsPin >> capabilitiesString [
	^self subclassResponsibility
]

{ #category : 'accessing' }
PotsPin >> controller [
	^ controller
]

{ #category : 'accessing' }
PotsPin >> controller: anObject [
	controller := anObject
]

{ #category : 'inspector extensions' }
PotsPin >> idString [
	^self subclassResponsibility
]

{ #category : 'inspector extensions' }
PotsPin >> roleString [
	^self subclassResponsibility
]

{ #category : 'inspector extensions' }
PotsPin >> valueString [
	^self subclassResponsibility
]
