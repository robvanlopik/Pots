"
I represent the interface between a PotsController and the driver that really makes the physical thing (e.g. a Pi or an Arduino board, or a port extender) work

I have two main responsibilities:
1. translate uniform pin commands to actual driver commands
2. get info about pins, board name/version to initialize the Controller

Almost all of my methods are subclass responsibility
Especially instance creation is specific for the real driver/board combination

The instance variable baseDriver holds the ""real"" driver

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #PotsDriver,
	#superclass : #Object,
	#instVars : [
		'baseDriver'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #initialization }
PotsDriver >> providePinInfo [
	"return a dict of pins to the caller, with their poperties"
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
PotsDriver >> setDPWMOutputOnPin: aPin [
	self subclassResponsibility 
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
