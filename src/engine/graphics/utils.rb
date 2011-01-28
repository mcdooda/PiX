require 'sdl'
require 'gl'; include Gl
require 'glu'; include Glu

module Engine
	module Graphics
		
		def self.init(width, height)
			# init GL
			glMatrixMode GL_PROJECTION
			glLoadIdentity
			gluOrtho2D 0, width, 0, height
			
			glMatrixMode GL_MODELVIEW
			glLoadIdentity
			
			glClearColor 1, 1, 1, 0
			glColor3ub 255, 255, 255
			
			glEnable GL_TEXTURE_2D
			glEnable GL_BLEND
			glBlendFunc GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA
			
			# init SDL ttf
			SDL::TTF.init unless SDL::TTF.init?
		end
	
		def self.begin_drawing
			glClear GL_COLOR_BUFFER_BIT
		end
	
		def self.end_drawing
			glFlush
			SDL::GL.swapBuffers
		end
		
	end
end
