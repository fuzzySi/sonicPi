## master clock

bpm = 120
quaversInLoop = 16


# system etc
use_osc "localhost", 4560
use_midi_defaults port: "usb_ms1x1_midi_interface_midi_1", channel: "10", sustain: 0.1
use_debug false
use_osc_logging false
use_cue_logging false
use_midi_logging false



## master OSC loops

live_loop :clock do
  use_bpm bpm
  osc "/start"
  midi_start
  quaversInLoop.times do |n|
    puts "beat", n
    osc "/quaver", n
    if n % 4 == 0 # tick every 4 clocks
      osc "/tick"
    end
    sleep 0.25
  end
end

# convert osc to MIDI
live_loop :clockOut do
  use_real_time
  sync  "/osc*/tick"
  midi_clock_beat
end

