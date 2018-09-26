# Peerless

This repository contains the Inform 7 project folder for Peerless, an Interactive Fiction story set in the original Elite universe.

## Getting started

### Overview

Peerless is an experiment in procedural generation and free-space travel. In a departure from usual IF convention, the story of this game is a secondary concern. The real meat of the matter lies in the pursuit of two objectives:

* The faithful recreation of (or, if you will, homage to) the in-game universe of the original Elite.
* The development of an I7 extension system facilitating the concept of multi-room vessels and stations.

### Getting it running

You will need the [Inform 7 package, version 6M62](http://inform7.com/download/release/6M62/). Inform 7 is available for Windows, OS-X and Linux.

Once Inform 7 is installed, either place the folder in the Inform/Projects/ folder, or copy the source code (stored in source/story.ni) into the editor. Next, go to the Settings tab and select the Glulx story file format, which is the larger type of Inform 7 projects (Inform 7's use of the z-Machine format is locked to using signed integers, which makes them too small for the purpose).  

### Dependencies

None, at present. Peerless is written in I7 version 6M62 for Glulx, and the intent is to keep it up to date. No additional extensions are required. It does employ a bit of Inform 6, which may break the game under future versions of I7.

### Tests

When the game loads for testing purposes, it runs a regression test on the first galaxy. Test uses the output from the C version of Text Elite as its dataset, which should be sufficiently accurate. There's currently no tests exist for the other galaxies, but that will likely change.

At the momnent, the automatic tests do not validate the Goat Seed string. 

## Ideas for further work

### Old-School vs Enhanced mode

As it is, the Elite universe is really rather samey. I'm therefore considering the addition of more pseudorandom variation in the various solar systems, such as more planets, moons, planet visual descriptions, et cetera. As this represents a departure from the actual Elite universe, this will either have to be a togglable mode, or possibly an entirely new game built on the same basic principles.    

### Space traversal

This is definitely planned. Eventually, the player will be piloting the Cobra. For now, the important thing is to have the player guide the Cobra directly.

### Trading

Docking to the Coriolis station should be trivial. Trading engine is straightforward.

### Planetary landings

I believe this could be made workable, but I haven't gotten the details sorted in my head yet.

## Abandoned ideas

This covers a few ideas that were intriguing, but ultimately rejected as being beyond the scope of the project.

### z-Machine compatibility

The game could be made compatible with z8, but it's hard to see a point to it. Recent versions of I7 impose a size overhead that renders the z-Machine almost obsolete. Still, if someone wants to make the bit-shifting and so on more generic and thus useful, that would be appreciated. I can't see a trivial way of using unsigned values without dropping down to z-machine assembly, however, which I'm not sure is practical. Therefore, compatibility with the z-Machine is not planned. 

## Credits

Ian Bell and David Braben wrote the original Elite on the BBC Micro. They are its captains still.

In addition, I am indebted to Richard Carlsson, whose [GCC-compliant version of Text Elite](https://github.com/richcarl/txtelite) provided not just a compiling version of TE, but also the kick in the pants I needed to do something with my idea. 
