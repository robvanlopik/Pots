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

{ #category : #'private-mode' }
PotsFirmataDriver >> beDigitalInputOnPin: aPin [
	baseDriver pin: aPin id mode: FirmataConstants pinModeInput
]

{ #category : #'private-mode' }
PotsFirmataDriver >> beDigitalOutputOnPin: aPin [
	baseDriver pin: aPin id mode: FirmataConstants pinModeOutput
]

{ #category : #'private-mode' }
PotsFirmataDriver >> bePWMOutputOnPin: aPin [
	baseDriver pin: aPin id mode: FirmataConstants pinModePwm
]

{ #category : #'private-mode' }
PotsFirmataDriver >> beServoOutputOnPin: aPin [
	baseDriver pin: aPin id mode: FirmataConstants pinModeServo
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

{ #category : #initialization }
PotsFirmataDriver >> providePinInfo [
	"This is called after the basedriver is connected; we return a dictionary with allpins, their current role and their available roles; also fill in the alternative id that is used for analog inputs"
	| pinDict |
	pinDict := Dictionary new.
	




	^pinDict
]

{ #category : #'as yet unclassified' }
PotsFirmataDriver >> startBaseDriver [ 
	"start the Firmata driver and save it"
	"Note: probably we should do some error handling !!!"
	baseDriver := Firmata onPort: port baudRate: baudRate .
]
