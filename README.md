# A simple mass balance model

## Balance at a point

Implement a temperature-index surface mass balance model (SMB):

melt and accumulation rate:
- melt rate for positive temperatures is given as `DDF * T` with
  degree-day factor `DDF` and local temperature `T`
- precipitation is from measurements

lapse-temperature:
- to translate temperature to different elevations use `0.6/100 C/m`

synthetic temperature:
- `-10*cos(2pi/364 * t) - 8*cos(2pi* t) + 5` with t in days.

yearly mass balance:
- integrate melt and accumulation rate over a year
