"
I represent a BME280 sensor connected to a PotsDevice. My code is 99% taken from the PharoThings project.
My main methods are:
- readHumidity - humidity in %
- readTemperature - temp in degrees Celsius
- readPressure -  presure in 


"
Class {
	#name : 'PotsBME280Device',
	#superclass : 'PotsI2CDevice',
	#instVars : [
		'tCoeffs',
		'hCoeffs',
		'pCoeffs'
	],
	#category : 'PharoThingsSimplified',
	#package : 'PharoThingsSimplified'
}

{ #category : 'instance creation' }
PotsBME280Device class >> defaultI2CAddress [
	^16r77
]

{ #category : 'controlling' }
PotsBME280Device >> connect [
	"https://github.com/ControlEverythingCommunity/BME280/blob/master/Python/BME280.py"
	super connect.
	self initTempAndPressureCoeffs.
	self initHumidityCoeffs.	
	"Select control humidity register, 0xF2(242)
		0x01(01)	Humidity Oversampling = 1"
	i2cConnection write8BitsAt: 16rF2 data: 16r01.	
	"Select Control measurement register, 0xF4(244)
		0x27(39)	Pressure and Temperature Oversampling rate = 1
					Normal mode"
	i2cConnection write8BitsAt: 16rF4 data: 16r27.
	" Select Configuration register, 0xF5(245)
		0xA0(00)	Stand_by time = 1000 ms"
	i2cConnection write8BitsAt: 16rF5 data: 16rA0
]

{ #category : 'decoding' }
PotsBME280Device >> decodeHumidityFrom: dataFromF7 [
	"data: Humidity MSB, Humidity LSB
	returns percents"
	| raw temperature var_H humidity |
	raw := ((dataFromF7 at: 7) << 8) | (dataFromF7 at: 8).
	temperature := self decodeTemperatureFrom: dataFromF7.
	var_H := (temperature * 5120.0) - 76800.0.
	var_H := (raw - ((hCoeffs at: 4) * 64.0 + ((hCoeffs at: 5) / 16384.0 * var_H))) * ((hCoeffs at: 2) / 65536.0 * (1.0 + ((hCoeffs at: 6) / 67108864.0 * var_H * (1.0 + ((hCoeffs at: 3) / 67108864.0 * var_H))))).
	humidity := var_H * (1.0 - ((hCoeffs at: 1) * var_H / 524288.0)).
	^humidity min: 100 max: 0
]

{ #category : 'decoding' }
PotsBME280Device >> decodePressureFrom: dataFromF7 [
	"data: Pressure MSB, Pressure LSB, Pressure xLSB
	returns hPa"
	| raw temperature var1 var2 p |
	raw := ((dataFromF7 at: 1) << 12) | ((dataFromF7 at: 2) << 4) | ((dataFromF7 at: 3) >> 4).
	temperature := self decodeTemperatureFrom: dataFromF7.
	var1 := ((temperature * 5120.0) / 2.0) - 64000.0.
	var2 := var1 * var1 * (pCoeffs at: 6) / 32768.0.
	var2 := var2 + (var1 * (pCoeffs at: 5) * 2.0).
	var2 := (var2 / 4.0) + ((pCoeffs at: 4) * 65536.0).
	var1 := ((pCoeffs at: 3) * var1 * var1 / 524288.0 + (( pCoeffs at: 2) * var1)) / 524288.0.
	var1 := (1.0 + (var1 / 32768.0)) * (pCoeffs at: 1).
	p := 1048576.0 - raw.
	p := (p - (var2 / 4096.0)) * 6250.0 / var1.
	var1 := (pCoeffs at: 9) * p * p / 2147483648.0.
	var2 := p * (pCoeffs at: 8) / 32768.0.
	^(p + ((var1 + var2 + (pCoeffs at: 7)) / 16.0)) / 100
]

{ #category : 'decoding' }
PotsBME280Device >> decodeSignedWordArrayFrom: coeffs at: index size: size [
	| result word |
	result := Array new: size.
	1 to: size do: [ :i | 
		word := self decodeSignedWordFrom: coeffs at: index + ((i - 1) * 2).
		result at: i put: word ].
	^ result
]

{ #category : 'decoding' }
PotsBME280Device >> decodeSignedWordFrom: coeffs at: index [
	| unsigned |
	unsigned := self decodeUnsignedWordFrom: coeffs at: index.
	^ unsigned > 32767
		ifTrue: [ unsigned - 65536 ]
		ifFalse: [ unsigned ]
]

{ #category : 'decoding' }
PotsBME280Device >> decodeTemperatureFrom: dataFromF7 [
	"data: Temperature MSB, Temperature LSB, Temperature xLSB.
	returns Celsius"
	| raw var1 var2 |
	raw := ((dataFromF7 at: 4) << 12) | ((dataFromF7 at: 5) << 4) | ((dataFromF7 at: 6) >> 4).
	
	var1 := (raw / 16384.0 - ((tCoeffs at: 1) / 1024.0)) * (tCoeffs at: 2).
	var2 := ((raw / 131072.0 - ((tCoeffs at: 1) / 8192.0)) * (raw / 131072.0 - ((tCoeffs at: 1) / 8192.0))) * (tCoeffs at: 3).
	^(var1 + var2) / 5120.0
]

{ #category : 'decoding' }
PotsBME280Device >> decodeUnsignedWordFrom: coeffs at: index [
	^(coeffs at: index + 1) * 256 + (coeffs at: index)
]

{ #category : 'controlling' }
PotsBME280Device >> initHumidityCoeffs [
	| data h1 h2 h3 h4 h5 h6 |
	h1 := i2cConnection read8BitsAt: 16rA1.
	data := i2cConnection read8BitsArray: 7 startingAt: 16rE1.
	h2 := self decodeSignedWordFrom: data at: 1.
	h3 := (data at: 3) bitAnd: 16rFF.
	h4 := (data at: 4) * 16 + ((data at: 5) bitAnd: 16rF).
	h4 > 32767 ifTrue: [ h4 := h4 - 65536].
	h5 := ((data at: 5) / 16) + ((data at: 6) * 16).
	h5 > 32767 ifTrue: [ h5 := h5 - 65536].
	h6 := data at: 7.
	h6 > 127 ifTrue: [ h6 := h6 - 256].
	hCoeffs := {h1. h2. h3. h4. h5. h6}
]

{ #category : 'controlling' }
PotsBME280Device >> initTempAndPressureCoeffs [

	| data |
	data := i2cConnection read8BitsArray: 24 startingAt: 16r88.
	
	tCoeffs :=  {self decodeUnsignedWordFrom: data at: 1}
		, (self decodeSignedWordArrayFrom: data at: 3 size: 2).
	pCoeffs := {self decodeUnsignedWordFrom: data at: 7}
		, (self decodeSignedWordArrayFrom: data at: 9 size: 8)
]

{ #category : 'printing' }
PotsBME280Device >> printHumidity [
	^self readHumidity printShowingDecimalPlaces: 1
]

{ #category : 'printing' }
PotsBME280Device >> printPressure [
	^self readPressure printShowingDecimalPlaces: 1
]

{ #category : 'printing' }
PotsBME280Device >> printTemperature [
	^self readTemperature printShowingDecimalPlaces: 1
]

{ #category : 'controlling' }
PotsBME280Device >> readHumidity [
	^self readParameters last round: 1
]

{ #category : 'controlling' }
PotsBME280Device >> readParameters [
	"Pressure MSB, Pressure LSB, Pressure xLSB, Temperature MSB, Temperature LSB
	Temperature xLSB, Humidity MSB, Humidity LSB"
	| data |
	data := i2cConnection read8BitsArray: 8 startingAt:  16rF7.

	^{ 
		self decodeTemperatureFrom: data.
		self decodePressureFrom: data.
		self decodeHumidityFrom: data 
	 }
]

{ #category : 'controlling' }
PotsBME280Device >> readPressure [
	^self readParameters second round: 1
]

{ #category : 'controlling' }
PotsBME280Device >> readTemperature [
	^self readParameters first round: 1
]
