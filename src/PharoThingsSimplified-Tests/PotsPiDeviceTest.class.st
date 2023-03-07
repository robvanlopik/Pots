Class {
	#name : #PotsPiDeviceTest,
	#superclass : #TestCase,
	#instVars : [
		'testPi',
		'mockDriver',
		'p2',
		'p3',
		'p4',
		'p5'
	],
	#category : #'PharoThingsSimplified-Tests'
}

{ #category : #running }
PotsPiDeviceTest >> setUp [
	super setUp.
	
	"First setup the test envirenment with diverse pins"
	testPi := PotsController new driver: (MockPotsPiGPIODriver onIP: 'test' port: 1234 ).
	
	p2 := testPi  pinWithId: 2.
	p3 := testPi  pinWithId: 3.
	p4 := testPi  pinWithId: 4.
	p5 := testPi pinWithId: 5.
	mockDriver := testPi driver baseDriver
]

{ #category : #tests }
PotsPiDeviceTest >> testRGBLed [
	"Strictly speaking this not a unit test, because we exercise the full chain of creating a (simple) device and using it"
	| led |
	mockDriver on: #pin:pwmWrite: with: 2 with: 255.
	mockDriver on: #pin:pwmWrite: with: 3 with: 0.
	mockDriver on: #pin:pwmWrite: with: 4 with: 0.
	
	led := testPi installDevice: (PotsRGBLedDevice pinIds: #(2 3 4)).
	self assert: [p2 currentRole class short = 'PWM'].
	led color: Color red.
	self assert: [ p2 lastValue = 100 ].
	self assert: [ p3 lastValue = 0 ].
	self assert: [ p2 deviceCount = 1 ].
	
	self verify: mockDriver.
	
	
	
]
