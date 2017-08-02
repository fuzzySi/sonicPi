# test to parse a lilypond file & play it
# not yet got durations working

lily = "r4 ef2 d's4 | cs8 a b'4. a8 g,s e,f | r4 e'2 ds4 | cs8 a b4. a8 gs e" # example lilypond note format
notes = ""
currentNote = ""
currentOctave = 57 # start in middle octave, 57 = A3
newNote = false

lily.split('').each do|c|
  asc = c.ord # ascii code for letter
  puts c
  if newNote==false and asc >96 and asc < 104
    currentNote = asc - 97 # + currentOctave # char a=97, -97=0
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
      puts "new Note"
      #puts currentNote
    end
  end
  if newNote == true then
    if asc == 102 then
      puts "flat"
      currentNote -= 1
    elsif asc == 115 then
      puts "sharp"
      currentNote += 1
    elsif asc == 44 then # comma ie one octave down
      currentOctave -= 12
      if currentOctave < 0 then # don't go too low
        currentOctave += 12
      end
    elsif asc == 39 then
      currentOctave += 12
      if currentOctave > 117 then
        currentOctave -= 12
      end
    end
    #puts currentNote
  end
  if asc == 32 and newNote == true then
    currentNote += currentOctave
    puts "note: " + currentNote.to_s # use to_s to convert to string for puts
    puts " "
    newNote = false
    currentNote = ""
  end
end

#if c =~ /[a-gA-G]/ # if letter between a & g, upper or lower case
# =~ /\d/ # if is a number

