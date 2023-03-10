"
I represent a device that is operated by one or more pins of the controller

I contain the logic to translate device specific messages to instructions for either the pin(s) or a protocol operated by a number of pins

Basic usage is: 
`myDevice := aController installDevice: aPotsDevice`

aPotsDevice already must know everything that is needed to operate. You can use PotsDevice new if it provides default data.

Convention: `PotsDevice new` initializes with default parameterss, else you should have a class method  to provide the data 

the controller will then ask the device to #connectTo: aController
` connectTo:` sets the controller instVar , makes sure the resources (pins or other devices) are marked and available and then does `self connect`.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	controller:		the controller that hosts the pin the device is connected to
	name:		optiional name of device
	respources:		everything the device needs to operate, like pins (not used yet; pins haave a deviceCount for that

    Implementation Points - Chain off events:
- `myDevice := controller installDevice: (PotsDevice new ...).` 
- the installDevice`:` method tells the new PotsDevice to `connectTo: self`
- the PotsDevice performs `claimResources` folllowed by `connect`.
- `PotsDevice>>#connect` sets up the actual device
"
Class {
	#name : #PotsDevice,
	#superclass : #Object,
	#instVars : [
		'controller',
		'name',
		'resources'
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
PotsDevice >> disconnect [
	self releaseResources 
]

{ #category : #accessing }
PotsDevice >> name [
	^ name
]

{ #category : #accessing }
PotsDevice >> name: anObject [
	name := anObject
]

{ #category : #'as yet unclassified' }
PotsDevice >> releaseResources [
	self subclassResponsibility 
]
