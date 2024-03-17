#ifndef __GAME_MAINLOOP__
#define __GAME_MAINLOOP__

type MainLoop extends GameLoop
  public:
    declare constructor()
    declare constructor( as double, as double )
    declare destructor() override
    
    declare sub onUpdate( as double ) override
    declare sub onRender( as double ) override
  
  private:
    as MouseInput _mouse
end type

constructor MainLoop()
  base( 60.0f, 0.1f )
end constructor

constructor MainLoop( tps as double, dT as double )
  base( tps, dT )
end constructor

destructor MainLoop()
end destructor

sub MainLoop.onUpdate( dT as double )
  if( len( inkey() ) ) then
    finish()
  end if
end sub

sub MainLoop.onRender( lerp as double )
  screenLock()
    cls()
    ? "Render: " & lerp
  screenUnlock()
end sub

#endif
