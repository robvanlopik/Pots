Class {
	#name : 'PotsPiGPIODriverTest',
	#superclass : 'TestCase',
	#instVars : [
		'testPi',
		'mockDriver',
		'p2',
		'p3',
		'p4',
		'p5'
	],
	#category : 'PharoThingsSimplified-Tests',
	#package : 'PharoThingsSimplified-Tests'
}

{ #category : 'running' }
PotsPiGPIODriverTest >> setUp [
	super setUp.
	
	"First setup the test envirenment with diverse pins"
	testPi := PotsController new driver: (MockPotsPiGPIODriver onIP: 'test' port: 1234 ).
	
	p2 := testPi  pinWithId: 2.
	p3 := testPi  pinWithId: 3.
	p4 := testPi  pinWithId: 4.
	p5 := testPi pinWithId: 5.
	
	mockDriver := testPi driver baseDriver
	
]

{ #category : 'tests' }
PotsPiGPIODriverTest >> testBeDigitalInput [
	self assert: [ p2 currentRole class short = 'DI' ].
	
	p2 beDigitalInput. "must not call driver"
	
	self verify: mockDriver
	
]

{ #category : 'tests' }
PotsPiGPIODriverTest >> testBeDigitalOuput [
	self assert: [ p2 currentRole class short = 'DI' ].
	mockDriver on: #pin:mode: with: 2 with: 1.
	
	p2 beDigitalOutput. 
	
	self verify: mockDriver
	
]

{ #category : 'tests' }
PotsPiGPIODriverTest >> testBeServoOutput [
	self assert: [ p3 currentRole class short = 'DI' ].
	"mockDriver on: #pin:servoPulsewidth: with: 3 with: 0." "cleanup PWM"
	mockDriver on: #pin:mode: with: 3 with: 0.
	p3 beServoOutput.
	p3 beDigitalInput.
	
	self verify: mockDriver
	
]

{ #category : 'tests' }
PotsPiGPIODriverTest >> testDigitalValueFromPin [
	self assert: [ p3 currentRole class short = 'DI' ].
	mockDriver on: #digitalRead: with: 3 respond: 1.
	
	self assert: [p3 value = 1]. 

	self verify: mockDriver
	
]

{ #category : 'tests' }
PotsPiGPIODriverTest >> testDigitalValueIntoPin [
	self assert: [ p3 currentRole class short = 'DI' ].
	mockDriver on: #pin:mode: with: 3 with: 1.
	mockDriver on: #digitalWrite:value: with: 3 with: 1.
	
	p3 beDigitalOutput.
	p3 value: 1.
	self assert: [ p3 lastValue = 1 ].
	
	self verify: mockDriver
	
]

{ #category : 'tests' }
PotsPiGPIODriverTest >> testPwmValueIntoPin [
	mockDriver on: #pin:pwmWrite: with: 3 with: 128.
	
	p3 bePWMOutput .
	p3 value: 50.
	
	self verify: mockDriver
	
]

{ #category : 'tests' }
PotsPiGPIODriverTest >> testRawPwmValueIntoPin [
	mockDriver on: #pin:pwmWrite: with: 3 with: 123.
	
	p3 bePWMOutput .
	p3 rawValue: 123.
	
	self verify: mockDriver
	
]

{ #category : 'tests' }
PotsPiGPIODriverTest >> testServoValueSet [
	mockDriver on: #pin:servoPulsewidth: with: 3 with: 1500.
	
	p3 beServoOutput .
	p3 value: 90.
	self assert: [ p3 lastValue = 90 ].
	
	self verify: mockDriver
	
]
