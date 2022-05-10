"
I represent one of the the different roles a pin can play;
there are two kinds:
- `SoloRole` where the real pin itself is manipulated directly
- `ensembleRole` where the pin is part of a set of pins that perform certain actions or protocols (eg I2C), in the context of a PotsDevice

The name ""role"" is chosen as an alternative for ""mode"" or ""function"".

A role also contains information about itself eg the resolution of de function performed

Roles are created during startup by the driver. Some have properties that can be changed by the user.

Instance  variables:
- pin  -  the pin this role applies to
- driver  -  the PotsDriver for this role. This could be found through #pin, but it is used for every operation by the role, so it is kept as an ivar

"
Class {
	#name : #PotsPinRole,
	#superclass : #Object,
	#instVars : [
		'pin',
		'driver'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'accessing structure variables' }
PotsPinRole class >> short [
	"return an abbreviation of this dunction, for use in
	layout and dictioannie of roles"
	"default is NA for Not Available/Active/Attributed"
	^'NA'
]

{ #category : #accessing }
PotsPinRole >> driver [
	^ driver
]

{ #category : #accessing }
PotsPinRole >> driver: anObject [
	driver := anObject
]

{ #category : #accessing }
PotsPinRole >> pin: anObject [
	pin := anObject
]
