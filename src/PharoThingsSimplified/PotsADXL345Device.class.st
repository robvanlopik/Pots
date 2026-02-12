"
I provide implementation of accelerometer ADXL345.

The code for initialization and sensors reading is copied from sunfolder example:
 
	https://www.sunfounder.com/learn/Super_Kit_V2_for_RaspberryPi/lesson-14-adxl345-super-kit-for-raspberrypi.html
	
The real meaning of retrieved coordinates are explained in this link but not really clean.
So I just repeat their example according to the board model approach
"
Class {
	#name : 'PotsADXL345Device',
	#superclass : 'PotsI2CDevice',
	#category : 'PharoThingsSimplified',
	#package : 'PharoThingsSimplified'
}

{ #category : 'instance creation' }
PotsADXL345Device class >> defaultI2CAddress [ 
	^16r53
]

{ #category : 'initialize' }
PotsADXL345Device >> connect [
	"The code is copied from C:
	https://www.sunfounder.com/learn/Super_Kit_V2_for_RaspberryPi/lesson-14-adxl345-super-kit-for-raspberrypi.html"
	super connect.
	
	i2cConnection write8BitsAt: 16r31 data: 16r0b.
	i2cConnection write8BitsAt: 16r2d data: 16r08.
	i2cConnection write8BitsAt: 16r1e data: 16r00.
	i2cConnection write8BitsAt: 16r1f data: 16r00.
	i2cConnection write8BitsAt: 16r20 data: 16r00.
	i2cConnection write8BitsAt: 16r21 data: 16r00.
	i2cConnection write8BitsAt: 16r22 data: 16r00.
	i2cConnection write8BitsAt: 16r23 data: 16r00.
	i2cConnection write8BitsAt: 16r24 data: 16r01.
	i2cConnection write8BitsAt: 16r25 data: 16r0f.
	i2cConnection write8BitsAt: 16r26 data: 16r2b.
	i2cConnection write8BitsAt: 16r27 data: 16r00.
	i2cConnection write8BitsAt: 16r28 data: 16r09.
	i2cConnection write8BitsAt: 16r29 data: 16rff.
	i2cConnection write8BitsAt: 16r2a data: 16r80.
	i2cConnection write8BitsAt: 16r2c data: 16r0a.
	i2cConnection write8BitsAt: 16r2f data: 16r00.
	i2cConnection write8BitsAt: 16r38 data: 16r9f.
]

{ #category : 'reading' }
PotsADXL345Device >> readCoordinates [
	"The code is copied from C:
	https://www.sunfounder.com/learn/Super_Kit_V2_for_RaspberryPi/lesson-14-adxl345-super-kit-for-raspberrypi.html"
	| x0 x1 y0 y1 z0 z1 acc_x acc_y acc_z |
	x0 := 16rff - (i2cConnection read8BitsAt: 16r32).
	x1 := 16rff - (i2cConnection read8BitsAt: 16r33).
	y0 := 16rff - (i2cConnection read8BitsAt: 16r34).
	y1 := 16rff - (i2cConnection read8BitsAt: 16r35).
	z0 := 16rff - (i2cConnection read8BitsAt: 16r36).
	z1 := 16rff - (i2cConnection read8BitsAt: 16r37).

	acc_x := (x1 << 8) + x0.
	acc_y := (y1 << 8) + y0.
	acc_z := (z1 << 8) + z0.

	^{ acc_x. acc_y. acc_z }
]
