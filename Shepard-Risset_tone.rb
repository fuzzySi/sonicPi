# Shepard-Risset glissando
# this makes a chord of rising (or falling) notes, fading in & out (the barber pole illusion)

# play with these values
use_synth :sine
notes = chord:c3, :m,  num_octaves: 3 # but _ribbons_ sets actual number of notes played
direction = 1   # up, use -1 for down
tempo = 120
ribbons = 5 # number of simultaneous tones
height = 15 # semitones before restarting
sleepTime = 1
increment = 1 # pitch changes by this number of semitones per _sleepTime_

# working variables
ampTotal = 1
slideValue = sleepTime
sus = sleepTime * height.to_f
rel = sleepTime * 4
atk = rel
amp = 0
pitch = []
pan = []
s = []
new = []
puts notes

# setup
for r in 0...ribbons
  pitch[r] = notes[r].to_f
  new[r] = true
  pan[r] = (r * 2 / (ribbons.to_f - 0.99)) - 1
end

live_loop :barberPole do
  use_bpm tempo
  for r in 0...ribbons
    if new[r] == true then
      s[r] = play pitch[r], note_slide: slideValue, pan: pan[r], pan_slide: sleepTime, attack: atk, amp: ampTotal, amp_slide: sleepTime, sustain: sus, release: rel
      new[r] = false
    end
    pitch[r] += (increment * direction) # update pitch
    if (pitch[r] >= notes[0] + height + increment and direction == 1) or (pitch[r] <= notes[0] - height - increment and direction == -1) then #at top
      pitch[r] = notes[0] # reset pitch to start
      control s[r], amp: 0, amp_slide: sleepTime
      new[r] = true
    elsif (pitch[r] >= notes[0] + height) and direction == 1 or ((pitch[r] <= notes[0] - height) and direction == -1) then #at top
      control s[r], amp: 0, amp_slide: sleepTime
    elsif ((pitch[r] < notes[0] + increment) and direction == 1) or ((pitch[r] > notes[0] - increment) and direction == -1) # first note
      control s[r], amp: ampTotal, amp_slide: sleepTime
    else
      amp = ampTotal
    end
    control s[r], note: pitch[r]
  end
  sleep sleepTime
end
