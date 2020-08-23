# sonicPi
tunes for sonic Pi

main clock 0 - this sends osc quavers 0-16, and tick every 4 quavers, restart to keep external synths in sync
  n = sync  "/osc*/quaver" # in another slot will pick up timing signal and what quaver it is
  
beats 9 - sends Euclidian or programmable rhythms via MIDI, changable on the fly. 
  TO DO: necklaces
  

sonicPi gist here
https://gist.github.com/fuzzySi

blog post about using OSC to sync sonicPi, using processing
http://fuzzysynth.blogspot.co.uk/2017/06/interfacing-processing-with-sonic-pi.html
