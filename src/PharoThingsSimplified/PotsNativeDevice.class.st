"
My subclasses represent attached devices that are driven by code in the controller boards daemon. Availability depends on the driver. Notably Firmata and the Telemetrix drivers expose complete devices like the DHT temp sensor, stepper motor, NeoPixels, etc. I am responsible for the pin allocation and device activation. After that I can either pass commands dicrecly to the driver of modify its API.

Note: part of this could also be done in the baseDriver itself
"
Class {
	#name : 'PotsNativeDevice',
	#superclass : 'PotsDevice',
	#category : 'PharoThingsSimplified',
	#package : 'PharoThingsSimplified'
}
