Class {
	#name : #BaselineOfPots,
	#superclass : #BaselineOf,
	#category : #BaselineOfPots
}

{ #category : #baseline }
BaselineOfPots >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		self
			declareFirmataOn: spec;
			declarePiGPIOOn: spec;
			declarePicodDriverOn: spec.

		spec
			package: 'PharoThings-RobsVersion'
			with: [ spec requires: #( 'Firmata' 'PiGPIO' 'PicodDriver' ) ];
			package: 'PharoThings-RobsVersion-tests'
			with: [ spec requires: #( 'PharoThings-RobsVersion' ) ] ]
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
