#ifndef __GAME_BULLETS__
#define __GAME_BULLETS__

type Bullet
  declare constructor()
  declare constructor( as Vec2, as single )
  
  as Vec2 oldPos, pos, vel, acc
  as single r
end type

constructor Bullet()
  constructor( Vec2.zero(), 1.0f )
end constructor

constructor Bullet( aPos as Vec2, aRadius as single )
  pos = aPos : oldPos = pos: r = aRadius
end constructor

#endif
