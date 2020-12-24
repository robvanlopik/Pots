Class {
	#name : #PotsPinTests,
	#superclass : #TestCase,
	#instVars : [
		'controller'
	],
	#category : #'PharoThings-RobsVersion-tests'
}

{ #category : #running }
PotsPinTests >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	super setUp.
	controller := PotsController new driver: (PotsFakeDriver parameter: 'test')
]

{ #category : #tests }
PotsPinTests >> testBeDigitalInput [
	| d1 |
	d1 := controller pinWithId: 1.
	d1 beDigitalInput.
	self assert: [ d1 currentRole class = PotsDigitalInputRole ].
	self should: [d1 beDigitalOutput] raise: Error.
	
	
]

{ #category : #tests }
PotsPinTests >> testBeDigitalOutput [
	| d1 d2 |
	d1 := controller pinWithId: 1.
	d2 := controller pinWithId: 2.
	self should: [ d1 beDigitalOutput ] raise: Error.
	d2 beDigitalOutput.
	self assert: [d2 currentRole class short = 'DO']
]

{ #category : #tests }
PotsPinTests >> testDriverParameter [
	self assert: [ controller driver parameter = 'test' ]
]

{ #category : #tests }
PotsPinTests >> testPin1Role [
	self assert: [ (controller pins at: 1) currentRole class = PotsDigitalInputRole ]
]

{ #category : #tests }
PotsPinTests >> testPin1roles [
	self assert: [(controller pinWithId: 1) roles size = 1]
]

{ #category : #tests }
PotsPinTests >> testPinroles [
	self assert: [(controller pinWithId: 1) roles size = 1].
	self assert: [(controller pinWithId: 2) roles size = 2].
	self assert: [(controller pinWithId: 3) roles size = 2].
	
]

{ #category : #tests }
PotsPinTests >> testPinsInitialState [
	"on startup there are for pins, all configured as input (like usual for a real device)"
	1 to: 4 do: [ :i | self assert: [(controller pins at: i) currentRole class short = 'DI'] ].
	1 to: 4 do: [ :i | self assert: [ (controller pins at: 1) deviceCount = 0 ] ].
	(controller pins at: 2) roles includesKey: 'DO'.
	(controller pins at: 3) roles includesKey: 'I2C'.
	(controller pins at: 4) roles includesKey: 'I2C'.
	
]

{ #category : #tests }
PotsPinTests >> testPinsNotNil [
	self deny: [ controller pins isNil ]
]
