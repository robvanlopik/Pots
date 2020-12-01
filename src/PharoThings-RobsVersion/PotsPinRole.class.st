"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

I represent the different roles a pin can play
there are two kinds:
- `SoloRole` that is the pin itself is responsible for its actions
- ensembleRole where the pin is part of a set of pins that perform certain actions or protocols (eg I2C)
The name role is chosen as an alternative for ""mode"" or ""function"".

A role also contains information about eg the resolution of de function performed

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
	#name : #PotsPinRole,
	#superclass : #Object,
	#category : #'PharoThings-RobsVersion'
}
