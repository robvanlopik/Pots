"
I represent a common 16x2 LCD device. 
For now I will use the 4-pins interface and immplement only a few features
I use the following instance variables (defaults are for Arduino):
- enPin ""the enable pin (default 12)""
- rsPin ""the cpmmand/data switch pin 9default(11)""
- dataPins ""an collection of four pins for the data/command exchange (5 4,3 2)""

"
Class {
	#name : #PotsHD44780Device,
	#superclass : #PotsDevice,
	#instVars : [
		'enPin',
		'rsPin',
		'dataPins'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'instance creation' }
PotsHD44780Device class >> enPin: aPin1 rsPin: aPin2 dataPins: anArrayOf4Pins [
	^self new 	
		enPin: aPin1;
		rsPin: aPin2;
		dataPins: anArrayOf4Pins
]

{ #category : #'as yet unclassified' }
PotsHD44780Device >> assignDefaultPins [
	| pinIds |
	pinIds := self defaultPinIds .
	enPin := controller pinWithId: (pinIds at: 1).
	rsPin := controller pinWithId: (pinIds at: 2).
	dataPins := (pinIds allButFirst: 2) collect: [  :id | controller pinWithId: id ]
]

{ #category : #'as yet unclassified' }
PotsHD44780Device >> claimResources [
	"we need the pins and claim them"
	enPin isNil ifTrue: [ self assignDefaultPins ].
	enPin beDigitalOutput deviceCount: 1 .
	rsPin beDigitalOutput deviceCount: 1.
	1 to: 4 do: [  :i | (dataPins at: i) beDigitalOutput deviceCount: 1 ]
	
]

{ #category : #commands }
PotsHD44780Device >> clearDisplay [
	"clear display and reset cursor"
	self writeCommand: 2r00000001.
	3 milliSeconds wait
]

{ #category : #controlling }
PotsHD44780Device >> connect [
	"pins already have been set in claimResources. Remains the initialisationof the display
	which may be left as default"
	self initializeRegisters
]

{ #category : #accessing }
PotsHD44780Device >> dataPins [
	^ dataPins
]

{ #category : #accessing }
PotsHD44780Device >> dataPins: anObject [
	dataPins := anObject
]

{ #category : #initialization }
PotsHD44780Device >> defaultPinIds [
		"return an array of pinIds in case the device has no pins assigned. To be used in claimResources"
		"sequence EN, RS, D4, D5, D6, D7"
		^#(11 12 5 4 3 2)
]

{ #category : #controlling }
PotsHD44780Device >> disconnect [
	self releaseResources .
]

{ #category : #accessing }
PotsHD44780Device >> enPin [
	^ enPin
]

{ #category : #accessing }
PotsHD44780Device >> enPin: anObject [
	enPin := anObject
]

{ #category : #initialization }
PotsHD44780Device >> initializeRegisters [
	
self clearDisplay
]

{ #category : #'as yet unclassified' }
PotsHD44780Device >> releaseResources [
	enPin  deviceCount: 0 .
	rsPin deviceCount: 0.
	1 to: 4 do: [  :i | (dataPins at: i) deviceCount: 0 ]

]

{ #category : #accessing }
PotsHD44780Device >> rsPin [
	^ rsPin
]

{ #category : #accessing }
PotsHD44780Device >> rsPin: anObject [
	rsPin := anObject
]

{ #category : #writing }
PotsHD44780Device >> showMessage: aString [
	| i |
	i := 1.
	aString
		do: [ :char | 
			char = Character cr
				ifTrue: [ self setCursorAtRow: (i := i + 1) ]
				ifFalse: [ self writeCharacter: char asciiValue ] ]
]

{ #category : #'as yet unclassified' }
PotsHD44780Device >> syncPulse [
	enPin value: 0; value: 1; value: 0  "would like to time this"
]

{ #category : #writing }
PotsHD44780Device >> write: aByte mode: oneOrZero [
	"mode 0 i command,mode 1 is char. Use writeCommand: and writeCharacter"
	0.001 milliSeconds wait. "That's from PotLCDHD44780Gpio "
	rsPin value: oneOrZero.
	"only for 4bits interface"
	5 to: 8  do: [ :i | (dataPins at: (i - 4)) value: (aByte bitAt: i) ].
	self syncPulse.
	1 to: 4  do: [ :i | (dataPins at: i) value: (aByte bitAt: i) ].
	self syncPulse
]

{ #category : #writing }
PotsHD44780Device >> writeCharacter: aByte [
	self write: aByte mode: 1
]

{ #category : #writing }
PotsHD44780Device >> writeCommand: aByte [
	self write: aByte mode: 0
]
