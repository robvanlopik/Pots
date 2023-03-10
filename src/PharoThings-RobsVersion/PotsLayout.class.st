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
PotsLayout class >> forArduinoUno [ 
	"fill the plain matrix for a Pico board"
	^ self new forArduinoUno 
]

{ #category : #'as yet unclassified' }
PotsLayout class >> forPi3 [
	"fill the plain matrix for a Pico board"
	^ self new forPi3
]

{ #category : #'as yet unclassified' }
PotsLayout class >> forPiZero [
	"fill the plain matrix for a Pico board"
	^ self new forPiZero
]

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
PotsLayout >> forArduinoUno [
	"setuo the plainMatrix
	Uno pins 0 and 1 are not available because they are used for Firmata's serial comms"
	
	plainMatrix := #(
		'NA'  19
		'NA'  18
		2     17
		3     16
		4     15
		5     14
		6     ''
		7    'VIN'
		8 	  'GND'
		9    'GND'
		10   '5V'
		11   '3V3'
		12   'RESET'
		13   'IOREF'
		'GND' ''
		'AREF' ''
		18    ''
		19    '')
]

{ #category : #initialization }
PotsLayout >> forPi3 [
	"setuo the plainMatrix"
	
	plainMatrix := #(
		'3V3'  '5V'
		2     '5V'
		3     'GND'
		4     14
		'GND' 15
		17    18
		27    'GND'
		22    23
		'3V3' 24
		10   'GND'
		9     25
		11    8
		'GND' 7
		'SD'  'SC '
		5     'GND'
		6     12
		13    'GND'
		19    16
		26    20
		'GND' 21 )
]

{ #category : #initialization }
PotsLayout >> forPiZero [
	"setuo the plainMatrix"
	
	plainMatrix := #(
		'3V3'  '5V'
		2     '5V'
		3     'GND'
		4     14
		'GND' 15
		17    18
		27    'GND'
		22    23
		'3V3' 24
		10   'GND'
		9     25
		11    8
		'GND' 7
		'SD'  'SC '
		5     'GND'
		6     12
		13    'GND'
		19    16
		26    20
		'GND' 21 )
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
