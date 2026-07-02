"
I represent an DHT11 connected to an TMX driven microprocessor
"
Class {
	#name : 'PotsTMXDHT11Device',
	#superclass : 'PotsNativeDevice',
	#instVars : [
		'pinId'
	],
	#category : 'PharoThingsSimplified',
	#package : 'PharoThingsSimplified'
}

{ #category : 'initialization' }
PotsTMXDHT11Device >> claimResources [
	| myPin |
	
	((controller pinWithId: pinId) deviceCount = 0) ifFalse: [  self error: 'pin not available'. ^self ].
	(controller pinWithId: pinId) deviceCount: 1
]

{ #category : 'controlling' }
PotsTMXDHT11Device >> connect [

	controller driver baseDriver beDHT11OnPin: pinId
]

{ #category : 'accessing' }
PotsTMXDHT11Device >> humidity [
	
	^controller driver baseDriver humidityFromDHTPin: pinId
]

{ #category : 'accessing' }
PotsTMXDHT11Device >> temperature [ 
	
	^controller driver baseDriver temperatureFromDHTPin: pinId
]

{ #category : 'as yet unclassified' }
PotsTMXDHT11Device >> withPinId: aPinNr [

	"((controller pinWithId: aPinNr) deviceCount = 0) ifFalse: [  self inform: 'pin not available'. ^self ].
	to early, controller is not known yet!!"
	pinId := aPinNr
]
