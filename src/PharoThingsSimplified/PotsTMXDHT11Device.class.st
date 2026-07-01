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

{ #category : 'as yet unclassified' }
PotsTMXDHT11Device >> withPinId: aPinNr [

	pinId := aPinNr
]
