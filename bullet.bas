#include once "fb-game/fb-game.bi"

#ifndef G_NULL
  #define G_NULL 0
#endif

using FbGame

function rngVecNormal() as Vec2
  return( Vec2( rng( -1.0, 1.0 ), rng( -1.0, 1.0 ) ).normalized() )
end function

'' Max bullets per manager
const as long MAX_BULLETS = 1000

type as sub( as any ptr, as any ptr, as double ) bulletModFunc
type as sub( as any ptr, as any ptr, as any ptr, as double ) bulletEmitFunc

type Bounds
  as long w, h
end type

type Player
  as Vec2 pos
  as single r
end type

type Bullet
  as Vec2 pos, vel, acc
  as single r
  as long lifeTime
end type

type BulletManager
  declare constructor( as long )
  declare destructor()
  
  as Bullet b( any )
  as bulletModFunc mods( any )
  
  as long count, size
end type

constructor BulletManager( s as long )
  size = s
  redim b( 0 to size - 1 )
end constructor

destructor BulletManager() : end destructor

type BulletEmitParams
  as bulletEmitFunc emitFunc
  as BulletManager ptr manager
  as double lastEmit, freq
end type

type BulletEmitter
  declare destructor()
  
  declare sub emit( as any ptr, as double )
  declare sub add( as BulletEmitFunc, as BulletManager ptr, as double )
  
  as Vec2 pos, dir
  as BulletEmitParams params( any )
end type

destructor BulletEmitter() : end destructor

sub BulletEmitter.add( emitFunc as BulletEmitFunc, bm as BulletManager ptr, freq as double )
  redim preserve params( 0 to ubound( params ) + 1 )
  
  with params( ubound( params ) )
    .emitFunc = emitFunc
    .manager = bm
    .freq = freq
    .lastEmit = timer()
  end with
end sub

sub BulletEmitter.emit( ctx as any ptr, dt as double )
  for i as integer = 0 to ubound( params )
    dim as double elapsed = timer() - params( i ).lastEmit
    
    if( elapsed >= params( i ).freq ) then
      params( i ).emitFunc( @this, ctx, @params( i ), dt )
      params( i ).lastEmit = timer()
    end if
  next
end sub

sub addModFunc( bm as BulletManager, f as bulletModFunc )
  redim preserve bm.mods( 0 to ubound( bm.mods ) + 1 )
  bm.mods( ubound( bm.mods ) ) = f
end sub

function addBullet( bm as BulletManager ) byref as Bullet
  if( bm.count < bm.size ) then
    bm.count += 1
  end if
  
  return( bm.b( bm.count - 1 ) )
end function

sub removeBullet( bm as BulletManager, idx as integer )
  bm.b( idx ) = bm.b( bm.count - 1 )
  bm.count -= 1
end sub

sub emit_linear( owner as any ptr, ctx as any ptr, p as any ptr, dt as double )
  var e = cast( BulletEmitter ptr, owner )
  
  with addBullet( *cast( BulletEmitParams ptr, p )->manager )
    .pos = e->pos
    .vel = e->dir * 350
    .r = 3
  end with
end sub

sub emit_circular( owner as any ptr, ctx as any ptr, p as any ptr, dt as double )
  var e = cast( BulletEmitter ptr, owner )
  var d = e->dir
  dim as long num = 5
  dim as single ang = 360.0 / num
  
  for i as integer = 1 to num
    with addBullet( *cast( BulletEmitParams ptr, p )->manager )
      .pos = e->pos
      .vel = d * 200
      .r = 4
    end with
    
    d.rotate( rad( ang ) )
  next
end sub

function outside( p as Vec2, b as Bounds ) as boolean
  return( p.x < 0 orElse p.y < 0 orElse p.x > b.w - 1 orElse p.y > b.h - 1 )
end function

sub update overload( ctx as any ptr, bm as BulletManager, dt as double = 0.1 )
  var bounds = cast( Bounds ptr, ctx )
  
  for i as integer = 0 to ubound( bm.mods )
    bm.mods( i )( ctx, @bm, dt )
  next
  
  for i as integer = 0 to bm.count - 1
    bm.b( i ).lifeTime -= 1
  next
  
  dim as long c = 0
  
  do while( c < bm.count )
    if( outside( bm.b( c ).pos, *bounds ) ) then
      removeBullet( bm, c )
    end if
    
    c += 1
  loop
end sub

sub mod_move( ctx as any ptr, bm as any ptr, dt as double )
  var cbm = cast( BulletManager ptr, bm )
  
  for i as integer = 0 to cbm->count - 1
    cbm->b( i ).pos += cbm->b( i ).vel * dt
  next
end sub

function collide( p1 as Vec2, r1 as single, p2 as Vec2, r2 as single ) as boolean
  return( ( p1.x - p2.x ) ^ 2 + ( p1.y - p2.y ) ^ 2 < ( r1 + r2 ) ^ 2 )
end function

sub render overload( p as Player, c as ulong )
  circle( p.pos.x, p.pos.y ), p.r, c, , , , f
end sub

sub render( bm as BulletManager, c as ulong )
  for i as integer = 0 to bm.count - 1
    circle( bm.b( i ).pos.x, bm.b( i ).pos.y ), bm.b( i ).r, c, , , , f
  next
end sub

sub render( e as BulletEmitter, c as ulong )
  circle( e.pos.x, e.pos.y ), 10, c
  circle( e.pos.x, e.pos.y ), 6, c, , , , f
  line( e.pos.x, e.pos.y ) - ( e.pos.x + e.dir.x * 20, e.pos.y + e.dir.y * 20 ), c
end sub

function createBm( ctx as any ptr, num as long ) as BulletManager
  var bounds = cast( Bounds ptr, ctx )
  var bm = BulletManager( MAX_BULLETS )
  
  for i as integer = 0 to num - 1
    with addBullet( bm )
      .pos = Vec2( rng( 0, bounds->w ), rng( 0, bounds->h ) )
      .vel = rngVecNormal() * 10
      .r = 4
      .lifeTime = 10000
    end with
  next
  
  addModFunc( bm, @mod_move )
  
  return( bm )
end function

var scrBounds = type <Bounds>( 800, 600 )

screenRes( scrBounds.w, scrBounds.h, 32, 2 )
screenSet( 0, 1 )

dim as Player p

with p
  .pos = Vec2( 400, 300 )
  .r = 5
end with

dim as long mx, my, mb
dim as double dt

var bm = BulletManager( 500 )

addModFunc( bm, @mod_move )

var e = BulletEmitter()

with e
  .pos = Vec2( scrBounds.w * 0.5, scrBounds.h * 0.5 )
  .add( @emit_circular, @bm, 0.15 )
  .add( @emit_linear, @bm, 0.25 )
end with

do  
  dim as long result = getMouse( mx, my, , mb )
  
  e.dir = ( Vec2( mx, my ) - e.pos ).normalize()
  
  if( result = 0 andAlso mb and Fb.BUTTON_LEFT ) then
    e.emit( G_NULL, dt )
  end if
  
  p.pos = Vec2( mx, my )
  
  update( @scrBounds, bm, dt )
  
  dt = timer()
    cls()
    
    render( bm, rgb( 255, 255, 255 ) )
    render( e, rgb( 0, 255, 255 ) )
    
    ? bm.count
    
    flip()
    sleep( 1, 1 )
  dt = timer() - dt
loop until( len( inkey() ) )
