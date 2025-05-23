
On 2022-04-21 I posted the following on the pharo-iot mailing list:

As announced on Discord, I would like to start a discussion on the future of Pharo-of-Things (PoT from now on).

I have to begin with noting that PoT, at the moment, has all signs of an abandoned project. To mention a few points:
- get.pharoiot.org delivers Pharo7
- iot.pharo.org mentions PiBakery (last updated in 2018). Why two web sites anyway? And we also have pharoiot.com
- Pharothings option in Pharo Launcher doesn't work
- github://pharo-iot/Pharothings last update 2020, README mentions pharo 6(!).
- WiringPi is deprecated and not included in latest Raspbian
- Does not work in P9 or P10

Maybe it is time for some spring cleaning :-)

I came across PoT about three years ago and started first to extend the Firmata driver to (almost) the full protocol. After that I did PiGPIO as an alternative to WiringPi. Noting some things missing in the board model of PoT, I experimented with a slightly alternative approach that I named PoTs (with the "s" from simplified). Unfortunately I had less time than I hoped, so I did not push this very hard, also because of the lack of a SerialPort implementation since the end of 2019 (new headless VM). By now my project is "usable"; the design has proven to be able to cope with three different types of processors and a mix of pin functions. It needs cleaning up, of course. In the repo (github.com/robvanlopik/Pots) there is also a document on the design: "Pot-to-Pots.md"

During the recent Pharo Days, I have discussed this with Marcus Denker and Allex Oliveira. We think that TelePharo does not have to be part of PoT; it is an interesting project, but needs more time and, IMHO, needlessly complicates the use of PoT. As to my work, we thought it was best to let the community decide whether or how to incorporate it, so that is the purpose of this post.

PoT or PoTs is named after the Internet-of-Things (IoT), but fills only a small part of the subject. The role Pharo could play in that much larger context can be the subject of another post. PoT by itself only encapsulates the control of sensors and actuators in a Pharo object model, relying on drivers and lower level software/firmware to actually control the GPIO pins of an MCU. As such, it can be used in bigger projects, but then you would have to put more effort in robustness, reliability and recoverability (think power fails, electric interference etc.) I think up till now it has mostly been used for teaching and experimentation. In that case simplicity, availability and cost are important. Pots directly works on any computer with an attached Pi, Arduino or Pico. No need for Telepharo, as any recent Pi (even the Pi Zero) is capable of running Pharo 9 or 10 in UI mode. Pots API is simple: for I/O, PWM, servo, ADC only the messages #value or #value: are needed. The cost of a Pico is €5. When you blow it up it is easily replaced, in contrast to a Pi of €140.

On the other hand there is ample documentation for PoT: the booklet, installation guides, the lessons in pharoiot.org etc. Installation is less of a problem, now that the Pi also has Iceberg so one Metacello script suffices for all scenarios. As far as teaching material goes, I plan to write some of my own, but I am also willing to adapt existing texts. My own target audience would be people who are used to electronics and microprocessors and would like to try out the benefits of Pharo.

I welcome all comments, both on the future of PoT and the role my Pots project can play in that future. In the meantime I will continue polishing my projects and start writing some tutorials, probable on Github pages.

Greetings from Portugal,

Rob van Lopik
