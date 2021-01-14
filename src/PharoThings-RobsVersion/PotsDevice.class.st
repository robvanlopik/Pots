"
I represent a device that is operated by one or more pins of the controller

I contain the logic to translate device specific messages to instructions for either the pin or a protocol operated by a number of pins

Basic usage is: 
`dev := aController installDevice: aPotsDevice
aPotsDevice already must know everything that is needed to operated. You can use PotsDevice new if and provide default data.
Convention: 'PotsDevice new initializes with default params, else you should have a class method to to provide the data 

the controller will then ask the device to #connectTo: aController
` connectTo: sets the controller instVar , makes sure the resources (pins or other devices) are marked and available and then does `self connect.

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

{ #category : #'as yet unclassified' }
PotsDevice >> claimResources [
	self subclassResponsibility 
]

{ #category : #controlling }
PotsDevice >> connect [ 
	"this method starts the device; all relevnt info has to be present"
	self subclassResponsibility 
]

{ #category : #default }
PotsDevice >> connectTo: aController [
	controller := aController.
	self claimResources.
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

{ #category : #'as yet unclassified' }
PotsDevice >> releaseResources [
	self subclassResponsibility 
]
