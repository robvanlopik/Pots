"
I provide a controller with the means to control i/o pins belonging to a PotsDevice.
I expose the pins with their roles and provide the uniform encapsulation of pin commands like value and value: 

Usage:
extendedController := PotsController new driver: aPotsDeviceDriver

important methods: 

- providePinInfo

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	baseDevice:		a functioning instance of a PotsDevice


    Implementation Points
"
Class {
	#name : 'PotsDeviceDriver',
	#superclass : 'PotsDriver',
	#instVars : [
		'baseDevice'
	],
	#category : 'PharoThings-RobsVersion',
	#package : 'PharoThings-RobsVersion'
}

{ #category : 'initialization' }
PotsDeviceDriver >> usingDevice: aDevice [
	baseDevice := aDevice
]
