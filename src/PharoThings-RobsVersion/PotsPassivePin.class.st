"
I am a pin that can not be controlled by software

I am used in a PotsLayout

"
Class {
	#name : 'PotsPassivePin',
	#superclass : 'PotsPin',
	#instVars : [
		'name'
	],
	#category : 'PharoThings-RobsVersion',
	#package : 'PharoThings-RobsVersion'
}

{ #category : 'inspector extensions' }
PotsPassivePin >> altIdString [
	^''
]

{ #category : 'inspector extensions' }
PotsPassivePin >> capabilitiesString [
	^''
]

{ #category : 'inspector extensions' }
PotsPassivePin >> idString [
	^self name
]

{ #category : 'accessing' }
PotsPassivePin >> name [

	^ name
]

{ #category : 'accessing' }
PotsPassivePin >> name: anObject [

	name := anObject
]

{ #category : 'inspector extensions' }
PotsPassivePin >> roleString [
	^''
]

{ #category : 'inspector extensions' }
PotsPassivePin >> valueString [
	^''
]
