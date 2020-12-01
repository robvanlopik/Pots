"
I represent a digital Controllerboard. 

I initiate the communication with the hardware, hold the pins that eventually interact with the outside world

Pins are my external interface, that may be detailed by a layout (where is each pin locatedd on the board or device?))

In a sense I am an intermediate between pins and the drivers that talk to the hardware.
I also hold devices that are mor complex objects that manipulate my pins, be it directly or through some protocol (like I2C).)

A controller is created by naming its potsDriver:, including th
PotsController 
- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	driver:		<Object>
	layout:		<Object>
	pins:		<Object>


    Implementation Points
"
Class {
	#name : #PotsController,
	#superclass : #Object,
	#instVars : [
		'driver',
		'pins',
		'layout',
		'name',
		'devices'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #controlling }
PotsController >> connectDriver [
	driver startBaseDriver
]

{ #category : #'io protocols' }
PotsController >> connectToI2CDevice: deviceAddressInt [
	^driver connectToI2CDevice: deviceAddressInt
]

{ #category : #accessing }
PotsController >> driver [
	^ driver
]

{ #category : #accessing }
PotsController >> driver: aControllerDriver [
	driver := aControllerDriver.
	self connectDriver.
	self getPinInfo
]

{ #category : #'as yet unclassified' }
PotsController >> getPinInfo [
	"comment stating purpose of instance-side message"
	"scope: class-variables  &  instance-variables"	
			
	pins := driver ProvidePinInfo
]

{ #category : #accessing }
PotsController >> layout [
	^ layout
]

{ #category : #accessing }
PotsController >> layout: anObject [
	layout := anObject
]

{ #category : #accessing }
PotsController >> name [
	^ name
]

{ #category : #accessing }
PotsController >> name: anObject [
	name := anObject
]

{ #category : #accessing }
PotsController >> pins [
	^ pins
]

{ #category : #accessing }
PotsController >> pins: anObject [
	pins := anObject
]
