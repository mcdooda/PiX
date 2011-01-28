require 'sdl'

require './src/conf'

module Engine
	module Window
		
		def self.open(width, height)
			SDL.init SDL::INIT_VIDEO
			SDL.setVideoMode width, height, 32, SDL::OPENGL
			SDL::WM.set_caption Conf::APPNAME, Conf::APPNAME
		end
		
	end
end
