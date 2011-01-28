require 'sdl'
require './src/conf'
require './src/engine/window'
require './src/engine/event'
require './src/engine/graphics/utils'
require './src/engine/graphics/texture'
require './src/engine/time'
require './src/engine/vector2d'

module Engine
	module AppState
		
		class StateMachine
			
			@states = {}
			@current_state = nil
			@home_state = nil
			@continue = true
			
			class << self
				
				def init(width, height)
					Engine::Window.open width, height
					Engine::Graphics.init width, height
					Engine::Key.disable_key_repeat
					Engine::Time.reset
					@background = Engine::Graphics::Texture.new "background.png"
				end
				
				def state=(state)
					@current_state.exit if @current_state
					@states[state] = state.new unless @states[state]
					@home_state = state unless @home_state
					@current_state = @states[state]
					@current_state.enter
				end
				
				def state(state)
					@states[state]
				end
				
				def handle_event
					event = Engine::Event.poll
					if event.is_a? Engine::Event::Quit
						stop
					elsif event.is_a? Engine::Event::KeyDown and event.sym == Engine::Key::ESCAPE
						if @current_state == @states[@home_state]
							stop
						else
							self.state = @home_state
						end
					end
					@current_state.handle_event event
					event
				end
				
				def display
					Engine::Graphics.begin_drawing
					display_background
					@current_state.display
					Engine::Graphics.end_drawing
				end
				
				def display_background
					position = Engine::Vector2d.new Conf::WIDTH / 2, Conf::HEIGHT / 2
					dimensions = Engine::Vector2d.new Conf::WIDTH, Conf::HEIGHT
					@background.display position, nil, nil, dimensions
				end
				
				def loop
					while self.continue
						t1 = Engine::Time.real_time
						while self.handle_event; end
						self.display
						t2 = Engine::Time.real_time
						t3 = t2 - t1
						if t3 < Conf::MAXLOOPDURATION
							Engine::Time.delay Conf::MAXLOOPDURATION - t3
						end
					end
				end
				
				def stop
					@continue = false
				end
				
				def continue
					@continue
				end
			
			end
			
		end
		
	end
end
