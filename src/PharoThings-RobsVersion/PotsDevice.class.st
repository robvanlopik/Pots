"
I represent a device that is operated by one or more pins of the controller

I contain the logic to translate device specific messages to instructions for either the pin or a protocol operated by a number of pins

Basic usage is: 
dev := aController installDevice: PotsDevice new

the controller will ask the device to #connectTo: aController

 connectTo: sets the controller instVar , makes sure the pins are marked and then does self connect.

#connect initializes the device (eg I2C makes the I2C connection 
this implies we also need
#disconnect to close the connection and free the pins.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	board:		<Object>
	name:		<Object>
	pins:		<Object>


    Implementation Points
"
Class {
	#name : #PotsDevice,
	#superclass : #Object,
	#instVars : [
		'controller',
		'name',
		'pins'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #controlling }
PotsDevice >> connect [ 
	self subclassResponsibility 
]

{ #category : #default }
PotsDevice >> connectTo: aController [
	controller := aController.
	self allocateHelpers.
	self connect
]

{ #category : #accessing }
PotsDevice >> controller [
	^ controller
]

{ #category : #accessing }
PotsDevice >> controller: anObject [
	controller := anObject
]

{ #category : #accessing }
PotsDevice >> name [
	^ name
]

{ #category : #accessing }
PotsDevice >> name: anObject [
	name := anObject
]

{ #category : #accessing }
PotsDevice >> pins [
	^ pins
]

{ #category : #accessing }
PotsDevice >> pins: anObject [
	pins := anObject
]
