"
I represent the Sonar rangefinder supported by the Telemtrix Drivers drivers
I need two pins, pulsePinId and signalPniId
"
Class {
	#name : 'PotsTMXSonarDevice',
	#superclass : 'PotsNativeDevice',
	#instVars : [
		'pulsePinId',
		'signalPinId'
	],
	#category : 'PharoThingsSimplified',
	#package : 'PharoThingsSimplified'
}

{ #category : 'initialization' }
PotsTMXSonarDevice >> claimResources [
	| myPin |
	"may want tocheck whether the base driver supports the use of this pin"
	((controller pinWithId: pulsePinId) deviceCount = 0) ifFalse: [  self error: 'pin not available'. ^self ].
	(controller pinWithId: pulsePinId ) deviceCount: 1.
	((controller pinWithId: signalPinId) deviceCount = 0) ifFalse: [  self error: 'pin not available'. ^self ].
	(controller pinWithId: signalPinId ) deviceCount: 1
]

{ #category : 'controlling' }
PotsTMXSonarDevice >> connect [

	controller driver baseDriver beSonarWithTrigger: pulsePinId echo: signalPinId
]

{ #category : 'accessing' }
PotsTMXSonarDevice >> distance [ 

	^controller driver baseDriver distanceFronPin: pulsePinId
]

{ #category : 'as yet unclassified' }
PotsTMXSonarDevice >> withPulsePin: pinNr1 signalPin: pinNr2 [

	signalPinId := pinNr2.
	pulsePinId := pinNr1
]
