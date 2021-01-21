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
"
Class {
	#name : #PotsDriver,
	#superclass : #Object,
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'io protocols' }
PotsDriver >> analogValueFromPin: aPin [
	self subclassResponsibility 
]

{ #category : #initialization }
PotsDriver >> bePWMOutputOnPin: aPin [
	self subclassResponsibility 
]

{ #category : #writing }
PotsDriver >> digitalValue: oneOrZero intoPin: aPin [
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
]

{ #category : #'io protocols' }
PotsDriver >> rawAnalogValueFromPin: aPin [
	self subclassResponsibility 
]

{ #category : #'io protocols' }
PotsDriver >> readAnalogValueFrom: aPin [
	self subclassResponsibility 
]

{ #category : #'io protocols' }
PotsDriver >> readDigitalValueFrom: aPin [
]

{ #category : #initialization }
PotsDriver >> startBaseDriver [
	"init the base driver with de parameters inmy instance vars"
]

{ #category : #writing }
PotsDriver >> writeDigitalValue: oneOrZero into: aPin [
]

{ #category : #writing }
PotsDriver >> writePWMValue: aNumber into: aPin [
]
