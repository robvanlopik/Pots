"
I represent a pin (external connection) of a controller board
I have two subclasses. 
The passivePin is about ground and power pins and only serves in layouts
The PotsActivePin is equivalent to what Pot calls PotGPIO.

For the rest, see class comment of PotsActivePin
"
Class {
	#name : #PotsPin,
	#superclass : #Object,
	#instVars : [
		'controller'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #accessing }
PotsPin >> controller [
	^ controller
]

{ #category : #accessing }
PotsPin >> controller: anObject [
	controller := anObject
]
