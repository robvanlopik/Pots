Class {
	#name : 'PotsPinTests2',
	#superclass : 'TestCase',
	#instVars : [
		'controller',
		'p1',
		'p2',
		'p3',
		'p4'
	],
	#category : 'PharoThingsSimplified-Tests',
	#package : 'PharoThingsSimplified-Tests'
}

{ #category : 'running' }
PotsPinTests2 >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	super setUp.
	controller := PotsController new driver: (PotsFakeDriver parameter: 'test').
	p1 := controller pinWithId: 1.
	p2 := controller pinWithId: 2.
	p3 := controller pinWithId: 3.
	p4 := controller pinWithId: 4.
	
]

{ #category : 'tests' }
PotsPinTests2 >> testBeDigitalInput [
	| d1 |
	d1 := controller pinWithId: 1.
	d1 beDigitalInput.
	self assert: [ d1 currentRole class = PotsDigitalInputRole ].
	self should: [d1 beDigitalOutput] raise: Error.
	
	
]

{ #category : 'tests' }
PotsPinTests2 >> testBeDigitalOutput [
	| d1 d2 |
	d1 := controller pinWithId: 1.
	d2 := controller pinWithId: 2.
	"self should: [ d1 beDigitalOutput ] raise: Error."
	d2 beDigitalOutput.
	self assert: [d2 currentRole class short = 'DO']
]

{ #category : 'tests' }
PotsPinTests2 >> testDigitalIO [
	p1 beDigitalInput .
	p2 beDigitalOutput .
	p2 value: 1.
	self assert: [ p1 value  = 1].
	p2 value: 0.
	self assert: [ p1 value = 0 ].
	self assert: [ p2 lastValue = 0 ].
	p2 toggle.
	self assert: [ p1 value =  1].
	self assert: [ p1 lastValue = 1 ]
]

{ #category : 'tests' }
PotsPinTests2 >> testDriverParameter [
	self assert: [ controller driver parameter = 'test' ]
]

{ #category : 'tests' }
PotsPinTests2 >> testPin1Role [
	self assert: [ (controller pins at: 1) currentRole class = PotsDigitalInputRole ]
]

{ #category : 'tests' }
PotsPinTests2 >> testPin1roles [
	self assert: [(controller pinWithId: 1) roles size = 1]
]

{ #category : 'tests' }
PotsPinTests2 >> testPinroles [
	self assert: [(controller pinWithId: 1) roles size = 1].
	self assert: [(controller pinWithId: 2) roles size = 2].
	self assert: [(controller pinWithId: 3) roles size = 2].
	
]

{ #category : 'tests' }
PotsPinTests2 >> testPinsInitialState [
	"on startup there are four pins, all configured as input (like usual for a real device)"
	1 to: 4 do: [ :i | self assert: [(controller pins at: i) currentRole class short = 'DI'] ].
	1 to: 4 do: [ :i | self assert: [ (controller pins at: i) deviceCount = 0 ] ].
	(controller pins at: 2) roles includesKey: 'DO'.
	(controller pins at: 3) roles includesKey: 'I2C'.
	(controller pins at: 4) roles includesKey: 'I2C'.
	
]

{ #category : 'tests' }
PotsPinTests2 >> testPinsNotNil [
	self deny: [ controller pins isNil ]
]
