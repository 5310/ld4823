-- The Planet class. --

Planet = {}
Planet.__index = Planet

function Planet.create(_x, _y, _lx, _ly)										--TODO Modify to accept set and set of sets.

	-- Fake a class.
	local self = {}
	setmetatable(self, Planet)
	
	-- States:
	
	self.selected = false
	self.wait = 0
	self.rotating = false
	self.aiming = false
	self.set = false
		
	-- Looks and feel:                                                      	
	self.sprite = sprites.planets[1]											                                       																
	self.r = 47
	
	-- Set up physics.
	
	self.body = love.physics.newBody( world, _x, _y, "dynamic" )    
	self.body:setAngularDamping( 0.5 )
	self.body:setLinearDamping( 1 )                                       		--TEST
	
	self.shape = love.physics.newCircleShape( self.r )
	
	self.fixture = love.physics.newFixture( self.body, self.shape, 0.5 )
	self.fixture:setRestitution(1.5 )                                      		--TEST
	self.fixture:setUserData( self )  -- Refs parent Planet for callbacks.
	
	self.body:setLinearVelocity( _lx, _ly )
	--self.body:setAngle( math.random(0, 2)*math.pi )  -- No random angle.

	-- Create table for eventual Pieces.
	self.pieces = pieces_create( 6 )											--TODO Modify to supply set of sets.
	
	-- Return the newly created Planet.
	return self
	
end

function Planet:update(dt)

	-- Toroidal space.
	
	r = self.shape:getRadius()
	x = self.body:getX()
	y = self.body:getY()
	
	if x < 0-r then
		self.body:setX( 800 + x + 2*r )
	elseif x > 800+r then
		self.body:setX( x - 800 - 2*r)
	end
	
	if y < 0-r then
		self.body:setY( 450 + y + 2*r)
	elseif y > 450+r then
		self.body:setY( y - 450 - 2*r)
	end
	
	--Temporarily turn of linear damping when out of screen.

	if x < 0-r or x > 800+r or y < 0-r or y > 450+r then
		self._damping = self.body:getLinearDamping()
	else
		if self._damping ~= nil then
			self.body:setLinearDamping( self._damping )
			self._damping = nil
		end
	end
	
	-- Normalize angle.
	self.body:setAngle( norm_angle( self.body:getAngle() ) )
	
	
	-- Increment wait.
	if self.selected then
		if self.wait <= 1 then
			self.wait = self.wait + dt
		else
			self.wait = 1
		end
	end
	
	-- Mouse interaction for selected planet.
	
	if self.selected and self.wait >= 1 then
	
		if love.mouse.isDown( "l" ) then
		
			-- Start rotating if clicked inside the planet.
			if distance( 
				love.mouse.getX(), love.mouse.getY(), 
				self.body:getX(), self.body:getY() 
			) <= self.shape:getRadius() or self.rotating then
				
				if self._mouse ~= nil then
					a = angle3( 
							self._mouse.x, self._mouse.y, 
							love.mouse.getX(), love.mouse.getY(), 
							self.body:getX(), self.body:getY() 
						)
					-- Rotation:
					self.body:setAngle( self.body:getAngle() - a )
					self.rotating = true
					mouse_engaged = true
				end
				
				self._mouse = { 
					x = love.mouse.getX(), 
					y = love.mouse.getY()
				}
				
			else
				self._mouse = nil
			end
			
			-- Start aiming if clicked outside the planet.
			if distance(
				love.mouse.getX(), love.mouse.getY(), 
				self.body:getX(), self.body:getY() 
			) >= self.shape:getRadius() 
			and not self.rotating then
				self.aiming = true
			end
			
		else
		
			self._mouse = nil
			self.rotating = false
			
			-- If mouse released during aiming, shoot!
			if self.aiming then
				f = 5
				-- Movement:
				self.body:applyLinearImpulse( 
					( love.mouse.getX() - self.body:getX() )*f, 
					( love.mouse.getY() - self.body:getY() )*f 
				)                                                           	-- Maybe add some particle effects here, too?
				self.aiming = false
			end
			
		end
	
	end
	
	-- Particle Effects from speed.                                         	--TODO
	
	-- Update pieces.                                                       	--TODO
	
	--self.body:setAngle( math.rad(0) )											--DEBUG remove after physics body rotation collision works
	
	-- Calculate if planet is a clean set.
	self.set = true
	self._set = ''
	for i, v in pairs(self.pieces) do
		if i == 1 then
			self._set = v.set
		else
			if v.set ~= self._set then
				self.set = false
			end
		end
	end
	self._set = nil
	
end

function Planet:draw()

	-- Aim-guide:
	if self.aiming and self.selected then
		love.graphics.setLine( 10, "smooth" )
		love.graphics.line( 
			self.body:getX(), self.body:getY(), 
			love.mouse.getX(), love.mouse.getY() 
		)
		sprite = sprites.arrow
		love.graphics.draw( 
			sprite,                           
			love.mouse.getX(), love.mouse.getY(),  
			angle2( 
				self.body:getX(), self.body:getY(), 
				love.mouse.getX(), love.mouse.getY() 
			),               
			1, 1,                                
			sprite:getWidth()/2, sprite:getHeight()/2                                
		)
	end
	
	-- Planet sprite:
	sprite = self.sprite
	love.graphics.draw( 
		sprite,              
		self.body:getX(), self.body:getY(),     
		self.body:getAngle(),                   
		1, 1,                                   
		sprite:getWidth()/2, sprite:getHeight()/2
	)
	
	-- Selection aura:
	if self.selected then
		sprite = sprites.aura
		love.graphics.draw( 
			sprite,                           
			self.body:getX(), self.body:getY(),  
			self.body:getAngle(),               
			self.wait, self.wait,                                
			sprite:getWidth()/2, sprite:getHeight()/2                                
		)
	end
	
	-- Pieces:
	for i, v in pairs(self.pieces) do
		v:draw( 
			self.body:getX(), self.body:getY(), 
			self.shape:getRadius(), 
			self.body:getAngle() 
		)
	end
	
	--love.graphics.print( 														--DEBUG
		--self.body:getAngle(), 
		--self.body:getX(), self.body:getY()+50 
	--)
end



-- The planet container. --

planets = {}

-- Creates and positions Planets randomly given a set of sets.												
function planets_create( _number )												--TODO Modify to accept set of sets, and make planets from that alone.
	for i = 1, _number do
		x = math.random(20, 800-20)
		y = math.random(20, 450-20)
		lx = 0 --math.random(-20, 20)
		ly = 0 --math.random(-20, 20)
		p = Planet.create(x, y, lx, ly)
		table.insert(planets, p)
	end 
	planets[1].selected = true
end

-- Loop for updating planets.
function planets_update(dt)
	won = true
	for i, v in pairs(planets) do
		v:update(dt)
		if v.set == false then
			won = false
		end
	end
	if won then
		love.graphics.print("won", 10, 10)
	end
end

-- Loop for drawing planets.
function planets_draw()
	for i, v in pairs(planets) do
		v:draw()
	end
end
