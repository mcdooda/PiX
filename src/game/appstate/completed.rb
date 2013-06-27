require './src/conf'
require './src/engine/event'
require './src/engine/appstate/state'
require './src/engine/appstate/statemachine'
require './src/engine/graphics/string'
require './src/engine/vector2d'
require './src/engine/time'

require './src/game/appstate/grid'

module Game
	module AppState
		
		class Completed < Engine::AppState::State
				
				def enter
					game = Engine::AppState::StateMachine
					grid_state = game.state Game::AppState::Grid
					if grid_state.from_texture?
						@completed_grid = grid_state.grid
					else
						@completed_grid = nil
					end
					
					num_moves = grid_state.num_moves
					duration = grid_state.duration
					
					black = Engine::Graphics::Color.new 0, 0, 0
					
					@text1 = Engine::Graphics::String.new "Grid completed", "MgOpenModataBold.ttf", 20, black
					@text2 = Engine::Graphics::String.new "in "+duration.round(2).to_s+"s", "MgOpenModataBold.ttf", 20, black
					@text3 = Engine::Graphics::String.new "with "+num_moves.to_s+" moves", "MgOpenModataBold.ttf", 20, black
					
					@begin_time = Engine::Time.time
				end
				
				def display
					unless @completed_grid.nil?
						@completed_grid.display_completed Engine::Time.time - @begin_time
						text_pos = Engine::Vector2d.new Conf::WIDTH / 2, 15
					else
						text_pos = Engine::Vector2d.new Conf::WIDTH / 2, Conf::HEIGHT / 2 - 20
					end
					@text1.display text_pos
					text_pos.y += 20
					@text2.display text_pos
					text_pos.y += 20
					@text3.display text_pos
				end
				
				def handle_event(event)
					if event.is_a? Engine::Event::KeyDown and event.sym == Engine::Key::RETURN
						Engine::AppState::StateMachine.state = Game::AppState::Grid
					end
				end
			
		end
		
	end
end
