Class {
	#name : #PotsPinTest,
	#superclass : #TestCase,
	#instVars : [
		'controller',
		'p1',
		'p2',
		'p3',
		'p4',
		'p5'
	],
	#category : #'PharoThingsSimplified-Tests'
}

{ #category : #running }
PotsPinTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	super setUp.
	controller := PotsController new driver: (PotsFakeDriver parameter: 'test').
	p1 := controller pinWithId: 1.
	p2 := controller pinWithId: 2.
	p3 := controller pinWithId: 3.
	p4 := controller pinWithId: 4.
	p5 := controller pinWithId: 5.
	
]

{ #category : #tests }
PotsPinTest >> testBeDigitalInput [
	| d1 |
	d1 := controller pinWithId: 1.
	d1 beDigitalInput.
	self assert: [ d1 currentRole class = PotsDigitalInputRole ].
	self should: [d1 beDigitalOutput] raise: Error.
	
	
]

{ #category : #tests }
PotsPinTest >> testBeDigitalOutput [
	| d1 d2 |
	d1 := controller pinWithId: 1.
	d2 := controller pinWithId: 2.
	self should: [ d1 beDigitalOutput ] raise: Error.
	d2 beDigitalOutput.
	self assert: [d2 currentRole class short = 'DO']
]

{ #category : #tests }
PotsPinTest >> testBePWMOutput [
		self should: [p1 bePWMOutput] raise: PotsError.
		p5 bePWMOutput.
	self assert: [p5 currentRole class short = 'PWM'].
		self assert: [p5 currentRole range = 255]
]

{ #category : #tests }
PotsPinTest >> testDigitalIO [
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

{ #category : #tests }
PotsPinTest >> testDriverParameter [
	self assert: [ controller driver parameter = 'test' ]
]

{ #category : #tests }
PotsPinTest >> testPWMWrite [
self skip.
	p5 bePWMOutput.
	self assert: [ p5 currentRole range = 255 ].
	p5 value: 50.
	self assert: [p5 lastValue = 50]
]

{ #category : #tests }
PotsPinTest >> testPin1Role [
	self assert: [ (controller pins at: 1) currentRole class = PotsDigitalInputRole ]
]

{ #category : #tests }
PotsPinTest >> testPin1roles [
	self assert: [(controller pinWithId: 1) roles size = 1]
]

{ #category : #tests }
PotsPinTest >> testPinroles [
	self assert: [(controller pinWithId: 1) roles size = 1].
	self assert: [(controller pinWithId: 2) roles size = 2].
	self assert: [(controller pinWithId: 3) roles size = 2].
	
]

{ #category : #tests }
PotsPinTest >> testPinsInitialState [
	"on startup there are four pins, all configured as input (like usual for a real device)"
	1 to: 4 do: [ :i | self assert: [(controller pins at: i) currentRole class short = 'DI'] ].
	1 to: 4 do: [ :i | self assert: [ (controller pins at: i) deviceCount = 0 ] ].
	(controller pins at: 2) roles includesKey: 'DO'.
	(controller pins at: 3) roles includesKey: 'I2C'.
	(controller pins at: 4) roles includesKey: 'I2C'.
	
]

{ #category : #tests }
PotsPinTest >> testPinsNotNil [
	self deny: [ controller pins isNil ]
]
