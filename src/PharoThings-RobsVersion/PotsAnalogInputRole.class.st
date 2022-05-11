"
I represent an analog input and translate the #value method of the pin to a driver command.
I return a value in volts using the value of refVoltage and resolution. These are prese by the driver but can be overridden
 
Internal Representation and Key Implementation Points.

    Instance Variables
	refVoltage:		reference voltage of the AD converter
	resolution:		number of bits


    Implementation Points
"
Class {
	#name : #PotsAnalogInputRole,
	#superclass : #PotsSoloPinRole,
	#instVars : [
		'resolution',
		'refVoltage'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'accessing structure variables' }
PotsAnalogInputRole class >> short [ 
	^'AI'
]

{ #category : #'private - controlling' }
PotsAnalogInputRole >> activateOn: aPin [
	"driver beAnalogInputOnPin: aPin"
]

{ #category : #'private - controlling' }
PotsAnalogInputRole >> disableReportingOnPin: aPin [
	"forr the time being only for Firmata; but ther drivers have no AI role"
	driver disableAnalogReportingOnPin: aPin
]

{ #category : #'private - controlling' }
PotsAnalogInputRole >> enableReportingOnPin: aPin [

	"forr the time being only for Firmata; but their drivers have no AI role"

	driver enableAnalogReportingOnPin: aPin
]

{ #category : #'private - accessing' }
PotsAnalogInputRole >> rawValueFromPin: aPin [
	^driver rawAnalogValueFromPin: aPin
]

{ #category : #parameters }
PotsAnalogInputRole >> refVoltage [
	^ refVoltage
]

{ #category : #parameters }
PotsAnalogInputRole >> refVoltage: anObject [
	refVoltage := anObject
]

{ #category : #parameters }
PotsAnalogInputRole >> resolution [
	^ resolution
]

{ #category : #parameters }
PotsAnalogInputRole >> resolution: anObject [
	resolution := anObject
]

{ #category : #'private - accessing' }
PotsAnalogInputRole >> valueForPin: aPin [
	^driver analogValueFromPin: aPin
]

{ #category : #'private - accessing' }
PotsAnalogInputRole >> valueFromPin: aPin [
	^driver analogValueFromPin: aPin
]
