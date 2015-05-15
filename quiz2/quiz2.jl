using PyPlot

data = readcsv("c1p8.csv")
stim = data[2:end,1] 
rho = convert(Array{Int,1}, data[2:end,2])
sampling_period = # in ms
num_timesteps =

# Compute the spike-triggered average from a stimulus and spike-train.
#
#   Args:
#       stim: stimulus time-series
#       rho: spike-train time-series
#       num_timesteps: how many timesteps to use in STA
#
#   Returns:
#       spike-triggered average for num_timesteps timesteps before spike
function compute_sta(stim, rho, num_timesteps)
  sta = zeros(num_timesteps)

  # This command finds the indices of all of the spikes that occur
  # after 300 ms into the recording.
  spike_times = find(rho[num_timesteps+1:end]) + num_timesteps

  # Fill in this value. Note that you should not count spikes that occur
  # before 300 ms into the recording.
  num_spikes =

  # Compute the spike-triggered average of the spikes found.
  # To do this, compute the average of all of the vectors
  # starting 300 ms (exclusive) before a spike and ending at the time of
  # the event (inclusive). Each of these vectors defines a list of
  # samples that is contained within a window of 300 ms before each
  # spike. The average of these vectors should be completed in an
  # element-wise manner.
  #
  # Your code goes here.
  
  sta
end

sta = compute_sta(stim, rho, num_timesteps)
time = [-num_timesteps+1:0] * sampling_period

plot(time, sta)
xlabel("Time (ms)")
ylabel("Stimulus")
title("Spike-Triggered Average")
show()
