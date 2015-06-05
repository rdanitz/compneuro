"""
Created on Wed Apr 22 15:53:00 2015

Charging and discharging curves for passive membrane patch
R Rao 2007

translated to Julia by Robert Danitz 2015
"""

using PyPlot

# input current
I = 10 # nA

# capacitance and leak resistance

C = 0.1 # nF
R = 100 # M ohms
tau = R*C # = 0.1*100 nF-Mohms = 100*100 pF Mohms = 10 ms
println("C = $C nF")
println("R = $R M ohms")
println("tau = $tau ms")
println("(Theoretical)")

# membrane potential equation dV/dt = - V/RC + I/C

tstop = 150 # ms

V_inf = I*R # peak V (in mV)
tau = 0 # experimental (ms)

h = 0.2 # ms (step size)

V = 0 # mV
V_trace = [V] # mV

for t in 0:h:tstop
   # Euler method: V(t+h) = V(t) + h*dV/dt
   V = V +h*(- (V/(R*C)) + (I/C))

   # Verify membrane time constant
   if (tau != 0 && (V > 0.6321*V_inf))
     tau = t
     println("tau = $tau ms")
     println("(Experimental)")
   end
   
   # Stop current injection 
   if t >= 0.6*tstop
     I = 0
   end

   V_trace = [V_trace,V]
   if (t % 10 == 0)
     plot(0:h:t+h, V_trace, color="r")
     xlim(0, tstop)
     ylim(0, V_inf)
     draw()
   end
end

show()
