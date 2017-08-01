# Popcorn by Gershon Kingsley
# needs sonicPi v3 ('get' & 'set' appear in v3)
set :tempo, 240
set :transpose, 2

use_synth :blade
m=2;cd=1.5;c=1;q=0.5;dq=0.66;sq=0.25;dsq=0.125;hdsq=0.0625;qd=0.75
set :popcorn_notes,(ring :b3,:as3,:b3,:fs3,:d3,:fs3,:b2)
set :popcorn_durations,(ring q,q,q,q,q,q,c)
set :bassline,(ring :b1,:b2,:fs2,:b1,:b2,:fs2,:b1,:d2,:fs2,:b2)
set :bassline_durations,(ring q,sq,sq,q,sq,sq,sq,sq,sq,sq)
use_bpm get(:tempo)

live_loop :popcorn do
  notes2=get(:popcorn_notes)
  durations2=get(:popcorn_durations)
  notes2.zip(durations2).each do |n,d|
    play n+get(:transpose)
    sleep d*2
  end
end

live_loop :bass do
  notes=get(:bassline)
  bass_durations=get(:bassline_durations)
  notes.zip(bass_durations).each do |n,d|
    play n+get(:transpose)
    sleep d*2
  end
end
