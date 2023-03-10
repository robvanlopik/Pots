"
I help performing I2C functions, at least let the driver tell which pins can perform this role.
All work is done by the I2CConnection class off each driver
- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #PotsI2CRole,
	#superclass : #PotsEnsemblePinRole,
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'accessing structure variables' }
PotsI2CRole class >> short [ 
	^'I2C'
]
