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
	pinDict := super providePinInfo.
	baseDriver pins ai do: [ :id | (pinDict at: id) addRole: (PotsAnalogInputRole new driver: self;
																				refVoltage: 3.4;
																				resolution: 12;
																				yourself)].
	baseDriver pins ao do: [  :id | (pinDict at: id) addRole: (PotsAnalogOutputRole new driver: self)].
		
																	
	^pinDict
]

{ #category : 'initialization' }
PotsTMXEsp32Driver >> setup [ baseDriver := TMXESP32Driver new connectOnIP: ip port: portNr
]
