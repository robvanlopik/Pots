"
I represent an ADS1014 4-channel AD converter
I am controlled through the i2C bus
my default address = 16r48

Differential measurements are not (yet?) supported.
with #setChannel:scale
full scale of each channel can be set to 6.144, 4.096, 2.048, 1.024, 0.512 or 0.256 volt. 
You can also use 0 .. 5

A reading is taken with #readSingleChannel:
The result is in volts. Negative values are impossible. Overload is NOT detected, but suspected when the value reaches the full cale value.
"
Class {
	#name : 'PotsADS1015Device',
	#superclass : 'PotsI2CDevice',
	#instVars : [
		'baseCommand',
		'scaleFactors',
		'range'
	],
	#category : 'PharoThingsSimplified',
	#package : 'PharoThingsSimplified'
}

{ #category : 'instance creation' }
PotsADS1015Device class >> defaultI2CAddress [ 
	^16r48
]

{ #category : 'controlling' }
PotsADS1015Device >> connect [
	super connect.
		self initIvars
]

{ #category : 'initialization' }
PotsADS1015Device >> initIvars [
	range := #(2 2 2 2). "default scale +/- 2.048V "
	scaleFactors := #(6144 4096 2048 1024 512 256).
	baseCommand := 2r1000000110000011.
	"bits
	1  =initiate conversion
	000 space for channel nr
	010 gain 2 2.048V
	1 single conversion
	100 default converson rate of 1600 samples per second
	0 comparator mode
	0 comparator polarity
	0 latchng
	11 disable alert/ready
	"
]

{ #category : 'as yet unclassified' }
PotsADS1015Device >> rangeForChannel: channelNumber [
	"return the full scal range for a channel, 
	taking care of the fact that channels are numbered for 0 to 3"
	^scaleFactors at: ((range at: (channelNumber + 1)) + 1)
]

{ #category : 'as yet unclassified' }
PotsADS1015Device >> rawFromChannel: channelNumber [
	"execute a single read and return result"	
	| command |
	command := baseCommand bitOr: ((range at: (channelNumber + 1)) << 9).
	command := command bitOr: ((channelNumber + 4) << 12).
	
	i2cConnection writeWordBigEndianAt: 1 data: command.
	2 milliSeconds wait. "(should be 1000/1600 + 1)"
	^ (i2cConnection readWordBigEndianAt: 0) >> 4.
]

{ #category : 'reading' }
PotsADS1015Device >> readSingleChannel: channelNumber [
	"execute a single read and return result"	
	|  raw scaleFactor |
	raw := self rawFromChannel: channelNumber.
	
	(raw bitAt: 12) = 1 ifTrue: [ ^0 ]. "negative result is impossible"
	scaleFactor := 0.001 * (self rangeForChannel: channelNumber) / 2048.
	^ raw * scaleFactor
]

{ #category : 'controlling' }
PotsADS1015Device >> setChannel: aChannel scale: aValue [
	"set the scale factor fo a single-eded channel (0..3) 
	It can be set by an index (0..5) or the actual full-scale value 
	(6144, 4096, 2048, 1024, 512,256)"
	| scaleValue |

	(aValue abs <6) ifTrue: [ range at: (aChannel + 1) put: aValue abs. ^self].
	scaleValue := (scaleFactors indexOf: aValue ifAbsent: [ 3 ]) - 1.
	range at: (aChannel + 1) put: scaleValue.
]
