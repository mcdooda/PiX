require './src/engine/event'
require './src/engine/random'
require './src/engine/appstate/state'
require './src/engine/appstate/statemachine'

require './src/game/grid'

module Game
	module AppState
		
		class Grid < Engine::AppState::State
			
			def enter
				generate_grid if @mode
			end
			
			def mode=(mode)
				@mode = mode
				generate_grid
			end
			
			def display
				@grid.display
			end
			
			def handle_event(event)
				if event.is_a? Engine::Event::MouseButtonDown and event.button == Engine::Mouse::BUTTON_LEFT
					@grid.button_event event
				elsif event.is_a? Engine::Event::KeyDown and event.sym == Engine::Key::RETURN
					generate_grid
				end
			end
			
			def duration
				@grid.duration
			end
			
			def num_moves
				@grid.num_moves
			end
			
			def from_texture?
				@grid.from_texture?
			end
			
			def grid
				@grid
			end
			
			private
			
			def generate_grid
				case @mode
				when :random_grid
					width = Engine::Random.int 5, 7
					height = Engine::Random.int 5, 7
					@grid = Game::Grid.new width, height
				when :texture_grid
					grids = Dir["resources/images/grids/*.png"]
					random_texture_grid = grids[Engine::Random.int 0, grids.size - 1]
					random_texture_grid = "grids/"+random_texture_grid.split("/").last
					@grid = Game::Grid.new random_texture_grid
				else
					raise "Unknown mode #{@mode}"
				end
			end
			
		end
		
	end
end
