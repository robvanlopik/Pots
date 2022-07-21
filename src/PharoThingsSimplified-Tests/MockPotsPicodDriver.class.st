"
I function like a PotsPicodDriver, but my communication with the PicodDriver has been replace by a MockObject
"
Class {
	#name : #MockPotsPicodDriver,
	#superclass : #PotsPicodDriver,
	#category : #'PharoThingsSimplified-Tests'
}

{ #category : #initialization }
MockPotsPicodDriver >> startBaseDriver [ 
	baseDriver := MockObject new
]
