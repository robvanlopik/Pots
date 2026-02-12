"
I represent the active (GPIO-)pins of a controller board. I am created by the PotsDriver.

A Pin can play different roles, but only one of them can be the currentRole.
When the currentRole is a SoloRole, the pin responds to #value and #value: for read and write operations. The value range depends on the Role, that also has the task of communicating the requested operation with the PotsDriver. Note that possible roles are assigned by the PotsDriver, so a Role will not request an operation that de driver is not capable of.

A Pin can take part in a PotsDevice; this can happen in two ways:
1) The device code manipulates the pin directly
2) The pin is ontrolled by a protocol driver like i2C or Stepper

Changing the currentRole is only possible when no device is using the pin.
Roles are changed with: 
. `beDigitalInput`
. `beDigitalOutput`
. `bePWMOutput`
. `beServoOutput`
. `beAnalogInput`
Checks are made whether the role is present and whether the pin is free (not participating in devices)

Important methods:
- #value  -  return the value of the input pin in useful units (0/1 for DI, volt for AI)
- #value:  - set the value in useful units 
- #lastValue - last value read or written


Note: a Pin doesn't do much by itself, the work is done by the currentRole and the Driver

Instance variables:
- id  -  the id of the pin in the controller documentation, usually a number, also called BCM number
- altId  -  an alternative Id, mostly used for analog pins
- roles  -  a dictionary of al possible roles the pin can have (key is a short name of the role)
- currentRolethe  -  current role of the pin
- deviceCount  -  the number of devices that use the pin (can be >1 in the case of I2C pins)
- isReporting  -  boolean used by some drivers indicating that the pin regularly reports its value (maybe also useful for state change announcements)


"
Class {
	#name : 'PotsActivePin',
	#superclass : 'PotsPin',
	#instVars : [
		'id',
		'altId',
		'roles',
		'currentRole',
		'deviceCount',
		'isReporting'
	],
	#category : 'PharoThingsSimplified',
	#package : 'PharoThingsSimplified'
}

{ #category : 'private - initialization' }
PotsActivePin >> addRole: aPotsPinRole [
	"add thi role to the roles dictionary. The key is provides by the class method ##short.
	In principle only the driver will call this method, using the info it hs about the real device"
	roles at: (aPotsPinRole class short) put: aPotsPinRole.
]

{ #category : 'accessing' }
PotsActivePin >> altId [
	^altId 
]

{ #category : 'accessing' }
PotsActivePin >> altId: anId [
	altId := anId
]

{ #category : 'inspector extensions' }
PotsActivePin >> altIdString [
	self altId ifNil: [ ^'' ].
	^self altId asString
]

{ #category : 'configuration' }
PotsActivePin >> beAnalogInput [
	self playRole: 'AI'
]

{ #category : 'configuration' }
PotsActivePin >> beAnalogOutput [
	self playRole: 'AO'
]

{ #category : 'configuration' }
PotsActivePin >> beDigitalInput [
	self playRole: 'DI'
]

{ #category : 'configuration' }
PotsActivePin >> beDigitalOutput [
	self playRole: 'DO'
]

{ #category : 'configuration' }
PotsActivePin >> bePWMOutput [
	self playRole: 'PWM'
]

{ #category : 'configuration' }
PotsActivePin >> beServoOutput [
	self playRole: 'Servo'
]

{ #category : 'inspector extensions' }
PotsActivePin >> capabilitiesString [
	"for use by inspector"
	
	| response |
	response := ''.
	self roles keys  sorted do: [  :role | response := response , role, ' ' ].
	^ response
]

{ #category : 'accessing' }
PotsActivePin >> currentRole [
	^ currentRole
]

{ #category : 'accessing' }
PotsActivePin >> currentRole: anObject [
	currentRole := anObject
]

{ #category : 'private - bookkeeping' }
PotsActivePin >> decrementDeviceCount [

	deviceCount := deviceCount - 1.
	self
		assert: [ deviceCount >= 0 ]
		description: 'device count cannot be less then zero'.
	"deviceCount := 0 looks wrong "
]

{ #category : 'accessing' }
PotsActivePin >> decrementValueBy: aNumber [
	currentRole decrementValueBy: aNumber forPin: self
]

{ #category : 'accessing' }
PotsActivePin >> deviceCount [
	^ deviceCount
]

{ #category : 'accessing' }
PotsActivePin >> deviceCount: anObject [
	deviceCount := anObject
]

{ #category : 'private - controlling' }
PotsActivePin >> disableReporting [
	"used by analog input with Firmata, or PinChange announcements in PiGPIO"
	self halt. "should not come here"
	isReporting ifFalse: [ ^self ].
	currentRole disableReportingOnPin: self.
	isReporting := false.
]

{ #category : 'private - controlling' }
PotsActivePin >> enableReporting [
	"used by analog input with Firmata, or PinChange announcements in PiGPIO"
	self halt. "should not come here"
	isReporting ifTrue: [ ^self ].
	currentRole enableReportingOnPin: self.
	isReporting := true.
]

{ #category : 'accessing' }
PotsActivePin >> id [
	^ id
]

{ #category : 'accessing' }
PotsActivePin >> id: anObject [
	id := anObject
]

{ #category : 'inspector extensions' }
PotsActivePin >> idString [
	^self id asString
]

{ #category : 'private - bookkeeping' }
PotsActivePin >> incrementDeviceCount [
	deviceCount := deviceCount + 1
]

{ #category : 'accessing' }
PotsActivePin >> incrementValueBy: aNumber [
	currentRole incrementValueBy: aNumber forPin: self
]

{ #category : 'initialization' }
PotsActivePin >> initialize [
	super initialize.
	
	roles := Dictionary new.
	deviceCount:= 0.
	isReporting := false.
]

{ #category : 'accessing' }
PotsActivePin >> isReporting [

	^ isReporting
]

{ #category : 'accessing' }
PotsActivePin >> isReporting: anObject [

	isReporting := anObject
]

{ #category : 'accessing' }
PotsActivePin >> lastValue [
	^currentRole lastValue
]

{ #category : 'private - controlling' }
PotsActivePin >> playRole: shortName [
	"change the current role
	if the pin already has the role, do nothing
	if one or more devices use the pin raise an error
	if the role is not available, raise an error	
	then the currentrole deactivates itself
	and the new role activat"

	| newRole |
	(deviceCount > 0) ifTrue: [ UIManager default confirm: 'Pin ', id asString, ' is in use; no action'. ^self ].
	(currentRole class short = shortName) ifTrue: [ ^currentRole ].
	newRole := roles at: shortName
			ifAbsent: [ UIManager default inform: 'Pin ', id asString, ' cannot be ', shortName, '; no action'. ^self ].
	"and now we must tell the driver to change the mode"
	currentRole deactivateOn: self.
	newRole activateOn: self.
	currentRole := newRole. "only when activation succeeded"
]

{ #category : 'printing' }
PotsActivePin >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: id asString;
		nextPutAll: '; ';
		nextPutAll: currentRole class short;
		nextPut: $).
	
]

{ #category : 'accessing' }
PotsActivePin >> rawValue [ 	
	^currentRole rawValueFromPin: self
]

{ #category : 'accessing' }
PotsActivePin >> rawValue: aNumber [	
	^currentRole rawValue: aNumber forPin: self
]

{ #category : 'inspector extensions' }
PotsActivePin >> roleString [
	^self currentRole class short
]

{ #category : 'accessing' }
PotsActivePin >> roles [
	^ roles
]

{ #category : 'private - initialization' }
PotsActivePin >> roles: anObject [
	roles := anObject
]

{ #category : 'accessing' }
PotsActivePin >> toggle [ 
	currentRole toggleValueForPin: self
]

{ #category : 'accessing' }
PotsActivePin >> value [ 
	"relay to my currentRole"
	^currentRole valueForPin: self
]

{ #category : 'accessing' }
PotsActivePin >> value: aNumber [
	currentRole value: aNumber forPin: self
]

{ #category : 'inspector extensions' }
PotsActivePin >> valueString [
	"this is meant for an inspector, so display lastValue"
	^self lastValue asString
]
