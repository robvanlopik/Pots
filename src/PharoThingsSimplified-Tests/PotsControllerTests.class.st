Class {
	#name : #PotsControllerTests,
	#superclass : #TestCase,
	#category : #'PharoThingsSimplified-Tests'
}

{ #category : #tests }
PotsControllerTests >> testParamater [
	| ctrl |
	ctrl := PotsController new driver: (PotsFakeDriver parameter: 'test').
	self assert: [ctrl driver parameter = 'test'].
	
]
