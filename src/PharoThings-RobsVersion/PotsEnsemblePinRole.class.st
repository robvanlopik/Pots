"
I represent an Ensembke Role, that is, a function that is performed by more than one pins together.
Specifially, the pins are used by a lower level protocol and accessed indivudually.
(In case we control the pins ourselves, we would call is a PotsDevice; usually an EnsembleRole also ends up in a PotsDevice, but then specific for that protocol)

Specific for an ensemble role is that the DRIVER decides which pins can play that role
"
Class {
	#name : 'PotsEnsemblePinRole',
	#superclass : 'PotsPinRole',
	#category : 'PharoThings-RobsVersion',
	#package : 'PharoThings-RobsVersion'
}

{ #category : 'accessing' }
PotsEnsemblePinRole >> lastValue [
	^nil
	
]
