"
I represent a Microprocesssor Controller board. 
I initiate the communication with the hardware and hold the pins that eventually interact with the outside world.
Pins are my external interface, that may be detailed by a layout (where is each pin located on the board or device)
I also hold devices that are mor complex objects that manipulate my pins, be it directly or through some protocol (like I2C).)

A controller is created by naming its PotsDriver, e,g
``` Smalltalk
myPi := PotsController new driver: (PotsPiGPIODriver onIP: '192.168.1.92' port: 8888).
myArduino := PotsController new driver: (PotsFirmataDriver onPort: 'COM3' baudRate: 57600).
myPico := PotsController new driver: (PotsPicodDriver onPort: '/dev/ttyACM0').
```
A specific pin can be found through its Id:
``` Smalltalk
LED := myController pinWithId: 13.
``` 
Internal Representation and Key Implementation Points.

Instance Variables
- driver:		a PotsDriver (itself using a device driver)
- layout:		describes the layout of pins on the physical device (only needed for inspectors)
- pins:		a dictionary of all active pins, indexed by GPIO Id. It is created by the PotsDriver as a result of a call to #getPinInfo.
- name:		optional name of the controller
- devices:	an OrderedCollection of the PotsDevices that have been installed on this controller

Implementation Points
The PotsController makes sure that pins are correctly used, devices allocate their pins etc. At the basis is the common API of all PotsDrivers. Functionality that is specific to a specific driver can be used through 
```Smalltalk
myController driver baseDriver
```
"
Class {
	#name : 'PotsController',
	#superclass : 'Object',
	#instVars : [
		'driver',
		'pins',
		'layout',
		'name',
		'devices'
	],
	#category : 'PharoThings-RobsVersion',
	#package : 'PharoThings-RobsVersion'
}

{ #category : 'initialization' }
PotsController >> connectDriver [
	driver setup "for a DriverDriver start the base driver, for a DeviceDriver do other inits"
]

{ #category : 'io protocols' }
PotsController >> connectToI2CDevice: deviceAddressInt [

	"private !
	called in the course of starting an I2cDevice 
	(that already knows its address)"

	^ driver connectToI2CDevice: deviceAddressInt
]

{ #category : 'accessing' }
PotsController >> devices [
	^devices 
]

{ #category : 'finalization' }
PotsController >> disconnect [ 
	"orderly shutdown"
	devices do: [  :each | each disconnect ].
	driver disconnect
]

{ #category : 'accessing' }
PotsController >> driver [
	^ driver
]

{ #category : 'initialization' }
PotsController >> driver: aControllerDriver [
	driver := aControllerDriver.
	self connectDriver.
	self getPinInfo
]

{ #category : 'initialization' }
PotsController >> getPinInfo [
	"let the driver provide the pin info"
	"AND take ownership of the pins"

	pins := driver providePinInfo.
	pins valuesDo: [ :pin | pin controller: self ] "make sure the pins know where they belong to"
]

{ #category : 'initialization' }
PotsController >> initialize [ 
	super initialize.
	pins := Dictionary new.
	devices := OrderedCollection new
	
]

{ #category : 'inspector extensions' }
PotsController >> inspectionController: aBuilder [
	<inspectorPresentationOrder: 0 title: 'Pins'>
	| table list |
	
	layout ifNil: [ 
	list := pins values sorted: [ :c1 :c2 | c1 id < c2 id ].
	
	^ aBuilder newTable
		items: list ;
		addColumn: ((SpStringTableColumn 
			title: 'pinId'
			evaluated: [ :pin | pin idString ]
			width: 40)
				compareFunction: [ :c1 :c2 | c1 id < c2 id]);
		addColumn: (SpStringTableColumn
			title: 'altId'
			evaluated: [ :pin | pin altIdString]
			width: 40);
		addColumn: (SpStringTableColumn 
			title: 'role'
			evaluated: [ :pin | pin roleString ]
			width: 40);
		addColumn: (SpStringTableColumn 
			title: 'value'
			evaluated: [ :pin | pin valueString ]
			width: 40);
		addColumn: (SpStringTableColumn 
			title: 'capabilities'
			evaluated: [ :pin | pin capabilitiesString ]
			width: 150);
		yourself ].
	
	list := layout pinMatrix groupsOf: 2.
	^ aBuilder newTable
		items: list;
		addColumn: (SpStringTableColumn 
			title: 'capabilities'
			evaluated: [ :row | (row at: 1) capabilitiesString ]
			width: 150);
		addColumn: (SpStringTableColumn 
			title: 'value'
			evaluated: [ :row | (row at: 1) valueString ]
			width: 40);
		addColumn: (SpStringTableColumn 
			title: 'role'
			evaluated: [ :row | (row at: 1) roleString ]
			width: 40);
		addColumn: (SpStringTableColumn 
			title: 'altId'
			evaluated: [ :row | (row at: 1) altIdString ]
			width: 40);
		addColumn: (SpStringTableColumn 
			title: 'id'
			evaluated: [ :row | (row at: 1) idString ]
			width: 30);
		addColumn: (SpStringTableColumn 
			title: ' '
			evaluated: [ :row | '' ]
			width: 30);
		addColumn: (SpStringTableColumn 
			title: 'id'
			evaluated: [ :row | (row at: 2) idString ]
			width: 40);
		addColumn: (SpStringTableColumn 
			title: 'altId'
			evaluated: [ :row | (row at: 2) altIdString  ]
			width: 40);
		addColumn: (SpStringTableColumn 
			title: 'role'
			evaluated: [ :row | (row at: 2) roleString ]
			width: 40);
		addColumn: (SpStringTableColumn 
			title: 'value'
			evaluated: [ :row | (row at: 2) valueString ]
			width: 40);
		addColumn: (SpStringTableColumn 
			title: 'capabilities'
			evaluated: [ :row | (row at: 2) capabilitiesString ]
			width: 150);
		yourself
]

{ #category : 'add/remove device' }
PotsController >> installDevice: aPotsDevice [

	"return an instance of a PotsDevice. 
	aPotsDevice already must contain the necessary information,
	 eg pins needed and protocol info like i2c address
	e.g. controller installDevice: (PotsI2CDevoce on: anAddress)"

	aPotsDevice connectTo: self.
	devices add: aPotsDevice.
	^ aPotsDevice
]

{ #category : 'inspector extensions' }
PotsController >> installLayout: aPotsLayout [
	"install a PotsLayout. This presuppoese that the layout has been initialised
	with a plainMatrix for a specific board, so the incantation would be e.g:
	installLayout: PotsLayout forPico"
	
	layout := aPotsLayout applyTo: self
]

{ #category : 'accessing' }
PotsController >> layout [
	^ layout
]

{ #category : 'accessing' }
PotsController >> layout: anObject [
	layout := anObject
]

{ #category : 'accessing' }
PotsController >> name [
	^ name
]

{ #category : 'accessing' }
PotsController >> name: anObject [
	name := anObject
]

{ #category : 'accessing' }
PotsController >> pinWithAltId: anId [
	"return the pin with altId anId or nil"

	pins valuesDo: [  :p | (p altId = anId) ifTrue: [ ^p ]  ].
	^nil
]

{ #category : 'accessing' }
PotsController >> pinWithId: id [
	"return the pin with altId id or nil "
	^pins at: id
]

{ #category : 'accessing' }
PotsController >> pins [
	^ pins
]

{ #category : 'accessing' }
PotsController >> pins: anObject [
	pins := anObject
]

{ #category : 'add/remove device' }
PotsController >> removeDevice: aDevice [
	aDevice disconnect.
	devices remove: aDevice
]

{ #category : 'finalization' }
PotsController >> reset [
	"back to state after initialisation, that is"
	"no devices, pins in original state, reset of base driver"

	devices do: [  :each | each disconnect ].
	driver reset.
	self getPinInfo
]
