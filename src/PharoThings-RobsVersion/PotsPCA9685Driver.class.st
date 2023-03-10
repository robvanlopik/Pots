"
I expose a PCA9685 PWM controller as a 16 pins PotsController, after it has first been installed as a PotsI2CDevice on another controller. I give access to 16 pins (0 - 15) that can be digital output, pwm or servo. A limitation is, that alle pins share the same frequency, so effectively pwm and servo are mutually exclusive. beServoOutput sets the frequency to 50 Hz and can only be performed when none of the pins is PWM. Vica versa bePWMOutput sets the frequency to 1000 Hz and is only possible when none of the pins is Servo.

ivars:
ioMask - 16 bits where 0 means the pin is digital output and 1 means servo or pwm, determined by:
servo - true means all servo, false means all pwm.
"
Class {
	#name : #PotsPCA9685Driver,
	#superclass : #PotsDeviceDriver,
	#instVars : [
		'ioMask',
		'servo'
	],
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'as yet unclassified' }
PotsPCA9685Driver class >> usingDevice: aDevice [
	^self basicNew usingDevice: aDevice
]

{ #category : #'private - controlling' }
PotsPCA9685Driver >> beDigitalOutputOnPin: aPin [
	ioMask := ioMask bitAt: (aPin id + 1) put: 0.
	"and set this output to 0, soeventual PWM or Servo is switched off"
	baseDevice pinOff: aPin id.
]

{ #category : #'private - controlling' }
PotsPCA9685Driver >> bePWMOutputOnPin: aPin [
	"first check of pwm is active, then mask to 1"
	servo ifFalse: [ ioMask := ioMask bitAt: (aPin id + 10) put: 1 . ^self].
	self assert: [ (ioMask bitAnd: 16rFF) ~= 0 ] description: 'Servo mode still active on other pins'.
 
]

{ #category : #'private - controlling' }
PotsPCA9685Driver >> beServoOutputOnPin: aPin [
	"first check of servo is active, then mask to 1"
	servo ifTrue: [ ioMask := ioMask bitAt: (aPin id + 10) put: 1 . ^self].
	self assert: [ (ioMask bitAnd: 16rFF) ~= 0 ] description: 'PWM mode still active on other pins'.
 	"OK, go ahead and change frequency"
	baseDevice frequency: 50.
	ioMask := ioMask bitAt: (aPin id + 1) put: 1
]

{ #category : #'private - accessing' }
PotsPCA9685Driver >> digitalValue: oneOrZero intoPin: aPin [ 
	(oneOrZero = 0) ifTrue: [ baseDevice pinOff: aPin id. ^self ].
	baseDevice pinOn: aPin id.
]

{ #category : #initialization }
PotsPCA9685Driver >> providePinInfo [
	"return dict of pins"
	| pinDict |
	pinDict := Dictionary new.
	0 to: 15 do:
		[ :pinId | pinDict at: pinId put: 
			(PotsActivePin new 
			id: pinId;
			currentRole: (PotsDigitalOutputRole new driver: self)) ].
	pinDict valuesDo: [ :pin | pin addRole: (pin currentRole) ].
	pinDict valuesDo: [ :pin | pin addRole: (PotsPWMRole new driver: self; range: 4095) ].
	pinDict valuesDo: [ :pin | pin addRole: (PotsServoRole new driver: self; min: 450; max: 2500) ].
	^pinDict
]

{ #category : #'private - accessing' }
PotsPCA9685Driver >> pwmValue: aNumber intoPin: aPin [
	"The PCA9685 already accepts percentages"
	baseDevice pwmForPin: (aPin id + 1) percentage: aNumber
]

{ #category : #initialization }
PotsPCA9685Driver >> setup [ 
	"start with all pins digital out, and default pwm"
	ioMask := 0.
	servo := false.
	baseDevice frequency: 1000.
	baseDevice allOff
	
]

{ #category : #initialization }
PotsPCA9685Driver >> usingDevice: aDevice [
	baseDevice := aDevice.
	self setup
]
