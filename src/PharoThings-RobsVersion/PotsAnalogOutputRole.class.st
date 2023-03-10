Class {
	#name : #PotsAnalogOutputRole,
	#superclass : #PotsSoloPinRole,
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'private - controlling' }
PotsAnalogOutputRole >> activateOn: aPin [
	driver beAnalogOutputOnPin: aPin
		
]
