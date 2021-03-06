"
I represent the active pins of a controller board

A Pin can play different roles, but only one of them can be the currentRole.
When the currentRole is a SoloRole, the pin responds to #value and #value: for read and write operations. The value range depends on the Role, that also has the task of communicating the requested operation with the PotsDriver. Note that possible roles are assigned by the PotsDriver, so a Role will not request an operation that de driver is not capable of.

A Pin can be take part in a PotsDevice; this can happen in two ways:
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

Note: a Pin doesn't do much by itself, the work is done by the currentRole and the Driver
"
Class {
	#name : #PotsActivePin,
	#superclass : #PotsPin,
	#instVars : [
		'id',
		'altId',
		'roles',
		'currentRole',
		'deviceCount',
		'isReporting'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #adding }
PotsActivePin >> addDevice [
	deviceCount := deviceCount + 1
]

{ #category : #'private-adding' }
PotsActivePin >> addRole: aPotsPinRole [
	"add thi role to the roles dictionary. The key is provides by the class method ##short.
	In principle only the driver will call this method, using the info it hs about the real device"
	roles at: (aPotsPinRole class short) put: aPotsPinRole.
]

{ #category : #accessing }
PotsActivePin >> altId [
	^altId 
]

{ #category : #accessing }
PotsActivePin >> altId: anId [
	altId := anId
]

{ #category : #controlling }
PotsActivePin >> beAnalogInput [
	self playRole: 'AI'
]

{ #category : #controlling }
PotsActivePin >> beAnalogOutput [
	self playRole: 'AO'
]

{ #category : #controlling }
PotsActivePin >> beDigitalInput [
	self playRole: 'DI'
]

{ #category : #controlling }
PotsActivePin >> beDigitalOutput [
	self playRole: 'DO'
]

{ #category : #controlling }
PotsActivePin >> bePWMOutput [
	self playRole: 'PWM'
]

{ #category : #controlling }
PotsActivePin >> beServoOutput [
	self playRole: 'Servo'
]

{ #category : #accessing }
PotsActivePin >> currentRole [
	^ currentRole
]

{ #category : #accessing }
PotsActivePin >> currentRole: anObject [
	currentRole := anObject
]

{ #category : #'as yet unclassified' }
PotsActivePin >> decrementDeviceCount [
	deviceCount := deviceCount - 1.
	self assert: [ deviceCount >= 0 ] description: 'device count cannot be less then zero'.
	deviceCount := 0
]

{ #category : #'as yet unclassified' }
PotsActivePin >> decrementValueBy: aNumber [
	currentRole decrementValueBy: aNumber forPin: self
]

{ #category : #accessing }
PotsActivePin >> deviceCount [
	^ deviceCount
]

{ #category : #accessing }
PotsActivePin >> deviceCount: anObject [
	deviceCount := anObject
]

{ #category : #'as yet unclassified' }
PotsActivePin >> disableReporting [
	"used by analog input with Firmata, or PinChange announcements in PiGPIO"
	isReporting ifFalse: [ ^self ].
	currentRole disableReportingOnPin: self.
	isReporting := false.
]

{ #category : #'as yet unclassified' }
PotsActivePin >> enableReporting [
	"used by analog input with Firmata, or PinChange announcements in PiGPIO"
	isReporting ifTrue: [ ^self ].
	currentRole enableReportingOnPin: self.
	isReporting := true.
]

{ #category : #accessing }
PotsActivePin >> id [
	^ id
]

{ #category : #accessing }
PotsActivePin >> id: anObject [
	id := anObject
]

{ #category : #'as yet unclassified' }
PotsActivePin >> incrementDeviceCount [
	deviceCount := deviceCount + 1
]

{ #category : #'as yet unclassified' }
PotsActivePin >> incrementValueBy: aNumber [
	currentRole incrementValueBy: aNumber forPin: self
]

{ #category : #initialization }
PotsActivePin >> initialize [
	super initialize.
	
	roles := Dictionary new.
	deviceCount:= 0.
	isReporting := false.
]

{ #category : #accessing }
PotsActivePin >> lastValue [
	^currentRole lastValue
]

{ #category : #'as yet unclassified' }
PotsActivePin >> playRole: shortName [
	"change the current role
	if the pin already has the role, do nothing
	if one or more devices use the pin raise an error
	if the role is not available, raise an error	"

	| newRole |
	(deviceCount > 0) ifTrue: [ Error signal: 'Pin ', id asString, ' is in use)' ].
	(currentRole class short = shortName) ifTrue: [ ^currentRole ].
	newRole := roles at: shortName 
			ifAbsent: [ Error signal: 'Pin ', id asString, ' cannot be ', shortName ].
	"and now we must tell the driver to change the mode"
	currentRole deactivateOn: self.
	currentRole := newRole.
	currentRole activateOn: self
]

{ #category : #printing }
PotsActivePin >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: id asString;
		nextPutAll: '; ';
		nextPutAll: currentRole class short;
		nextPut: $).
	
]

{ #category : #accessing }
PotsActivePin >> rawValue [ 	
	^currentRole rawValueFromPin: self
]

{ #category : #removing }
PotsActivePin >> removeDevice [
	deviceCount := ( deviceCount - 1) max: 0.
]

{ #category : #accessing }
PotsActivePin >> roles [
	^ roles
]

{ #category : #'accessing - private' }
PotsActivePin >> roles: anObject [
	roles := anObject
]

{ #category : #operations }
PotsActivePin >> toggle [ 
	currentRole toggleValueForPin: self
]

{ #category : #evaluating }
PotsActivePin >> value [ 
	"relay to my currentRole"
	^currentRole valueForPin: self
]

{ #category : #accessing }
PotsActivePin >> value: aNumber [
	currentRole value: aNumber forPin: self
]
