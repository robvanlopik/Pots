"
I control a physical device on an I2C bus. For that I use the I2CConnection class that is available in all baseDrivers.

Instance variables:
- i2cConnection  -  the I2CConnection with the baseDriver
- i2cAddress  -  the bus address pf the device, supplied before installing
"
Class {
	#name : #PotsI2CDevice,
	#superclass : #PotsDevice,
	#instVars : [
		'i2cConnection',
		'i2cAddress'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'instance creation' }
PotsI2CDevice class >> defaultI2CAddress [ 
	self subclassResponsibility 
]

{ #category : #'instance creation' }
PotsI2CDevice class >> new [
	^self basicNew
		i2cAddress: self defaultI2CAddress 
]

{ #category : #'instance creation' }
PotsI2CDevice class >> on: i2cAddress [
	^super new
		i2cAddress: i2cAddress 
]

{ #category : #'as yet unclassified' }
PotsI2CDevice >> claimResources [

	| pins |
	pins := controller driver i2cPins.
	"first check whether we already have an I2C connection in 
	which case we only bump the device count"
	"we only check the first pin"
	(pins at: 1) currentRole class short = 'I2C' ifTrue: [ 
		pins do: [ :aPin | aPin incrementDeviceCount ].
		^ self ].
	"when we are the first, we have to claim the pins
	first check wether they are free"
	pins do: [ :aPin | 
		self
			assert: [ aPin deviceCount = 0 ]
			description: 'pin ' , aPin id asString , 'is not free for I2C' ].
	"and set the role"
	pins do: [ :aPin | 
		aPin currentRole: (aPin roles at: 'I2C').
		aPin deviceCount: 1 ]
]

{ #category : #controlling }
PotsI2CDevice >> connect [ 
	i2cConnection := controller connectToI2CDevice: i2cAddress
]

{ #category : #controlling }
PotsI2CDevice >> disconnect [
	i2cConnection close.
	self releaseResources 
]

{ #category : #accessing }
PotsI2CDevice >> i2cAddress [
	^i2cAddress
]

{ #category : #accessing }
PotsI2CDevice >> i2cAddress: anI2CAddress [
	i2cAddress := anI2CAddress 
]

{ #category : #'as yet unclassified' }
PotsI2CDevice >> i2cConnection [
	^i2cConnection 
]

{ #category : #testing }
PotsI2CDevice >> isConnected [ 
	^i2cConnection notNil
]

{ #category : #'as yet unclassified' }
PotsI2CDevice >> releaseResources [
	| pins |
	pins := controller driver i2cPins.
	pins do: [ :aPin | aPin decrementDeviceCount  ].
	(((pins at: 1) deviceCount) > 0) ifTrue: [ ^self ].
	"if this was the last I2C device, we have to really release the pins."
	"or maybe not, because the device ount has dropped to zero"
]
