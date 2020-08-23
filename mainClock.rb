## master clock

# change me
bpm = 120
quaversInLoop = 16 # quavers before loop retriggered



# system vars etc
use_osc "localhost", 4560
use_midi_defaults port: "usb_ms1x1_midi_interface_midi_1", channel: "10", sustain: 0.1
# "usb_midi_4i4o_midi_1"
use_debug false
use_osc_logging true # false


## master OSC loop
live_loop :clock do
  # use_real_time
  use_bpm bpm
  # midi_clock_beat
  # n = 0
  osc "/start"
  midi_start
  quaversInLoop.times do |n|
    puts n
    osc "/quaver", n
    
    if n % 4 == 0 # tick every 4 clocks
      osc "/tick"
      puts "4th beat"
      midi :as2
    end
    sleep 0.25
    #  n += 1
  end
end

# convert osc to MIDI

live_loop :clockOut do
  use_real_time
  sync  "/osc*/tick"
  midi_clock_beat
end

