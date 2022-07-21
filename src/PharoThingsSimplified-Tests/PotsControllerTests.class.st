Class {
	#name : #PotsControllerTests,
	#superclass : #TestCase,
	#category : #'PharoThingsSimplified-Tests'
}

{ #category : #tests }
PotsControllerTests >> testParameter [
	| ctrl |
	ctrl := PotsController new driver: (PotsFakeDriver parameter: 'test').
	self assert: [ctrl driver parameter = 'test'].
	
]
