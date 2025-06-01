Class {
	#name : 'PotsAnalogOutputRole',
	#superclass : 'PotsSoloPinRole',
	#category : 'PharoThings-RobsVersion',
	#package : 'PharoThings-RobsVersion'
}

{ #category : 'accessing structure variables' }
PotsAnalogOutputRole class >> short [
	^'AO'
]

{ #category : 'private - controlling' }
PotsAnalogOutputRole >> activateOn: aPin [
	driver beAnalogOutputOnPin: aPin
		
]

{ #category : 'private - accessing' }
PotsAnalogOutputRole >> value: anAnalogValue forPin: aPin [
	driver analogValue: anAnalogValue  intoPin: aPin.
	lastValue := anAnalogValue
]
