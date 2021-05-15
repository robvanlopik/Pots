"
I represent an ADS1014 4-channel AD converter
I am controlled through the i2C bus
my default address = 16r48
"
Class {
	#name : #PotsADS1015Device,
	#superclass : #PotsI2CDevice,
	#instVars : [
		'baseCommand',
		'scaleFactors',
		'range'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'instance creation' }
PotsADS1015Device class >> defaultI2CAddress [ 
	^16r48
]

{ #category : #controlling }
PotsADS1015Device >> connect [
	super connect.
		self initIvars
]

{ #category : #'as yet unclassified' }
PotsADS1015Device >> initIvars [
	range := #(2 2 2 2). "default scale +/- 2.048V "
	scaleFactors := #(6144 4096 2048 1024 512 256).
	baseCommand := 2r1000010110000011.
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

{ #category : #'as yet unclassified' }
PotsADS1015Device >> readSingleChannel: channelNumber [
	"execute a single read and return result"	
	| command |
	command := baseCommand bitOr: (range at: (channelNumber + 1)).
	command := command bitOr: ((channelNumber + 4) bitShift: 12).
	
	i2cConnection writeWordBigEndianAt: 1 data: command.
	2 milliSeconds wait. "(should be 1000/1600 + 1)"
	^i2cConnection readWordBigEndianAt: 0
]
