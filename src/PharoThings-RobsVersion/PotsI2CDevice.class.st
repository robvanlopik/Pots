Class {
	#name : #PotsI2CDevice,
	#superclass : #PotsDevice,
	#instVars : [
		'i2cConnection',
		'i2cAddress'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #controlling }
PotsI2CDevice >> connect [ 
	i2cConnection := controller connectToI2CDevice: i2cAddress
]

{ #category : #controlling }
PotsI2CDevice >> disconnect [
	i2cConnection close
]

{ #category : #accessing }
PotsI2CDevice >> i2cAddress [
	^i2cAddress
]

{ #category : #accessing }
PotsI2CDevice >> i2cAddress: anI2CAddress [
	i2cAddress := anI2CAddress 
]

{ #category : #testing }
PotsI2CDevice >> isConnected [ 
	^i2cConnection notNil
]
