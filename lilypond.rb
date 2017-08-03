# test to parse a lilypond file & play it

lily = "r4 ef2 d's16 | cs8 a b'4. a8 g,s e,f | r4 e'2 ds4 | cs8 a b4. a8 gs e" # example lilypond format
notes = ""
currentNote = ""
number = ""
numbers = ""
restBool = false
duration = 1
dotted = 1 # multiplier for dotted note durations
currentOctave = 57 # a3
newNote = false

lily.split('').each do|c|
  asc = c.ord # ascii code for letter
  # puts c
  if newNote==false and asc >96 and asc < 104
    currentNote = asc - 97 # + currentOctave # char a=97, -97=0, +57 to get midi note a3
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
      # puts "new Note"
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
  end
  if asc == 46 then # dotted
    dotted = 1.5
  end
  if asc == 32 then # space, means end of this note
    if duration == 0
      duration = 4.0 / numbers.to_i * dotted
    end
    if newNote == true or restBool == true then
      if newNote == true then
        currentNote += currentOctave
        puts "note: " + currentNote.to_s # use to_s to convert to string for puts
      end
      if restBool == true then
        puts "rest: "
      end
      puts "duration " + duration.to_s
      newNote = false
      restBool = false
      currentNote = ""
    end
    if asc == 32
      numbers = ""
      dotted = 1
    end
  end
end

#if c =~ /[a-gA-G]/ # if letter between a & g, upper or lower case
# =~ /\d/ # if is a number

