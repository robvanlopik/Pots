Class {
	#name : 'PotsTMXDriverTest',
	#superclass : 'TestCase',
	#instVars : [
		'testTMX',
		'mockDriver',
		'p6',
		'p7',
		'p4',
		'p5'
	],
	#category : 'PharoThingsSimplified-Tests',
	#package : 'PharoThingsSimplified-Tests'
}

{ #category : 'running' }
PotsTMXDriverTest >> setUp [
	super setUp.
	
	"Put here a common initialization logic for tests"
	testTMX := PotsController new driver: (MockPotsTMXDriver onIP: 'aString' ).
	
	p4 := testTMX   pinWithId: 4. "pin D12"
	p5 := testTMX  pinWithId: 5. "pin10 "
	p6 := testTMX  pinWithId: 6. "D13"
	p7 := testTMX pinWithId: 7.  "D11"
	mockDriver := testTMX driver baseDriver
]

{ #category : 'tests' }
PotsTMXDriverTest >> testBeDigitalInput [
	self assert: [ p4 currentRole class short = 'DI' ].
	
	p4 beDigitalInput. "must not call driver"
	
	self verify: mockDriver
]

{ #category : 'as yet unclassified' }
PotsTMXDriverTest >> testBeDigitalOuput [
	self assert: [ p4 currentRole class short = 'DI' ].
	mockDriver on: #pin:mode: with: 2 with: 1.
	
	p4 beDigitalOutput. 
	
	self verify: mockDriver
	
]
