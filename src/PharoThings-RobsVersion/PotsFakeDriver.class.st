"
I simulate a PotsDriver 
I supply pin data 
I react to pin commands


- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #PotsFakeDriver,
	#superclass : #PotsDriver,
	#instVars : [
		'parameter'
	],
	#category : #'PharoThings-RobsVersion'
}
