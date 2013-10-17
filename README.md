#Dungeon Style Game

This is a first attempt at trying to create a game for the iPad and iPhone.

This project is changing quickly with frequent updates. This readme
will be updated with the current progress.

Game written for iOS using the new SpriteKit.

## Map Generation
The project is part way through map generation. A maze is generated
using a depth first implamentation. This is then turned into a map
in the map builder. Once finished a character will be able to explore
the map and fighting off enemies to find the exit.

The floor tiles make use of my other project the [TWTiledSprite](https://github.com/bloggertom/TWTiledSpriteNode)
which takes a single of multiple texters and tiles them across the
size of the sprite node.

There are currently debugging tiles around the edge of this maze which will
become the walls when finished. I have plans to try and make a stand allown
set of classes which can be used for level generation with the ability to use
your own maze generator.

##Game play
A wizard will display on screen if start game is pushed, he can move around
and shoot magic missile. A grub appears which can be killed by the missile.


##Extras
It is now possible to run the game on a iPhone with an external monitor. A
very simple joy pad appears on the screen of the iphone which allows you
to move the wizard around the screen and attack the grub.

##Sprites
All sprite are made by me which is why the art is amateurish but hell
I wanted to give it a bash.
