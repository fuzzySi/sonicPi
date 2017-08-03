# test to parse a lilypond file & play it
# lilypond is an opensource format used to layout sheet music (similar to latex)
# 8 means semiquavers, durations persist until changed
# comma goes down an octave, (based around note A) ' goes up 1 octave. r means a rest.

lily = "c8 b c g, ef g c r | c' b c g, ef g c r| c' d ef d ef c d c d b c g, ef g c4 " # ensure space at end
# other lilypond stuff such as bars: '|' is ignored

currentOctave = 57 # a3 is 57. change this to start at lower octave, or transpose

notes = Array.new       # output array of notes
durations = Array.new   # output of note durations

# sets up working variables
currentNote = "", number = "", numbers = ""
restBool = false, newNote = false
duration = 1, dotted = 1 # multiplier for dotted note durations

# parses lily file and works out which are notes
lily.split('').each do|c|
  asc = c.ord # ascii code for letter
  if newNote==false and asc >96 and asc < 104
    currentNote = asc - 97 # note 'a' converted to note 0
    # now to map ascii to MIDI notes - make up for the black keys
    if currentNote > 5
      currentNote += 4 # g is 4 notes above a
    elsif currentNote > 3
      currentNote += 3 # e & f go up 3 notes
    elsif currentNote == 3
      currentNote += 2 # d goes up 2 notes
    elsif currentNote > 0
      currentNote += 1 # b & c go up 1
    end
    if currentNote
      newNote = true
    end
  end
  if newNote == false and asc == 114 then # rest
    restBool = true
  end
  if newNote == true then
    if asc == 102 then # f ie flat
      currentNote -= 1
    elsif asc == 115 then # s ie sharp
      currentNote += 1
    elsif asc == 44 then # comma ie one octave down
      currentOctave -= 12
      if currentOctave < 0 then # don't go too low
        currentOctave += 12
      end
    elsif asc == 39 then
      currentOctave += 12
      if currentOctave > 117 then # or too high
        currentOctave -= 12
      end
    end
  end
  if asc > 48 and asc < 58 then     # it's a number, ignore zeros
    number = asc - 48 # 48 is zero, gets back to the number value
    duration = 0 # reset duration, as it's a new value
    numbers << number.to_s # add to string containing number - allows double digit values
    dotted = 1.0 # new duration, so not dotted any more
  end
  if asc == 46 then # dotted
    dotted = 1.5
  end
  if asc == 32 then # space, means end of this note
    if duration == 0
      duration = 4.0 / numbers.to_i * dotted
      numbers = "" # tidy up
    end
    if newNote == true or restBool == true then
      if newNote == true then
        currentNote += currentOctave
        # puts "note: " + currentNote.to_s   #uncomment for testing
        notes.push(currentNote)
      end
      if restBool == true then
        #  puts "rest: "
        notes.push(0)
      end
      #puts "duration " + duration.to_s
      durations.push(duration)
      newNote = false
      restBool = false
      currentNote = ""
    end
  end
end

# testing
# notes.each do|n|
#  puts n
#end

live_loop :popcorn do
  use_bpm 160
  for i in 0..notes.length-1
    if notes[i] != 0 then # don't play a rest (recorded as note 0)
      play notes[i],sustain: durations[i]*0.5,release: durations[i]*0.2
    end
    sleep durations[i]
  end
end
