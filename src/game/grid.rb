require './src/conf'
require './src/engine/appstate/statemachine'
require './src/engine/time'
require './src/engine/random'
require './src/engine/graphics/texture'
require './src/engine/graphics/string'
require './src/engine/graphics/color'
require './src/engine/vector2d'

require './src/game/appstate/completed'

module Game
	
	class Grid
		
		@@digits = []
		@@states = {}
		
		def initialize(width, height = 0)
			@num_moves = 0
			@begin_time = Engine::Time.time
			if width.is_a? Integer and height.is_a? Integer and height > 0
				@width = width
				@height = height
				generate_grid
			else
				image = width
				@texture = Engine::Graphics::Texture.new image
				generate_grid_from_texture
			end
			calc_digits
			load_textures
		end
		
		def duration
			Engine::Time.time - @begin_time
		end
		
		def num_moves
			@num_moves
		end
		
		def display
			(0...@width).each do |x|
				(0...@height).each do |y|
					pos = cell_pos Engine::Vector2d.new x, y
					@@states[@game_grid[y][x]].display pos
				end
			end
			
			x = 0
			@cols.each do |col|
				y = -1
				col.reverse.each do |cell|
					pos = cell_pos(Engine::Vector2d.new x, y)
					@@digits[cell].display pos
					y -= 1
				end
				x += 1
			end
			
			y = 0
			@lines.each do |line|
				x = -1
				line.reverse.each do |cell|
					pos = cell_pos(Engine::Vector2d.new x, y)
					@@digits[cell].display pos
					x -= 1
				end
				y += 1
			end
		end
		
		def display_completed(elapsed_time)
			progress = elapsed_time / 2
			progress = 1 if progress > 1
			(0...@width).each do |x|
				(0...@height).each do |y|
					pos = cell_pos Engine::Vector2d.new x, y
					color = @texture[x, y]
					color.set_all {|v| 255 - (255 - v) * progress }
					@@states[@game_grid[y][x]].display pos, nil, color
				end
			end
		end
		
		def from_texture?
			@texture != nil
		end
		
		def dbg
			each_line do |line|
				line.each do |cell|
					if cell
						print 1
					else
						print 0
					end
				end
				puts
			end
			
			puts @lines.to_s
			puts @cols.to_s
		end
		
		def button_event(event)
			cell = cell_coord event
			if toggle_cell cell
				Engine::AppState::StateMachine.state = Game::AppState::Completed
			end
		end
		
		private
		
		def toggle_cell(coord)
			if 0 <= coord.x and coord.x < @width and 0 <= coord.y and coord.y < @height
				@game_grid[coord.y][coord.x] = !@game_grid[coord.y][coord.x]
				@num_moves += 1
				@grid == @game_grid
			else
				false
			end
		end
		
		def load_textures
			unless @@digits.size > 0 and @@states.size > 0
				black = Engine::Graphics::Color.new 0, 0, 0
				@@digits = Array.new([@width, @height].max + 1) do |i|
					Engine::Graphics::String.new i.to_s, "MgOpenModataBold.ttf", 20, black if i > 0
				end
				@@states = {}
				@@states[false] = Engine::Graphics::Texture.new "empty.png"
				@@states[true] = Engine::Graphics::Texture.new "full.png"
			end
		end
		
		CELLSIZE = 20
		
		def cell_pos(coord)
			center_x = Conf::WIDTH / 2
			center_y = Conf::HEIGHT / 2
			Engine::Vector2d.new center_x + (coord.x - (@width - 1) / 2.0) * CELLSIZE, center_y + (coord.y - (@height - 1) / 2.0) * CELLSIZE
		end
		
		def cell_coord(pos)
			center_x = Conf::WIDTH / 2
			center_y = Conf::HEIGHT / 2
			coord = Engine::Vector2d.new (pos.x - center_x) / CELLSIZE.to_f + (@width - 1) / 2.0, (pos.y - center_y) / CELLSIZE.to_f + (@height - 1) / 2.0
			coord.x = coord.x.round
			coord.y = coord.y.round
			coord
		end
		
		def generate_grid
			@game_grid = Array.new(@height) { Array.new @width, false }
			@grid = Array.new(@height) { Array.new @width, true }
			y = 0
			@grid.each do |line|
				x = 0
				line.each do
					@grid[y][x] = false if Engine::Random.int(0, 2) == 0
					x += 1
				end
				y += 1
			end
		end
		
		def generate_grid_from_texture
			@width = @texture.width
			@height = @texture.height
			@game_grid = Array.new(@height) { Array.new @width, false }
			@grid = Array.new(@height) { Array.new @width, false }
			y = 0
			@grid.each do |line|
				x = 0
				line.each do
					@grid[y][x] = true if @texture[x, y].a == 255
					x += 1
				end
				y += 1
			end
		end
		
		def calc_digits
			calc_cols_digits
			calc_lines_digits
		end
		
		def calc_lines_digits
			@lines = []
			each_line do |line, i|
				@lines[i] = []
				last_cell = false
				j = -1
				line.each do |cell|
					if cell != last_cell and cell
						j += 1
						@lines[i][j] = 0
					end
					@lines[i][j] += 1 if cell
					last_cell = cell
				end
			end
		end
		
		def calc_cols_digits
			@cols = []
			each_col do |col, i|
				@cols[i] = []
				last_cell = false
				j = -1
				col.each do |cell|
					if cell != last_cell and cell
						j += 1
						@cols[i][j] = 0
					end
					@cols[i][j] += 1 if cell
					last_cell = cell
				end
			end
		end
		
		def each_line
			i = 0
			@grid.each do |line|
				yield line, i
				i += 1
			end
		end
		
		def each_col
			i = 0
			while i < @width
				col = []
				j = 0
				while j < @height
					col[j] = @grid[j][i]
					j += 1
				end
				yield col, i
				i += 1
			end
		end
		
	end
	
end
