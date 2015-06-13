"""
Created on Wed Apr 22 16:13:18 2015

Fire a neuron via alpha function synapse and random input spike train
R Rao 2007

translated to Julia by Robert Danitz 2015
"""

using Gadfly

set_default_plot_size(20cm, 15cm)

srand(0)

# I & F implementation dV/dt = - V/RC + I/C
h = 1. # step size, Euler method, = dt ms
t_max= 200 # ms, simulation time period
tstop = int(t_max/h) # number of time steps
ref = 0 # refractory period counter

# Generate random input spikes
# Note: This is not entirely realistic - no refractory period
# Also: if you change step size h, input spike train changes too...
thr = .9 # threshold for random spikes
spike_train = map(i -> i > thr, rand(tstop))

# alpha func synaptic conductance
t_a = 100 # Max duration of syn conductance
t_peak = 1 # ms
g_peak = .05 # nS (peak synaptic conductance)
const_ = g_peak / (t_peak*exp(-1));
t_vec = 0:h:t_a+h
alpha_func = const_ * t_vec .* exp(-t_vec/t_peak)

# capacitance and leak resistance
C = 0.5 # nF
R = 40 # M ohms
println("C = ", C)
println("R = ", R)

# conductance and associated parameters to simulate spike rate adaptation
g_ad = 0
G_inc = 1/h
tau_ad = 2

# Initialize basic parameters
E_leak = -60 # mV, equilibrium potential
E_syn = 0 # Excitatory synapse (why is this excitatory?)
g_syn = 0 # Current syn conductance
V_th = -40 # spike threshold mV
V_spike = 50 # spike value mV
ref_max = 4/h # Starting value of ref period counter
t_list = Array(Int, 0)
V = E_leak
V_trace = [V]
t_trace = [0]

for t in 1:tstop
  # Compute input
  if spike_train[t] != 0 # check for input spike
    t_list = [t_list, [1]]
  end

  # Calculate synaptic current due to current and past input spikes
  g_syn = sum(alpha_func[t_list])
  I_syn = g_syn*(E_syn - V) 

  # Update spike times
  if !isempty(t_list)
    t_list = t_list + 1
    if t_list[1] == t_a # Reached max duration of syn conductance
      t_list = t_list[2:end]
    end
  end

  # Compute membrane voltage
  # Euler method: V(t+h) = V(t) + h*dV/dt
  if ref == 0
    V = V + h*(-((V-E_leak)*(1+R*g_ad)/(R*C)) + (I_syn/C))
    g_ad = g_ad + h*(-g_ad/tau_ad) # spike rate adaptation
  else
    ref -= 1
    V = V_th - 10 # reset voltage after spike
    g_ad = 0
  end

  # Generate spike
  if (V > V_th) && (ref == 0)
    V = V_spike
    ref = ref_max
    g_ad = g_ad + G_inc
  end

  V_trace = [V_trace, V]
  t_trace = [t_trace, t*h]
end

p1 = plot(x = t_vec[1:80], y = alpha_func[1:80],
          Guide.xlabel("t (in ms)"), Guide.title("Alpha Function (Synaptic Conductance for Spike at t=0)"),
          Geom.line)

p2 = plot(x = 0:h:t_max, y = spike_train, Geom.line, Guide.title("Input spike train"))

p3 = plot(x=t_trace, y=V_trace, Guide.title("Output spike train"), Geom.line)

draw(PNG("alpha_func.png", 20cm, 15cm), p1)
draw(PNG("spike_trains.png", 20cm, 15cm), vstack(p2, p3))
