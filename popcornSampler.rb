# this plays the start of Popcorn using a sample - I used a cat meow sample
# sample rate changes basic pitch
# rpitch lets you play sample at rate of musical notes

samplesLib = "/pathTo/sonicPi/sampleLibrary/" # and code below plays first sample ('0') it finds

live_loop :popcorn do
  sample samplesLib, 0, start: 0.05, finish: 0.25, rate: 0.20, rpitch: [:B1,:As1,:B1,:Fs1,:D1,:Fs1,:B0].tick
  sleep 0.5
  if look >= 6
    sleep 0.5
    tick_set 0
  end
end
