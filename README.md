NOTE : I'm currently having some collision issues with LibSGD, and as it is still in development I've decided to switch this project over to the Godot engine until things mature a bit.  Its moving along slowly but surely, but Godot is a very detailed game engine with a lot of features so its going to take me a little while to learn all its quirks.  I'll have a Godot project uploaded here as soon as I get something worthwhile, shouldn't be long! In the meantime please subscribe to my youtube channel, star this repository and check out my support page to get updates when they happen!  https://chaduke.github.io/support-me
-

This is a game project I've been wanting to work on for a very long time. Now that the years have flown by, and the original game that inspired me to re-create it has fallen into obscurity, (among other reasons), the time is now!

The original inspiration for this project came from a game I found many years ago (20 maybe?) called "Block", programmed by a Japanese developer that went by the name of "Kenta".  It's basically a Breakout / Arkanoid clone but with a TON of FUN features!

I recently dug up the original game on "Wayback Machine" and tried to play it on my modern system but no dice!  Luckily and thankfully with the help of programming genius Nathan Baggs the game is now playable again, and now I can study its ways and try to somewhat faithfully re-create its magic.

This repository will serve as both a learning hub for those who wish to get a closer look at how I'm accomplishing this task, and as a way to check on my progress.

At the current stage it is being written in Python and uses the fantastic game library LibSGD.

Here are some links to the various people / places I mentioned:

The original "Block" game on Wayback Machine:

https://web.archive.org/web/20070203093035/http://www.interq.or.jp/tohoku/kenta/e/download/block/block.htm

A YouTube video of the game being played:

https://www.youtube.com/watch?v=aU1Hrpr2igM

YouTube account of "Nathan Baggs" (go check him out he's great!):
https://www.youtube.com/@nathanbaggs

TODO List:

- Continue refactoring game.py 
- Figure out problem with left over blocks
- Finish Editor    
    - Add new block types (in progress 7 done)
    - Add powerups (items) (in progress 4 done)
- Finish all 50 original levels
- Add 50 new unique levels
- Finish Menu (make it much prettier)
- Finish UI / HUD (need to start this soon)
- Redo all sounds / music in Ableton Live
- Many more things to come

My plan is to create progress reports and / or video every Sunday.

The game will be eventually released for free on itch.io and maybe other platforms depending on how well everything goes.

Instructions :

Clone the repository:

```git clone https://github.com/chaduke/paddles_balls_blocks_walls```

Install LibSGD:

```pip install libsgd```

Go into the "paddles_balls_blocks_walls" folder and run:

```python main.py```


