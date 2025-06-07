"
I am the intermediate driver between a PotsController and a specific device driver (like Firmata, PiGPIO and Picod).

When a controller is created. my first task is to provide it with all necessary information about the pins on the actual device, like id's and capabilities (possible roles}.

After that I accept commands from the different roles a pin can play and translate these into baseDriver instructions.

Subclasses should implement #baseDriver: , they can also provide a #reset that does something meaningful
"
Class {
	#name : 'PotsDriverDriver',
	#superclass : 'PotsDriver',
	#instVars : [
		'baseDriver'
	],
	#category : 'PharoThings-RobsVersion',
	#package : 'PharoThings-RobsVersion'
}

{ #category : 'accessing' }
PotsDriverDriver >> baseDriver [
	^baseDriver
]

{ #category : 'private - accessing' }
PotsDriverDriver >> baseDriver: aDriver [
	"only to be used for testing; noormally the baseDriver is set by #startBaseDriver"
	baseDriver := aDriver
]

{ #category : 'initialization' }
PotsDriverDriver >> reset [ 
	"we suppose the basDriver knows how to reset, otherwise the subclass must provide a solution"
	baseDriver reset
]
