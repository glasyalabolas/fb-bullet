#ifndef __GAME_BULLETS__
#define __GAME_BULLETS__

type Bullets
  declare constructor()
  declare constructor( as integer )
  
  declare property count() as integer
  declare function size() as integer
  
  as Bullet bullets( any )
  as integer _count
end type

function Bullets.size() as integer
  return( ( ubound( bullets ) - lbound( bullets ) ) + 1 )
end function

property Bullets.count() as integer
  return( _count )
end property

constructor Bullets()
  constructor( 256 )
end constructor

constructor Bullets( n as integer )
  redim bullets( 0 to n - 1 )
end constructor

#endif
