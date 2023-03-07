Class {
	#name : #PotsPicodDriverTest,
	#superclass : #TestCase,
	#instVars : [
		'testPico',
		'mockDriver',
		'p2',
		'p3',
		'p4',
		'p5'
	],
	#category : #'PharoThingsSimplified-Tests'
}

{ #category : #running }
PotsPicodDriverTest >> setUp [
	super setUp.
	
	"Put here a common initialization logic for tests"
	testPico := PotsController new driver: (MockPotsPicodDriver onPort: 'aString' ).
	
	p2 := testPico   pinWithId: 2.
	p3 := testPico  pinWithId: 3.
	p4 := testPico  pinWithId: 4.
	p5 := testPico pinWithId: 5.
	
	mockDriver := testPico driver baseDriver
]

{ #category : #tests }
PotsPicodDriverTest >> testBeDigitalInput [
	self assert: [ p2 currentRole class short = 'DI' ].
	
	p2 beDigitalInput. "must not call driver"
	
	self verify: mockDriver
]

{ #category : #tests }
PotsPicodDriverTest >> testBeDigitalOuput [
	self assert: [ p2 currentRole class short = 'DI' ].
	mockDriver on: #closeGpio: with: 2.
	mockDriver on: #setGpioOutput:value: with: 2 with: 0.
	
	p2 beDigitalOutput. 
	
	self verify: mockDriver
	
]

{ #category : #tests }
PotsPicodDriverTest >> testBePWMOutput [
	self assert: [ p2 currentRole class short = 'DI' ].
	mockDriver on: #closeGpio: with: 2.
	
	
	p2 bePWMOutput. 
	
	self verify: mockDriver
	
]

{ #category : #tests }
PotsPicodDriverTest >> testPWMtoDO [
	self assert: [ p2 currentRole class short = 'DI' ].
	mockDriver on: #closeGpio: with: 2.
	mockDriver on: #servoPwmClose: with: 2.
	mockDriver on: #setGpioOutput:value: with: 2 with: 0.
	
	
	p2 bePWMOutput. 
	p2 beDigitalOutput.
	
	self verify: mockDriver
	
]
