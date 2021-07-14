"
I represent a simple three color LED

My color is set through PWM values for the three pins. These values are taken from the Color definition

creation:
lamp := PotsRGBLedDevice on: #(redpinId greenPinId, bluePinId)

usage: lamp color: Color lightBlue


"
Class {
	#name : #PotsRGBLedDevice,
	#superclass : #PotsDevice,
	#instVars : [
		'pinIds',
		'pinG',
		'pinB',
		'pinR'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #accessing }
PotsRGBLedDevice class >> pinIds: aList [
	^self basicNew pinId: aList
]

{ #category : #'as yet unclassified' }
PotsRGBLedDevice >> assignPins [
	pinR := controller pinWithId: (pinIds at: 1).
	pinG := controller pinWithId: (pinIds at: 2).
	pinB := controller pinWithId: (pinIds at: 3).
	"First check whether we are allowedd to use these pins"
	self assert: [ pinR deviceCount = 0 ] description: ((pinR id printString), ' is not available').
	self assert: [ pinG deviceCount = 0 ] description: ((pinG id printString), ' is not available').
	self assert: [ pinB deviceCount = 0 ] description: ((pinB id printString), ' is not available').
	
]

{ #category : #'as yet unclassified' }
PotsRGBLedDevice >> claimResources [
	self assignPins.
	pinR bePWMOutput deviceCount: 1.
	pinG bePWMOutput deviceCount: 1.
	pinB bePWMOutput deviceCount: 1.
]

{ #category : #accessing }
PotsRGBLedDevice >> color: aColor [
	pinR value: (aColor red * 100) rounded.
	pinG value: (aColor green * 100) rounded .
	pinB value: (aColor blue * 100) rounded.
]

{ #category : #controlling }
PotsRGBLedDevice >> connect [
	"nothing to do"
]

{ #category : #'as yet unclassified' }
PotsRGBLedDevice >> pinId: aList [
	pinIds := aList
]

{ #category : #'as yet unclassified' }
PotsRGBLedDevice >> releaseResources [
	pinR deviceCount: 0; beDigitalOutput.
	pinG deviceCount: 0; beDigitalOutput.
	pinG deviceCount: 0; beDigitalOutput.
]
