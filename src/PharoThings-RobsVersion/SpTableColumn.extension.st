Extension { #name : #SpTableColumn }

{ #category : #'*PharoThings-RobsVersion' }
SpTableColumn class >> title: aString evaluated: aValuable width: aNumber [

	^ self new 
		title: aString;
		evaluated: aValuable;
		width: aNumber;
		yourself
]
