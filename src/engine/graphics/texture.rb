require 'sdl'
require 'gl'; include Gl

require './src/conf'
require './src/engine/vector2d'
require './src/engine/graphics/color'

module Engine
	module Graphics
		
		class Texture
			
			attr :width, :height
			
			def initialize(filename)
				@surface = get_texture filename
				@id, = glGenTextures 1
				glBindTexture GL_TEXTURE_2D, @id
				glTexImage2D GL_TEXTURE_2D, 0, @surface.format.bpp / 8, @surface.w, @surface.h, 0, GL_RGBA, GL_UNSIGNED_BYTE, @surface.pixels
				glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR
				@width = @surface.w
				@height = @surface.h
			end
			
			def display(pos, rotation = 0, color = nil, dimensions = nil)
				color.use_gl_color if color
				glPushMatrix
				glTranslated pos.x, Conf::HEIGHT - pos.y, 0
				glRotated rotation, 0, 0, 1
				glBindTexture GL_TEXTURE_2D, @id
				if dimensions
					width = dimensions.x
					height = dimensions.y
				else
					width = @width
					height = @height
				end
				glBegin GL_QUADS
					glTexCoord2i 0, 0
					glVertex2f -width / 2,  height / 2
					glTexCoord2i 0, 1
					glVertex2f -width / 2, -height / 2
					glTexCoord2i 1, 1
					glVertex2f  width / 2, -height / 2
					glTexCoord2i 1, 0
					glVertex2f  width / 2,  height / 2
				glEnd
				glPopMatrix
				Color.new(255, 255, 255).use_gl_color if color
			end
			
			def over?(texture_pos, pos)
				x_min = texture_pos.x - @width / 2
				x_max = x_min + @width
				y_min = texture_pos.y - @height / 2
				y_max = y_min + @height
				x_min <= pos.x && pos.x <= x_max && y_min <= pos.y && pos.y <= y_max
			end
			
			def [](x, y)
				color = @surface.format.get_rgba @surface[x, y]
				Engine::Graphics::Color.new *color
			end
			
			private
			
			@@textures = {}
			
			def get_texture(filename)
				unless @@textures.key? filename
					@@textures[filename] = SDL::Surface.load "resources/images/"+filename
				end
				@@textures[filename]
			end
			
		end
		
	end
end
