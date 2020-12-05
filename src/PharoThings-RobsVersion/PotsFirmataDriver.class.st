Class {
	#name : #PotsFirmataDriver,
	#superclass : #PotsDriver,
	#instVars : [
		'port',
		'baudRate'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'instance creation' }
PotsFirmataDriver class >> onPort: aSerialPortName baudRate: aNumber [
		"create new instance"
		self new 
			onPort: aSerialPortName baudRate: aNumber;
			yourself
			
]

{ #category : #accessing }
PotsFirmataDriver >> baudRate [
	^ baudRate
]

{ #category : #accessing }
PotsFirmataDriver >> baudRate: anObject [
	baudRate := anObject
]

{ #category : #'instance creation' }
PotsFirmataDriver >> onPort: aSerialPortName baudRate: aNumber [
	"just save the datato make a connection later"
	port := aSerialPortName.
	baudRate := aNumber
]

{ #category : #accessing }
PotsFirmataDriver >> port [
	^ port
]

{ #category : #accessing }
PotsFirmataDriver >> port: anObject [
	port := anObject
]

{ #category : #'as yet unclassified' }
PotsFirmataDriver >> startBaseDriver [ 
	"start the Firmata driver and save it"
	"Note: probably we should do some error handling !!!"
	baseDriver := Firmata onPort: port baudRate: baudRate .
]
