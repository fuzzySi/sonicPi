# MIDI beats (-> nord drums)
# MIDI_global = 10
MIDI_drum = 10
use_midi_defaults port: "usb_ms1x1_midi_interface_midi_1", channel: "10", sustain: 0.1
# port1 = "usb_midi_4i4o_midi_1"


loopLength = 16

# interesting beats
BD1 = 0b1001010110010100 #38292
SD1 = 0b0010001000100010 # 8738
HH1 = 0b1001101101101101 # 39789
cl1 = 0b1010001010100010 # 41634

tresillo = 0b1001001010010010 #37522
habanera = 0b1001101010011010 #39578
cinquillo = 0b1011011010110110

# simple beats
twos = 0b1000100010001000
fours = 0b1010101010101010
offBeat = 0b0010001000100010
eights = 0b1111111111111111



live_loop :drums10 do
  use_real_time
  
  # randomise each drum occasionally
  case rand(4).round(0)
  when 0
    BD = rand(65535).round(0)
  when 1
    SD = rand(65535).round(0)
  when 2
    HH = rand(65535).round(0)
  when 3
    clap = rand(65535).round(0)
  end
  
  ###  PLAY ME HERE  ###
  # uncomment to change beats
  # BD = tresillo
  SD = tresillo # habanera
  HH = 0b1100110111001101
  clap = cinquillo
  
  BD = BD1
  SD = SD1
  HH = HH1
  cl = cl1
  
  # BD = twos # fours #
  # SD = offBeat
  # HH = eights
  # clap = offBeat
  
  
  #######################
  
  n = sync  "/osc*/quaver" # wait for trigger
  i = loopLength - n[0] - 1 # works backwards (LSB)
  
  if BD[i] == 1
    midi :gs2
  end
  if SD[i] == 1
    midi :a2
  end
  if HH[i] == 1
    midi :as2
  end
  if clap[i] == 1
    midi :g2
  end
  sleep 0.1
end
