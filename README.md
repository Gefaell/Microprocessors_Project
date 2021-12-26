# Microprocessors_Project

The aim of this investigation is to build and program a device
which helps to protect sensitive electronic components from
strong external magnetic fields. We will make use of the high
processing speed which assembly language provides to produce
a fast response to those harmful magnetic fields. Because of this,
our project will be based on real-time computing. Real-time
computing involves the development of a program which
ensures that a microprocessor will react to some input signal
within a short time window. The focus of our research will be
threefold, as we will explore how fast is our device’s response,
how complex can our input data be while still producing a quick
enough response, and how complex can our response be while
still meeting the specified deadline.

In terms of the hardware elements, we used a PIC18F87K22 
microprocessor mounted on a Mikroelectronika EasyPIC PRO
V7.0 development board. This is an 8-bit microprocessor
with a 64 MHz clock (1 instruction every 4 clock cycles).
We also used the Adafruit Unified Sensor LSM9DS1 9-
DOF, which incorporates a magnetometer, a gyroscope, and
an accelerometer.

We communicated with the magnetometer via SPI, and we compared
the last two magnetic field values recorded by the magnetometer
to detect abrupt changes in the magnetic field which might harm
electronic components. If the difference between the two values
was higher than a threshold value which we established, we turned
off a LED. We measured the speed of this response to be around a
few microseconds.

The last part of the project involved using a Motor Control board 
with a TLE94112EL half bridge driver. This allowed us to control several
electronic components with just one SPI (second one of the project
counting the magnetometer one).

The "interrupt" file is just a piece of code which we developed for the
first stage of the project, which involved turning off a LED when we
pressed a pin.
