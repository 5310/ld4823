-- Returns the distance between two points. --
function distance( _x1, _y1, _x2, _y2 )
	return ( ( _x1 - _x2 ) ^ 2 + ( _y1 - _y2 ) ^ 2 ) ^ 0.5
end

-- Returns the angle between two / three points given a separate fulcrum. --
function angle2( _xOld, _yOld, _xNew, _yNew)
	return norm_angle ( - math.atan2( ( _xOld - _xNew ), ( _yOld - _yNew ) ) )
end
function angle3( _xOld, _yOld, _xNew, _yNew, _xF, _yF )
	aOld = math.atan2( ( _xOld - _xF ), ( _yOld - _yF ) )
	aNew = math.atan2( ( _xNew - _xF ), ( _yNew - _yF ) )
	return norm_angle ( aNew - aOld )
end

-- Normalizes an angle in radians.
function norm_angle( _a )
	while _a < 0 do
		_a = _a + math.pi*2
	end
	while _a > math.pi*2 do
		_a = _a - math.pi*2
	end
	return _a
end

-- Calculates absolute difference between angles.
function diff_angles( _a, _b )
	return norm_angle( math.abs( _a - _b ) )
end

function deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, _copy(getmetatable(object)))
    end
    return _copy(object)
end
