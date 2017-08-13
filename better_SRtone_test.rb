# Shepard-Risset glissando
# v2 130817
# changes: pitch slides next note not set increment.
# use attack, sustain, release. play new note for next ribbon ? use osc. 
# next pan voices
# this makes a chord of rising notes, fading in & out (the barber pole illusion)

use_osc "localhost", 4559 # possibly use this for note off?

use_synth :sine
notes = chord:c3, :m7,  num_octaves: 3
# change notes to MIDI
puts notes

direction = 1   # -1 for down
tempo = 120
maxAmp = 0.5
ribbons = 5
height = 12 # semitones to rise
sleepTime = 1
increment = 1 # goes up by this number of semitones per _sleepTime_
ampTotal = 2
slideValue = 1
sus = sleepTime * height.to_f
rel = sleepTime * 2
amp = 0

no_of_steps = height / increment # 14 & 3 gives 4 steps
puts no_of_steps
no_of_steps += 1 # next number past 5 steps, first & last value = 0
no_of_steps = no_of_steps.to_i
puts no_of_steps

ampValue = []
pitch = []
s = []
new = []


# setup notes
for r in 0...ribbons
  pitch[r] = notes[r].to_f
  new[r] = true
end
# sleep sleepTime # this stops it barberpoleing straight away


live_loop :barberPole do
  use_bpm tempo
  for r in 0...ribbons
    if new[r] == true then
      s[r] = play pitch[r], note_slide: slideValue, attack: sleepTime, amp: 1, amp_slide: sleepTime, sustain: sus, release: rel
      new[r] = false
    end
    pitch[r] += (increment * direction) # update pitch
    # & derive amp
    if pitch[r] >= notes[0] + height + increment then #at top
      pitch[r] = notes[0] # reset pitch to start
      control s[r], amp: 0, amp_slide: sleepTime
      new[r] = true
      # s[r] = play pitch[r], note_slide: slideValue, attack: sleepTime, sustain: sus, release: rel
    elsif pitch[r] >= notes[0] + height then #at top
      control s[r], amp: 0, amp_slide: sleepTime
    elsif pitch[r] < notes[0] + increment # first note
      control s[r], amp: 1, amp_slide: sleepTime
    else
      amp = ampTotal
    end
    # glide to next
    control s[r], note: pitch[r]
    
  end
  sleep sleepTime
end



