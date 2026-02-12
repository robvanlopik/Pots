"
I represent (real) analog output with a DAC, not PWM
"
Class {
	#name : 'PotsAnalogOutputRole',
	#superclass : 'PotsSoloPinRole',
	#category : 'PharoThingsSimplified',
	#package : 'PharoThingsSimplified'
}

{ #category : 'accessing structure variables' }
PotsAnalogOutputRole class >> short [
	^'AO'
]

{ #category : 'private - controlling' }
PotsAnalogOutputRole >> activateOn: aPin [
	driver beAnalogOutputOnPin: aPin
		
]

{ #category : 'private - controlling' }
PotsAnalogOutputRole >> deactivateOn: aPin [

	driver closeAnalogOutputOnPin: aPin
]

{ #category : 'private - accessing' }
PotsAnalogOutputRole >> value: anAnalogValue forPin: aPin [
	driver analogValue: anAnalogValue  intoPin: aPin.
	lastValue := anAnalogValue
]
