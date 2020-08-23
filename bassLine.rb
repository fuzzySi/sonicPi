## bassline

# change me
MIDI_bass_ch = 2


# system vars, leave
# use_midi_defaults port: "usb_ms1x1_midi_interface_midi_1", channel: "1", sustain: 0.1 # midisport 1x1
use_midi_defaults port: "usb_midi_4i4o_midi_2", channel: "2", sustain: 0.1 # subZero 4x4
# port1 = "usb_midi_4i4o_midi_1"
playMe = false # by default, turn slot on below
use_osc_logging false
use_cue_logging false
use_midi_logging false
i = 0




live_loop :bassline do
  use_real_time
  
  ###  PLAY ME HERE  ###
  playMe = true # comment out to mute slot, false by default
  loopLength = 8
  
  b1 = [:e2, :e2, :g2, :a2, :e2, :e2, :b1, :a1, :rest, :e2,]
  
  currentLine = b1
  
  
  #######################
  
  n = sync  "/osc*/quaver" # wait for trigger
  
  # i = n[0] # syncs to main loop
  if playMe == true
    if rand_i(6)  >= 0 # misses some notes randomly, not if 0
      midi currentLine[i]
    end
    sleep 0.1
  end
  i += 1
  if i >= loopLength
    i = 0
  end
end
