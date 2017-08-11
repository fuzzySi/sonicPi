# Shepard tone

maxAmp = 1
layers = 7
use_synth
notes = chord:c3, 'm7-5', num_octaves: 4
len = notes.length


vols = []
fade = len / 5 # proportion of loop affected by fade
incr = maxAmp.to_f / fade   # or  # maxAmp.fdiv(fade)
gaps = len / layers
threads = []

for i in 0...layers
  threads[i] = gaps * i
  #puts i, threads[i]
end


puts "length"
puts len
puts "fade"
puts fade
puts incr
puts gaps

for i in 0...fade
  vols[i] = incr * (i + 1)
  puts i, vols[i]
end
for i in fade...(len - fade)
  vols[i] = maxAmp
  puts i, vols[i]
end
for i in (len - fade)...(len)
  vols[i] = incr * (len - i)
  puts i, vols[i]
end

live_loop :scale do
  use_bpm 120
  # notes.each do |i|
  for i in 0...len
    for j in 0...layers
      k = i + threads[j]
      if k >= len then
        k = k - len
      end
      puts notes[k], vols[k]
      play notes[k], amp: vols[k]
    end
    sleep 0.5
  end
end
