-- A Brave 0.8.0 World. --
world = love.physics.newWorld()

function beginContact(a, b, c)
end

function endContact(a, b, c)

	avx, avy = a:getBody():getLinearVelocity()
	bvx, bvy = b:getBody():getLinearVelocity()
	v = distance ( avx, avy, bvx, bvy )
	
	function f( _a, _b )
		n = diff_angles( 
				norm_angle ( angle2( 
					_a:getBody():getX(), _a:getBody():getY(), 
					_b:getBody():getX(), _b:getBody():getY()
				) ),  
				_a:getBody():getAngle()
			)
		r = 0	
		for i, v in pairs( _a:getUserData().pieces ) do
			if diff_angles(
				norm_angle( _a:getBody():getAngle()/2 + v.a ), 					--TODO Make this work with the physics-body's angle
				norm_angle( n + _a:getBody():getAngle()/2)
			) <= math.rad(30) then
				r = i
			end
		end
		return r 
	end
	-- If collision is sufficiently strong.
	if v >= 50 then  	                                                  		--TEST Some tweaking to ensure the slightest touch doesn't do anything?
		a:getUserData().wait = 0
		b:getUserData().wait = 0
		-- Move selection.                                                      
		if a:getUserData().selected then
			a:getUserData().selected = false
			b:getUserData().selected = true
		elseif b:getUserData().selected then
			a:getUserData().selected = true
			b:getUserData().selected = false
			
		end
			
		-- Switch Pieces.
		ai = f(a,b)
		bi = f(b,a)
		if ai > 0 and bi > 0 then
			av = deepcopy(a:getUserData().pieces[ai])
			bv = deepcopy(b:getUserData().pieces[bi])
			
			aa = deepcopy(av.a)
			ba = deepcopy(bv.a)
			
			av.a = ba
			bv.a = aa
			
			a:getUserData().pieces[ai] = bv
			b:getUserData().pieces[bi] = av
		end

		-- Some special effects, please.                                    	--TODO
	
	end
		
end

function preSolve(a, b, c)
end

function postSolve(a, b, c)
end

world:setCallbacks( beginContact, endContact, preSolve, postSolve )
