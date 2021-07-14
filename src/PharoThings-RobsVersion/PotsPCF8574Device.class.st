"
I represent a PCF8574 port extender. I have 8 in/output ports and am driven by the I2C bus.
With the proper driver I can function as a PotsController with both DigitalOutputRrole and DigitalInputRoles.  It is noteworthy that the input function also has a separate interrupt signal to notifyof changes, so polling would not be needed.
I am often used in conjunction with a simple 16x2 LCD (see PotsHD44780Device ). I can be configured for 8 diffferent I2C address, so you could use 8 devices in parallel for a total of 64 I/O ports.

in principle I have only two methods : 
`writeByte: aByte - to output 8 bits to my ports
`readByte = to read the pins; this only makes sense when you first write a 1 to each pin you are interested in. Reading a 0 then means the pin was pulled down, 1 otherwise. 

To implement reading/writing individual pins, you would have to maintain a bit mask; that is  done in the PotsPCF8574Driver.








Often the PCF8574  is sold mountedon a Pc board that matches and can be piggybacked on an LCD1602 display module. In that case there is a fixed relation between the pins:
PCF8574 |P0|P1|P2|P3|P4|P5|P6|P7|
LCD1601  RS RW EN BL D4 D5 D6 D7
You can create a PotsHD44780Device with the class method #defaultPCF8574
see: https://alselectro.wordpress.com/2016/05/12/serial-lcd-i2c-module-pcf8574/
"
Class {
	#name : #PotsPCF8574Device,
	#superclass : #PotsI2CDevice,
	#category : #'PharoThings-RobsVersion'
}

{ #category : #'instance creation' }
PotsPCF8574Device class >> defaultI2CAddress [ 
	^16r27
]

{ #category : #'reading-primitive data' }
PotsPCF8574Device >> readByte [
	^i2cConnection read8Bits
]

{ #category : #writing }
PotsPCF8574Device >> writeByte: aByte [ 
		i2cConnection write8Bits: aByte
]
