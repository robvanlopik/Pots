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
			package: 'PharoThings-RobsVersion';
			package: 'PharoThings-RobsVersion-tests'
			with: [ spec requires: #( 'PharoThings-RobsVersion' ) ] ]
]

{ #category : #'external projects' }
BaselineOfPots >> declareFirmataOn: spec [
	spec
		baseline: 'Firmata'
		with: [ spec repository: 'github://robvanlopik/Firmata:COMMITISH/' ]
]

{ #category : #'external projects' }
BaselineOfPots >> declarePiGPIOOn: spec [
	spec
		baseline: 'PiGPIO'
		with: [ spec repository: 'github://robvanlopik/PiGPIO:COMMITISH/src' ]
]

{ #category : #'external projects' }
BaselineOfPots >> declarePicodDriverOn: spec [

	spec
		baseline: 'PicodDriver'
		with: [ 
		spec repository: 'github://robvanlopik/picod-pharo:main' ]
]
