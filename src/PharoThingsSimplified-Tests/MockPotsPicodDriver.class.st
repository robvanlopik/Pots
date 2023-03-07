"
I function like a PotsPicodDriver, but my communication with the PicodDriver has been replace by a MockObject.
#getPinInfo is borrowed from the real PostPicodDriver
"
Class {
	#name : #MockPotsPicodDriver,
	#superclass : #PotsPicodDriver,
	#category : #'PharoThingsSimplified-Tests'
}

{ #category : #initialization }
MockPotsPicodDriver >> setup [ 
	baseDriver := MockObject new
]
