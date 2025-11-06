Class {
	#name : 'MockPotsTMXDriver',
	#superclass : 'PotsTMXDriver',
	#category : 'PharoThingsSimplified-Tests',
	#package : 'PharoThingsSimplified-Tests'
}

{ #category : 'initialization' }
MockPotsTMXDriver >> setup [ 
	baseDriver := MockObject new
]
