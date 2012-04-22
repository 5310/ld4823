require( 'utility' )
require( 'world' )
require( 'planets' )
require( 'pieces' )
require( 'sprites' )
require( 'content' )


function love.load()

    ---------
    --setup--
    ---------
    
    width = 800
    height = 450
    fullscreen = false
    love.graphics.setMode( width, height, fullscreen )
    love.graphics.setBackgroundColor( 10, 10, 10 )      

    --------------
    --initialize--
    --------------

    generate_level()
    
    log = "asd"
    
end



function love.update(dt)

    world:update(dt)
    planets_update(dt)
    
end



function love.draw()
    
    planets_draw()
    
end




