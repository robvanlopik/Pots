"
I describe the layout of a PotsController board. For the time being that will be 2 columns with a number of rows. The instance variable pinMatrix is populated with PotsPins from my controller. I am created from a simple matrix containing GPIO Ids (numbers) and PassivePin abbreviations (strings '5V' '3V3' 'GND' 'NA')x


    Instance Variables
	controller:		aPotsController
	pinMatrix:		an Array of PotsPins
	plainMatrix: 	an Array of GPIO numers eand pther pin designations
	


    Implementation Points
"
Class {
	#name : #PotsLayout,
	#superclass : #Object,
	#instVars : [
		'pinMatrix',
		'plainMatrix',
		'controller'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'as yet unclassified' }
PotsLayout class >> forPico [
	"fill the plain matrix for a Pico board"
	^ self new forPico
]

{ #category : #operations }
PotsLayout >> applyTo: aController [
	"populate the pinMatrix"
	plainMatrix ifNil: [  PotsError signal: 'No layout defined' ].
	pinMatrix := plainMatrix collect: [ :pin |
		pin isString ifTrue: [ PotsPassivePin new name: pin ]
						ifFalse: [ aController pinWithId: pin ] ]
]

{ #category : #initialization }
PotsLayout >> forPico [
	"setuo the plainMatrix"
	
	plainMatrix := #(
		0     'NA'
		1     'NA'
		'GND' 'GND'
		2     'NA'
		3     '3V3'
		4     'VREF'
		5     28
		'GND' 'GND'
		6     27
		7     26
		8     'NA'
		9     22
		'GND' 'GND'
		10    21
		11    20
		12    19
		13    18
		'GND' 'GND'
		14    17
		15    16 )
]

{ #category : #accessing }
PotsLayout >> pinMatrix [
	^pinMatrix 
]
