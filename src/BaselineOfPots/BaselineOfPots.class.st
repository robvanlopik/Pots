Class {
	#name : #BaselineOfPots,
	#superclass : #BaselineOf,
	#category : #BaselineOfPots
}

{ #category : #baselines }
BaselineOfPots >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		self
			declareFirmataOn: spec;
			declarePiGPIOOn: spec;
			declarePicodDriverOn: spec;
			declareESP32DriverOn: spec.
		spec
			package: 'PharoThings-RobsVersion'
			with: [ spec requires: #( 'Firmata' 'PiGPIO' 'PicodDriver' 'ESP32Driver' ) ];
			package: 'PharoThingsSimplified-Tests'
			with: [ spec requires: #( 'PharoThings-RobsVersion' ) ] ]
]

{ #category : #'external projects' }
BaselineOfPots >> declareESP32DriverOn: spec [

	spec
		baseline: 'ESP32Drver'
		with: [ 
		spec repository: 'github://robvanlopik/toit-pharo:main' ]
]

{ #category : #'external projects' }
BaselineOfPots >> declareFirmataOn: spec [

	spec
		baseline: 'Firmata'
		with: [ spec repository: 'github://robvanlopik/Firmata' ]
]

{ #category : #'external projects' }
BaselineOfPots >> declarePiGPIOOn: spec [

	spec
		baseline: 'PiGPIO'
		with: [ 
		spec repository: 'github://robvanlopik/PiGPIO' ]
]

{ #category : #'external projects' }
BaselineOfPots >> declarePicodDriverOn: spec [

	spec
		baseline: 'PicodDriver'
		with: [ 
		spec repository: 'github://robvanlopik/picod-pharo:main' ]
]
