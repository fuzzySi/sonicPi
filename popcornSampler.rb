# this plays "Popcorn" using a sample - I used a cat meow sample
# sample rate changes basic pitch
# rpitch lets you play sample at rate of musical notes

samplesLib = "/pathTo/sonicPi/sampleLibrary/"
#tick_set :phrase, 0

live_loop :popcorn do
  use_bpm 80
  if look(:phrase) < 1 then
    sample samplesLib, 0, start: 0.05, finish: 0.25, rate: 0.20, rpitch: [:B1,:As1,:B1,:Fs1,:D1,:Fs1,:B0].tick
    sleep 0.5
    if look >= 6
      sleep 0.5
      tick_set 0
      tick :phrase #first time sets to 0
    end
  elsif look(:phrase) >= 1 then
    sample samplesLib, 0, start: 0.05, finish: 0.25, rate: 0.20, rpitch: [:b1,:cs2,:d2,:cs2,:D2,:b1,:cs2,:b1,:cs2,:as1,:b1,:fs1,:d1,:fs1,:b0].tick
    sleep 0.5
    if look >= 14
      sleep 0.5
      tick_set 0
      tick :phrase
    end
    puts look(:phrase)
    if look(:phrase) >=2 then
      tick_reset :phrase
    end
  end
end
