module Engine
	
	class Vector2d
		
		attr_accessor :x, :y
		
		def initialize(x, y)
			@x = x
			@y = y
		end
		
		def distance
			Math.sqrt @x * @x + @y * @y
		end
		
		def distance_squared
			@x * @x + @y * @y
		end
		
		def angle
			angle = Math.atan @y / @x
			angle += Math::PI if @x < 0
			angle
		end
		
		def normalize
			distance = self.distance
			Vector.new @x / distance, @y / distance
		rescue
			dup
		end
		
		def +(vector)
			Vector2d.new @x + vector.x, @y + vector.y
		end
		
		def -(vector)
			Vector2d.new @x - vector.x, @y - vector.y
		end
		
		def *(scalar)
			Vector2d.new @x * scalar, @y * scalar
		end
		
		def /(scalar)
			Vector2d.new @x / scalar, @y / scalar
		end
		
		def coerce(this, o)
			[this, o]
		end
		
		def to_s
			"(#{@x},#{@y})"
		end
		
	end
	
end
