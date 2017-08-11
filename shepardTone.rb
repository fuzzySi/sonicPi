# Shephard tone

tempo = 120
maxAmp = 1
layers = 6
use_synth :pretty_bell
notes = chord:c3, 'm9+5',  num_octaves: 4


len = notes.length
vols = []
fade = len / 4 # proportion of loop affected by fade
incr = maxAmp.to_f / fade   # or  # maxAmp.fdiv(fade)
threads = []

for i in 0...layers
  threads[i] = len / layers * i # sorts out where multiple ribbons are along scale
end
for i in 0...fade # attribute fade volumes
  vols[i] = incr * (i + 1)
end
for i in fade...(len - fade)
  vols[i] = maxAmp
end
for i in (len - fade)...(len)
  vols[i] = incr * (len - i)
end

live_loop :scale do
  use_bpm tempo
  for i in 0...len
    for j in 0...layers
      k = i + threads[j]
      if k >= len then
        k = k - len
      end
      puts notes[k], vols[k], (k.fdiv(len)* 2)-1
      play notes[k], amp: vols[k], attack: 0.5, release: 1.5, pan: (k.fdiv(len)* 2)-1
    end
    sleep 0.5
  end
end
