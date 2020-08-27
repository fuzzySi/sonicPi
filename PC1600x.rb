# picks MIDI from prog 11 on PC1600x (Protools Vol/Pan)
# waits for note press to print val / 10
use_osc "localhost", 4560
set :breakPoints, 10

use_osc_logging false
use_cue_logging false

live_loop :catch_MIDI_Notes do
  use_real_time
  n, vel = sync "/midi/onyx_producer_2-2_midi_1/1/1/note_on"
  osc "/osc/note/#{n}/#{vel}"
  puts "channel ", n, "value ", get[:value[n]]
end

live_loop :catch_MIDI_cc do
  use_real_time
  cc, val = sync "/midi/onyx_producer_2-2_midi_1/1/1/control_change"
  # cc, val = sync "/midi/usb_midi_4i4o_midi_1/1/1/control_change"
  # osc "/osc/cc/#{cc},#{val}"
  osc "/cc", cc, val
  # print "slider #{cc} at #{val}"
end

live_loop :process_CC do
  use_real_time
  b = get[:breakPoints]
  data = sync  "/osc*/cc"
  # puts data[0], data[1]
  # ch = data[0]
  # output = (data[1] / b).to_i
  # set :value[ch], output
  set :value[data[0]], (data[1] / b).to_i
end
