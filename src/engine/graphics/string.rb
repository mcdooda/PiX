require 'sdl'
require 'gl'; include Gl

require './src/engine/graphics/texture'

module Engine
	module Graphics
		
		class String < Texture
			
			def initialize(string, filename, size, color)
				font = get_font filename, size
				surface = font.render_blended_utf8 string, color.r, color.g, color.b
				@id, = glGenTextures 1
				glBindTexture GL_TEXTURE_2D, @id
				glTexImage2D GL_TEXTURE_2D, 0, surface.format.bpp / 8, surface.w, surface.h, 0, GL_RGBA, GL_UNSIGNED_BYTE, surface.pixels
				glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR
				@width = surface.w
				@height = surface.h
				surface.destroy
			end
			
			private
			
			@@fonts = {}
			
			def get_font(filename, size)
				params = [filename, size]
				unless @@fonts.key? params
					@@fonts[params] = SDL::TTF.open "resources/fonts/"+filename, size
				end
				@@fonts[params]
			end
			
		end
		
	end
end
