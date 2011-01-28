require './src/engine/appstate/statemachine'

module Engine
	module AppState
		
		class State
			
			def enter
				
			end
			
			def exit
				
			end
			
			def handle_event(event)
				
			end
			
			def display
				
			end
			
			def self.method_missing(method, *params)
				StateMachine.state(self).method(method).call(*params)
			end
			
		end
		
	end
end
