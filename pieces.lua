-- The Pieces class. --

Piece = {}
Piece.__index = Piece

function Piece.create( _a )														--TODO Modify to accept set.

	-- Fake a class.
	local self = {}
	setmetatable(self, Piece)
	
	-- Placement:
	self.a = _a
	self.h = 1
	
	-- Look and feel.                                                       	--TODO Randomize within set.
	self.sprite = sprites.empty												
	self.set = ""
	
	
	-- Return object.
	return self
	
end

function Piece:draw( _x, _y, _r, _a )

	sprite = self.sprite
	love.graphics.draw( 
		sprite,              
		_x, _y,
		_a + self.a,                   
		1, self.h,                                   
		sprite:getWidth()/2, sprite:getHeight() + _r/self.h - 2
	)
	
end


-- Function to randomly populate Planets with Pieces within a set of sets.		--TODO Modify to accept set ot sets.
function pieces_create( _n )

	local pieces = {}
	
	for i = 1, _n do
		p = Piece.create( (math.pi*2)/_n*i )
		if math.random(0, 1) >= 0.25 then										--DEBUG 0, 1
			p.sprite = sprites.pieces[1][math.random(#sprites.pieces[1])]
			p.set = 'trees'
		end
		table.insert(pieces, p)
	end
	
	return pieces	
	
end
