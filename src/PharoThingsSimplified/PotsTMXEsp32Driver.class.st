Class {
	#name : 'PotsTMXEsp32Driver',
	#superclass : 'PotsTMXDriver',
	#instVars : [
		'portNr',
		'ip'
	],
	#category : 'PharoThingsSimplified-tests',
	#package : 'PharoThingsSimplified',
	#tag : 'tests'
}

{ #category : 'initialization' }
PotsTMXEsp32Driver >> providePinInfo [
	"TMX has no idea of pin mode at startup. Maybe NARole is useful here"
	
	| pinDict |
	pinDict := Dictionary new.
	
]

{ #category : 'initialization' }
PotsTMXEsp32Driver >> setup [ baseDriver := TMXESP32Driver new connectOnIP: ip port: portNr
]
