# picks MIDI from prog 11 on PC1600x (Protools Vol/Pan)
# waits for note press to print val / 10
use_osc "localhost", 4560
set :breakPoints, 10
use_osc_logging  true # false
use_cue_logging false
use_midi_defaults port: "onyx_producer_2-2_midi_1", sustain: 0.1 # onyx

# set :fader15ch, 15 # res for shruthi
# set :fader16ch, 14 # cc for shruthi FX EQ

# this bit may not work
set :faderCh[1], nil
set :faderCh[2], nil
set :faderCh[3], nil
set :faderCh[4], nil
set :faderCh[5], nil
set :faderCh[6], nil
set :faderCh[7], nil
set :faderCh[8], nil
set :faderCh[9], nil
set :faderCh[10], nil
set :faderCh[11], nil
set :faderCh[12], 20 # osc 1 shape
set :faderCh[13], nil # sruthi feedback
set :faderCh[14], nil # shruthi delay EQ
set :faderCh[15], 15 # shruthi res
set :faderCh[16], 14 # shruthi cutoff


live_loop :catch_MIDI_notes do
  use_real_time
  ch, vel = sync "/midi/onyx_producer_2-2_midi_1/1/1/note_on"
  # osc "/button_on/#{ch}/#{vel}"
  osc "/button_on", ch, vel
end

live_loop :listenButton do
  use_real_time
  ch, vel = sync "/osc*/button_on"
  # puts "buttonPressed", ch, vel
  
end

live_loop :newFaderPos do # updates fader position when button pressed
  use_real_time
  ch, vel = sync "/osc*/button_on"
  puts "faderpos", get[:fader[ch]]
end

live_loop :catch_MIDI_cc do
  use_real_time
  cc, val = sync "/midi/onyx_producer_2-2_midi_1/1/1/control_change"
  puts "incomingMIDI", cc, val
  # osc "/osc/cc/#{cc},#{val}"
  osc "/cc", cc, val    # print "slider #{cc} at #{val}"
  # midi_cc get[:faderCh[16]], val, channel: 1, port: "onyx_producer_2-2_midi_1"
  if cc == 15
    midi_cc 12, val, channel: 1, port: "onyx_producer_2-2_midi_1"
  end
  if cc == 16
    midi_cc 20, val, channel: 1, port: "onyx_producer_2-2_midi_1"
  end
end

live_loop :process_cc do # takes MIDI osc and converts to fader position
  use_real_time
  b = get[:breakPoints]
  data = sync "/osc*/cc"
  # puts data[0], data[1]
  ch = data[0]
  output = (data[1] / b).to_i # divides into val into breakpoints number of regions
  set :fader[ch], output
  osc "/faders/", ch, output
end
