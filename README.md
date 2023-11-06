# 3 different ways to move a sprite

Each folder of this project contains a different method to move a sprite.

1. __The tile by tile method :__ the animated sprite jump from one tile to another, as if it was teleporting (TRVE 8-bit retro effect)

2. __The tile by pixel method :__ more elaborate than the previous method, the movement of the sprite is continuous between the tiles, but the sprite position is always at the center of a tile

3. __The pixel by pixel method :__ the sprite can be controlled and therefore positionned by one pixel precision. Collision tests get more complicated.

## Launch demos :

Demos uses [Löve2D](https://love2d.org/).

Tile by tile method :

```
make TxT
```

Tile by pixel method :

```
make TxP
```

Pixel by pixel method :

```
make PxP
```

Animated sprite generated with [Universal LPC spritesheet generator](https://sanderfrenken.github.io/Universal-LPC-Spritesheet-Character-Generator/)
