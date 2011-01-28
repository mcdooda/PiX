require 'gl'; include Gl

module Engine
	module Graphics
		
		class Color
			
			attr_accessor :r, :g, :b, :a
			
			def initialize(r, g, b, a = 255)
				@r = r
				@g = g
				@b = b
				@a = a
			end
			
			def to_s
				"(#{@r},#{@g.to_s},#{@b.to_s},#{@a.to_s})"
			end
			
			def use_gl_color
				glColor4ub @r, @g, @b, @a
			end
			
			def set_all
				@r = yield @r, :r
				@g = yield @g, :g
				@b = yield @b, :b
				@a = yield @a, :a
			end
			
		end
		
	end
end
