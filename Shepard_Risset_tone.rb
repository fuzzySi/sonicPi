# Shepard-Risset glissando
# this makes a chord of rising notes, fading in & out (the barber pole illusion)

use_synth :sine
notes = chord:c3, :m7,  num_octaves: 3
# change notes to MIDI

direction = 1   # -1 for down
tempo = 120
maxAmp = 0.5
ribbons = 5
height = 19 # semitones to rise
sleepTime = 2
increment = 2 # goes up by this number of semitones per _sleepTime_
ampTotal = 2
slideValue = 1

no_of_steps = height / increment # 14 & 3 gives 4 steps
puts no_of_steps
no_of_steps += 1 # next number past 5 steps, first & last value = 0
no_of_steps = no_of_steps.to_i
puts no_of_steps

ampValue = []
pitch = []
s = []


# starter ampValues
for i in 0...no_of_steps
  ampValue[i] = ampTotal
end
ampValue[0] = 0
ampValue[no_of_steps] = 0

# setup notes
for r in 0...ribbons
  pitch[r] = notes[r].to_f
  s[r] = play pitch[r], note_slide: slideValue, sustain: 6000, amp_slide: ampValue[r]
end
# sleep sleepTime # this stops it barberpoleing straight away


live_loop :barberPole do
  use_bpm tempo
  for r in 0...ribbons
    pitch[r] += (increment * direction) # update pitch
    # & derive amp
    if pitch[r] >= notes[0] + height + increment then
      pitch[r] = notes[0] # reset pitch to start
      ampValue[r] = 0     #  & keep quiet
    elsif pitch[r] >= notes[0] + height then
      ampValue[r] = 0
    else
      ampValue[r] = ampTotal
    end
    
    # glide to next
    control s[r], note: pitch[r], amp: ampValue[r]
    puts pitch[r], ampValue[r]
  end
  sleep sleepTime
end
