require 'sdl'

module Engine
	module Time
		
		@reset_time = 0.0
		@pause_enabled = false
		@pause_time = 0.0
		@pause_real_time = 0.0
		@pause_elapsed_time = 0.0
		
		class << self
			
			def reset
				@reset_time = SDL.getTicks
				@pause_elapsed_time = 0.0
			end
			
			def real_time
				(SDL.getTicks - @reset_time) / 1000.0
			end
			
			def time
				if @pause_enabled
					@pause_time
				else
					self.real_time - @pause_elapsed_time
				end
			end
			
			def pause
				unless @pause_enabled
					@pause_time = self.time
					@pause_real_time = self.real_time
					@pause_enabled = true
				end
			end
			
			def resume
				@pause_enabled = false
				@pause_elapsed_time += self.real_time - @pause_real_time
			end
			
			def paused
				@pause_enabled
			end
			
			def delay(duration)
				SDL.delay duration * 1000
			end
			
		end
		
	end
end
