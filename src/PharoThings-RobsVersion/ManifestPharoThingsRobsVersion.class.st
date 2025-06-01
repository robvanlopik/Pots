"
This package contains an alternative version of the PharoThings framework, reusing most of the ideas and hopefully lots of its code

Guiding principles are:
- Pin can have more roles
- layout of the board is optional
- error catching with assert
- 

The main structure is:
- a PotsController with
	- a driver 
	- pins (to be defined by the driver!)
	- layout
- a PotsPin with :
	- id (the original one)
	- roles
	- activeRole
	
- a Role that can be a SoloRole (eg digital in, or pwm) or a EnsembleRole (eg i2c or stepper)
	

"
Class {
	#name : 'ManifestPharoThingsRobsVersion',
	#superclass : 'PackageManifest',
	#category : 'PharoThings-RobsVersion-Manifest',
	#package : 'PharoThings-RobsVersion',
	#tag : 'Manifest'
}
