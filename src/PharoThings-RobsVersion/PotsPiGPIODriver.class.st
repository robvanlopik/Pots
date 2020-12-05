Class {
	#name : #PotsPiGPIODriver,
	#superclass : #PotsDriver,
	#instVars : [
		'ip',
		'port'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'instance creation' }
PotsPiGPIODriver class >> onIP: anIpAddressString port: aPortNumber [
	^self new 
		onIP: anIpAddressString port: aPortNumber;
		yourself
]

{ #category : #accessing }
PotsPiGPIODriver >> ip [
	^ ip
]

{ #category : #accessing }
PotsPiGPIODriver >> ip: anObject [
	ip := anObject
]

{ #category : #'instance creation' }
PotsPiGPIODriver >> onIP: anIpAddressString port: aPortNumber [
	"save to later connect"
	ip := anIpAddressString .
	port := aPortNumber .
]

{ #category : #accessing }
PotsPiGPIODriver >> port [
	^ port
]

{ #category : #accessing }
PotsPiGPIODriver >> port: anObject [
	port := anObject
]

{ #category : #'as yet unclassified' }
PotsPiGPIODriver >> startBaseDriver [ 
	"start the PiGPIO driver with its parameters"
	"Note: we might want to do some error checking at this point"
	baseDriver := PiGPIO onIP: ip port: port
]
