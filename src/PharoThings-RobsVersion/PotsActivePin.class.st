"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

I represent the active pins of the controller board

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #PotsActivePin,
	#superclass : #PotsPin,
	#instVars : [
		'id',
		'roles',
		'currentRole'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #adding }
PotsActivePin >> addRole: aPotsPinRole [
	"add thi role to the roles dictionary. The key i provides by the class method #short"
	roles at: (aPotsPinRole class short) put: aPotsPinRole.
]

{ #category : #accessing }
PotsActivePin >> currentRole [
	^ currentRole
]

{ #category : #accessing }
PotsActivePin >> currentRole: anObject [
	currentRole := anObject
]

{ #category : #accessing }
PotsActivePin >> id [
	^ id
]

{ #category : #accessing }
PotsActivePin >> id: anObject [
	id := anObject
]

{ #category : #initialization }
PotsActivePin >> initialize [
	super initialize.
	currentRole := PotsPinRole new.
	roles := Dictionary new.
]

{ #category : #accessing }
PotsActivePin >> roles [
	^ roles
]

{ #category : #accessing }
PotsActivePin >> roles: anObject [
	roles := anObject
]
