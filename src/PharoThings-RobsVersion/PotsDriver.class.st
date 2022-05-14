"
I represent the interface between a PotsController and the driver that really makes the physical thing (e.g. a Pi or an Arduino board) work

Almost all of my methods are subclass responsibility
Especially instance creation is specific for the real driver/board combination

A driver brings a controller to life. There are two types of driver:
the DriverDriver uses a protocoldriver to control a external device (eg PiGPIO, Firmata)
the DeviceDriver uses a device (especially one that contain io's that can be controlled) that has already been instantiated on another controller (eg a port extender like the PCF8574)

I have two main responsibilities:
1. translate uniform pin commands to actual driver commands
2. get info about pins, board name/version to initialize the Controller

I have a uniform API, but not all drivers have to implement all of it. Because driver methods are called by PotsRoles and PotsRoles are established by the driver (#getPinInfo) the methods in this super class should never be caklled directly; that is why they are all implemented to raise a PotsError.




"
Class {
	#name : #PotsDriver,
	#superclass : #Object,
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'io protocols' }
PotsDriver >> analogValueFromPin: aPin [
	PotsError signal: 'cannot do analog input'
]

{ #category : #initialization }
PotsDriver >> bePWMOutputOnPin: aPin [
	PotsError signal: 'cannot do PWM'
]

{ #category : #'as yet unclassified' }
PotsDriver >> connect [
		self subclassResponsibility 
]

{ #category : #writing }
PotsDriver >> digitalValue: oneOrZero intoPin: aPin [
	PotsError signal: 'cannot do Digital Output'
]

{ #category : #'io protocols' }
PotsDriver >> digitalValueFromPin: aPin [
]

{ #category : #'as yet unclassified' }
PotsDriver >> disconnect [
		self subclassResponsibility 
]

{ #category : #initialization }
PotsDriver >> providePinInfo [
	"return a dict of pins to the caller, with their poperties"
self subclassResponsibility 
]

{ #category : #writing }
PotsDriver >> pwmValue: aNumber intoPin: aPin [
	PotsError signal: 'cannot do PWM'
]

{ #category : #'io protocols' }
PotsDriver >> rawAnalogValueFromPin: aPin [
	PotsError signal: 'cannot do raw Analog Input'
]

{ #category : #'as yet unclassified' }
PotsDriver >> servoValue: degrees intoPin: aPin [
	PotsError signal: 'cannot do servo'
]

{ #category : #initialization }
PotsDriver >> startBaseDriver [
	"init the base driver with de parameters inmy instance vars"
]
