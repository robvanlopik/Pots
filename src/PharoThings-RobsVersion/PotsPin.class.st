"
I represent a pin (external connection) of a controllerboard
I have two subclasses. 
The passivePin is about ground and power pins and only serves in layouts
The PotsActivePin is equivalent to what Pot calls PotGPIO


For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	board:		<Object>
	id:		<Object>
	lastValue:		<Object>
	presentRole:		<Object>
	roles:		<Object>


    Implementation Points
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
