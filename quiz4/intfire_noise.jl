"""
Created on Wed Apr 22 16:02:53 2015

Basic integrate-and-fire neuron 
R Rao 2007

translated to Julia by Robert Danitz 2015
"""

using Gadfly
using Distributions

set_default_plot_size(20cm, 15cm)

# input current
I = 1 # nA

# capacitance and leak resistance
C = 1 # nF
R = 40 # M ohms

# I & F implementation dV/dt = - V/RC + I/C
# Using h = 1 ms step size, Euler method

V = 0
tstop = 200
abs_ref = 5 # absolute refractory period 
ref = 0 # absolute refractory period counter
V_trace = []  # voltage trace for plotting
V_th = 10 # spike threshold
spiketimes = [] # list of spike times

# input current
noiseamp = 0 # amplitude of added noise
I += noiseamp*(rand(Normal(0, 1), tstop)) # nA; Gaussian noise

for t in 1:tstop
  if ref == 0
    V = V - (V/(R*C)) + (I[t]/C)
  else
    ref -= 1
    V = 0.2 * V_th # reset voltage
  end
   
  if V > V_th
    V = 50 # emit spike
    ref = abs_ref # set refractory counter
  end

  V_trace = [V_trace, V]
end

plot(x=0:tstop, y=V_trace, Geom.line)
