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
