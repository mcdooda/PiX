require './src/engine/event'
require './src/engine/appstate/state'
require './src/engine/appstate/statemachine'
require './src/engine/graphics/texture'

require './src/game/menu'
require './src/game/appstate/grid'

module Game
	module AppState
		
		class Menu < Engine::AppState::State
				
				def initialize
					@menu1 = Game::Menu.new [
						Game::MenuStringButton.new("Play", 40) {
							@current_menu = @menu2
						},
						Game::MenuStringButton.new("Quit", 40) {
							Engine::AppState::StateMachine.stop
						}
					]
					@menu2 = Game::Menu.new [
						Game::MenuStringButton.new("Random grid", 40) {
							Engine::AppState::StateMachine.state = Game::AppState::Grid
							Game::AppState::Grid.mode = :random_grid
						},
						Game::MenuStringButton.new("Pictures", 40) {
							Engine::AppState::StateMachine.state = Game::AppState::Grid
							Game::AppState::Grid.mode = :texture_grid
						}
					]
				end
				
				def enter
					@current_menu = @menu1
				end
				
				def display
					@current_menu.display
				end
				
				def handle_event(event)
					if event.is_a? Engine::Event::KeyDown
						case event.sym
						when Engine::Key::P
							if Engine::Time.paused
								Engine::Time.resume
							else
								Engine::Time.pause
							end
						end
					end
					@current_menu.handle_event event
				end
			
		end
		
	end
end
