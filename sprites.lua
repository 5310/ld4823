-- Sprite-sheets. --

sprites = {}

sprites.planets = {
	love.graphics.newImage( "planet_grass.png" )
}

sprites.pieces = {
	{ 
		love.graphics.newImage( "piece_tree_1.png" ),
		love.graphics.newImage( "piece_tree_2.png" ),
		love.graphics.newImage( "piece_tree_3.png" ),
		love.graphics.newImage( "piece_tree_4.png" ),
		love.graphics.newImage( "piece_tree_5.png" ),
		love.graphics.newImage( "piece_tree_6.png" ),
	},
}

sprites.empty = love.graphics.newImage( "empty.png" )
sprites.aura = love.graphics.newImage( "aura.png" )
sprites.arrow = love.graphics.newImage( "arrow.png" )
