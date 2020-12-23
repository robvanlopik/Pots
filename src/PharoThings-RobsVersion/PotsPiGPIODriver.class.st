"
I am a PotsDriver that uses the PiGPIO driver to communicate with a Raspberry Pi.
To start with I only serve modern Pi's.
I support DI, DO, PWM, Servo and I2C
I2C is standard on BCM pin numbers 2 and 3

I use the PiGPIOd daemon, that first has to be started on the Pi with:
`sudo pigpiod`

You create a new instance by providing the IP-address of the Pi (or 127.0.0.1 for the local Pi) and the port number (default 8888).

after starting the controller will ask for the pin information
"
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

{ #category : #initialization }
PotsPiGPIODriver >> providePinInfo [
	"return a dict of pins to the caller, with their poperties"
	| pinDict roles |
	roles := OrderedCollection new.
	roles add: PotsDigitalInputRole new  ;
		add: PotsDigitalOutputRole new;
		add: PotsPWMRole new;
		add: PotsServoRole new.
		
	pinDict := Dictionary new.
	2 to: 27 do:
		[ :pinId | pinDict at: pinId put: 
			(PotsActivePin new 
			id: pinId;
			currentRole: PotsDigitalInputRole new;
			driver: self
			)
		].
	
	^pinDict
]

{ #category : #'as yet unclassified' }
PotsPiGPIODriver >> startBaseDriver [ 
	"start the PiGPIO driver with its parameters"
	"Note: we might want to do some error checking at this point"
	"baseDriver := PiGPIO onIP: ip port: port"
]
