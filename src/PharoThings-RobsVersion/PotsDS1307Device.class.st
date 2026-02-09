"
I control the Reaaltime clock device DS1307.
Apart from the rtc function I also contain some RAM (battery backupped).
The device also EPROM, but thsis not accesible hfrom here.
"
Class {
	#name : 'PotsDS1307Device',
	#superclass : 'PotsI2CDevice',
	#category : 'PharoThings-RobsVersion',
	#package : 'PharoThings-RobsVersion'
}

{ #category : 'instance creation' }
PotsDS1307Device class >> defaultI2CAddress [
	"Note: the TinyRTC device also contains a 24C32 EEPROM at address 16r50). This can betreated as a different device; we will cal it PotDS3107MEEPROM"
	^16r68
]

{ #category : 'accessing' }
PotsDS1307Device >> dateAndTime [
	"retrieve a complete DateAndTime object from the RTC"

	^DateAndTime basicYear: (self year + 2000)
					month: (self month)
					day: (self day)
					hour: (self hour)
					minute: (self minute)
					second: (self second)
					nanoSecond: 0
					offset: DateAndTime localOffset
					
					
]

{ #category : 'private - utilities' }
PotsDS1307Device >> dateAndTime: aDateAndTime [
	"set the RTC to the specified date and time"

	self second: aDateAndTime second.
	self minute: aDateAndTime minute.
	self hour: aDateAndTime hour.
	self dayOfWeek: aDateAndTime dayOfWeek.
	self day: aDateAndTime dayOfMonth.
	self month: aDateAndTime month.
	self year: ((aDateAndTime  year) - 2000)
	
	
]

{ #category : 'accessing' }
PotsDS1307Device >> day [
	^self readRegister: 4
]

{ #category : 'accessing' }
PotsDS1307Device >> day: anInt [
	self writeRegister: 4 data: anInt
]

{ #category : 'accessing' }
PotsDS1307Device >> dayOfWeek [ 
	^self readRegister: 3
]

{ #category : 'accessing' }
PotsDS1307Device >> dayOfWeek: anInt [
	self writeRegister: 3 data: anInt
]

{ #category : 'output' }
PotsDS1307Device >> disableSquareWave [
	"disable square wave output"

	i2cConnection write8BitsAt: 16r07 data: 0
]

{ #category : 'output' }
PotsDS1307Device >> enableSquareWave1Hz [
	"output 1 Hz square wave on pin SQW/OUT"

	| temporary variable names |
	
]

{ #category : 'output' }
PotsDS1307Device >> enableSquareWave32kHz [
	"32.768 kHz on pin SQW/OUT"

	i2cConnection write8BitsAt: 16r07 data: 16r13
]

{ #category : 'output' }
PotsDS1307Device >> enableSquareWave4kHz [
	"4.096 kHz on pin SQW/OUT"

	i2cConnection write8BitsAt: 16r07 data: 16r11
]

{ #category : 'output' }
PotsDS1307Device >> enableSquareWave8kHz [
	"8.192 kHz on pin SQW/OUT"

	i2cConnection write8BitsAt: 16r07 data: 16r12
]

{ #category : 'accessing' }
PotsDS1307Device >> hour [
	"we assume 24-hours format"
	^self readRegister: 2
]

{ #category : 'accessing' }
PotsDS1307Device >> hour: anInt [
	self writeRegister: 2 data: anInt
]

{ #category : 'private - utilities' }
PotsDS1307Device >> intFromBCD: aBCDByte [
	"return the int value of a packedBCD byte"

	^10 * (aBCDByte bitShift: -4) + (aBCDByte bitAnd: 16r0F)
]

{ #category : 'output' }
PotsDS1307Device >> isRunning [
	"check the MSB of register 0. If it is 1, the clock is not running and the date is invalid"

	| answer |
	answer := self readRegister: 0.
	^((answer bitAnd: 2r10000000) = 0 ) 
]

{ #category : 'accessing' }
PotsDS1307Device >> memoryAt: anIndex [
	"comment stating purpose of message"

	^i2cConnection read8BitsAt: (anIndex + 7)
	
]

{ #category : 'accessing' }
PotsDS1307Device >> memoryAt: anIndex put: aByte [
	"write aByte to RAM. we must check the index, because we don't want to risk overwriting the clock"

	((anIndex < 1) or: (anIndex > 56)) ifTrue: [ ^self error: 'index out of bounds' ].
	
	i2cConnection write8BitsAt: (anIndex + 7) data: aByte.
	
]

{ #category : 'accessing' }
PotsDS1307Device >> minute [
	^self readRegister: 1
]

{ #category : 'accessing' }
PotsDS1307Device >> minute: anInt [
	self writeRegister: 1 data: anInt
]

{ #category : 'accessing' }
PotsDS1307Device >> month [ 
	^self readRegister: 5
]

{ #category : 'accessing' }
PotsDS1307Device >> month: anInt [
	self writeRegister: 5 data: anInt
]

{ #category : 'private - utilities' }
PotsDS1307Device >> packedBCDFromInt: anInt [
	"convert a number (0..99) to packed BCD"

	^(anInt // 10) * 16 + (anInt \\ 10)
]

{ #category : 'accessing' }
PotsDS1307Device >> readRegister: anInteger [
	"read register anInterger and convert from BCD"

	^self intFromBCD: (i2cConnection readByteAt: anInteger)

]

{ #category : 'finalization' }
PotsDS1307Device >> releaseResources [
	
]

{ #category : 'accessing' }
PotsDS1307Device >> second [
	"read the secondsregister"
	| sec |
	sec := self readRegister: 0.
	(sec > 60) ifTrue: [^ self error: 'clock not running' ].
	^sec
]

{ #category : 'accessing' }
PotsDS1307Device >> second: anInt [
	
	self writeRegister: 0 data: anInt
]

{ #category : 'accessing' }
PotsDS1307Device >> writeRegister: anInteger data: aNumber [
	"comment stating purpose of message"

	i2cConnection writeByteAt: anInteger data: (self packedBCDFromInt: aNumber)
]

{ #category : 'accessing' }
PotsDS1307Device >> year [ 
	^self readRegister: 6
]

{ #category : 'accessing' }
PotsDS1307Device >> year: anInt [
	self writeRegister: 6 data: anInt
]
