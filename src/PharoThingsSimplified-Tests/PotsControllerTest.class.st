Class {
	#name : 'PotsControllerTest',
	#superclass : 'TestCase',
	#category : 'PharoThingsSimplified-Tests',
	#package : 'PharoThingsSimplified-Tests'
}

{ #category : 'tests' }
PotsControllerTest >> testParameter [
	| ctrl |
	ctrl := PotsController new driver: (PotsFakeDriver parameter: 'test').
	self assert: [ctrl driver parameter = 'test']
]
