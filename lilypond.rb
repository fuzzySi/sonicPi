# function to extract the notes from a lilypond file in SonicPi & play them
# lilypond is an opensource way to layout sheet music (similar to latex): http://lilypond.org/
# timings by numbers: 4 is crotchet, 8 a semiquaver, durations persist until changed.
# lilypond files must have a duration on first note and a space at the end
# comma goes down an octave, (based around note A) ' goes up 1 octave. r means a rest.
# other lilypond stuff such as bars, '|' is ignored
# https://github.com/fuzzySi/sonicPi

# uncomment one of these at a time to hear it
# lily = "c8 b c g, ef g c r | c' b c g, ef g c r| c' d ef d ef c d c d b c g, ef g c4 " # "Popcorn"
lily = "c4. c8 d2 c f e r c4. c8 d2 c g f2 r c4. c8 c'2 a f, e4. e8 d2 r2 b'f4. bf8 a2 f, g f r2 " # happy birthday
# lily = "a4 as b c cs d ds e f fs g gs a' af g, gf f e ef eff efff c cf bf a " # chromatic scale for testing

currentOctave = 57 # a3 is 57. change this to start at lower octave, or transpose

define :lily_to_midi do |input|
  # sets up working variables
  currentNote = "", number = "", numbers = ""
  restBool = false, newNote = false
  duration = 0, dotted = 1.0 # multiplier for dotted note durations
  n = Array.new   # output array of notes
  d = Array.new   # output of note durations
  
  # parses lily file and works out which are notes
  input.split('').each do|c|
    asc = c.ord # ascii code for letter
    if newNote==false and asc >96 and asc < 104
      currentNote = asc - 97 # note 'a' converted to note 0
      # now to map ascii to MIDI notes - make up for the black keys
      if currentNote > 4
        currentNote += 4 # f & g go up 4 notes
      elsif currentNote == 4
        currentNote += 3 # e goes up 3 notes
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
      numbers += number.to_s # add to string containing number - allows double digit values
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
          n.push(currentNote)
        end
        if restBool == true then
          #  puts "rest: "
          n.push(128)
        end
        # puts "duration " + duration.to_s
        d.push(duration)
        newNote = false
        restBool = false
        currentNote = ""
      end
    end
  end
  return n, d
end

notes, durations = lily_to_midi lily
# this calls function & reads notes from 'lily' into 'notes' & 'durations', use other names to read multiple files

live_loop :popcorn do
  use_bpm 160
  for i in 0..notes.length-1
    if notes[i] != 128 then # don't play a rest (stored as note 128, which is outside MIDI notes range)
      play notes[i],sustain: durations[i]*0.5,release: durations[i]*0.2
    end
    sleep durations[i]
  end
end
