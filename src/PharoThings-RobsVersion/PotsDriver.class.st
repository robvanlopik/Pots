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

{ #category : #'as yet unclassified' }
PotsDriver >> beAnalogInputOnPin: aPin [
	"subclass may usee this"
]

{ #category : #'as yet unclassified' }
PotsDriver >> beDigitalInputOnPin: aPin [
	"subclass may usee this"
]

{ #category : #'as yet unclassified' }
PotsDriver >> beDigitalOutputOnPin: aPin [
	"subclass may usee this"
]

{ #category : #'as yet unclassified' }
PotsDriver >> bePWMOutputOnPin: aPin [
	"subclass may usee this"
]

{ #category : #'as yet unclassified' }
PotsDriver >> beServoOutputOnPin: aPin [
	"subclass may use this"
]

{ #category : #'as yet unclassified' }
PotsDriver >> closeAnalogInputOnPin: aPin [
	"subclass may usee this"
]

{ #category : #'as yet unclassified' }
PotsDriver >> closeDigitalInputOnPin: aPin [
	"subclass may usee this"
]

{ #category : #'as yet unclassified' }
PotsDriver >> closeDigitalOutputOnPin: aPin [
	"subclass may usee this"
]

{ #category : #'as yet unclassified' }
PotsDriver >> closePWMOutputOnPin: aPin [
	"subclass may usee this"
]

{ #category : #'as yet unclassified' }
PotsDriver >> closeServoOutputOnPin: aPin [
	"subclass may usee this"
]

{ #category : #initialization }
PotsDriver >> connect [
		self subclassResponsibility 
]

{ #category : #'io protocols' }
PotsDriver >> digitalValue: oneOrZero intoPin: aPin [
	PotsError signal: 'cannot do Digital Output'
]

{ #category : #'io protocols' }
PotsDriver >> digitalValueFromPin: aPin [
]

{ #category : #finalization }
PotsDriver >> disconnect [
		self subclassResponsibility 
]

{ #category : #initialization }
PotsDriver >> providePinInfo [
	"return a dict of pins to the caller, with their poperties"
self subclassResponsibility 
]

{ #category : #'io protocols' }
PotsDriver >> pwmValue: aNumber intoPin: aPin [
	PotsError signal: 'cannot do PWM'
]

{ #category : #'io protocols' }
PotsDriver >> rawAnalogValueFromPin: aPin [
	PotsError signal: 'cannot do raw Analog Input'
]

{ #category : #'io protocols' }
PotsDriver >> servoValue: degrees intoPin: aPin [
	PotsError signal: 'cannot do servo'
]
