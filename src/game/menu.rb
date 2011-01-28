require './src/conf'
require './src/engine/graphics/texture'
require './src/engine/graphics/string'
require './src/engine/graphics/color'
require './src/engine/time'
require './src/engine/event'
require './src/engine/vector2d'

module Game
	
	class MenuButton < Engine::Graphics::Texture
		
		def initialize(filename, &action)
			super filename
			@action = action
		end
		
		def trigger_action
			@action.call
		end
		
	end
	
	class MenuStringButton < Engine::Graphics::String
		
		def initialize(string, size, &action)
			black = Engine::Graphics::Color.new 0, 0, 0
			super string, "MgOpenModataBold.ttf", size, black
			@action = action
		end
		
		def trigger_action
			@action.call
		end
		
	end
	
	class Menu
		
		MARGIN = 20
		
		def initialize(buttons)
			@buttons = buttons
			@current_button = -1
			@begin_animation = 0
			
			@height = (@buttons.size - 1) * MARGIN
			@buttons.each do |button|
				@height += button.height
			end
		end
		
		def display
			each_button do |button, i, pos|
				if @current_button == i
					button_pos = pos.dup
					button_pos.y += 5 * Math.sin((Engine::Time.time - @begin_animation) * 10)
					br = 5 * Math.sin((Engine::Time.time - @begin_animation) * 5)
					button.display button_pos, br
				else
					button.display pos, 0
				end
			end
		end
		
		def handle_event(event)
			if event.is_a? Engine::Event::MouseMotion or event.is_a? Engine::Event::MouseButtonDown
				motion_event event
			end
			if event.is_a? Engine::Event::MouseButtonDown and event.button == Engine::Mouse::BUTTON_LEFT
				trigger_button_action
			end
			if event.is_a? Engine::Event::KeyDown
				keydown_event event
			end
		end
		
		private
		
		def each_button(&proc)
			pos = Engine::Vector2d.new Conf::WIDTH / 2, Conf::HEIGHT / 2 - @height / 2 + @buttons[0].height / 2
			i = 0
			@buttons.each do |button|
				proc.call(button, i, pos)
				pos.y += button.height
				i += 1
			end
		end
		
		def motion_event(mouse)
			current_button = -1
			each_button do |button, i, pos|
				width = button.width
				height = button.height
				current_button = i if button.over?(pos, mouse)
			end
			
			if @current_button != current_button
				@current_button = current_button
				@begin_animation = Engine::Time.time
			end
		end
		
		def keydown_event(key)
			case key.sym
			when Engine::Key::RETURN
				trigger_button_action
			when Engine::Key::UP
				@current_button -= 1
				@current_button = @buttons.size - 1 if @current_button < 0
			when Engine::Key::DOWN
				@current_button += 1
				@current_button = 0 if @current_button > @buttons.size - 1
			end
		end
		
		def trigger_button_action
			if @current_button != -1
				@buttons[@current_button].trigger_action
				@current_button = -1
			end
		end
		
	end
	
end
