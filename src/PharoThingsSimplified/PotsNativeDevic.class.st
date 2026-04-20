"
I represent an attached device that is driven by code in the controller boards daemon. Availabilty depends on the driver. Notably Firmata and the Telemetrix drivers expose complete devices ;ile DHT temp sensor, stepper motor, NeoPixels, etc. I am responsible for the pin allacoation and device axcivation. After that I can either pass comand dicrecly to the driver of modify tje API
"
Class {
	#name : 'PotsNativeDevic',
	#superclass : 'PotsDevice',
	#category : 'PharoThingsSimplified',
	#package : 'PharoThingsSimplified'
}
