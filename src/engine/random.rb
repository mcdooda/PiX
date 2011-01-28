module Engine
	module Random
		
		class << self
			
			def int(min, max)
				rand(max - min + 1) + min
			end
			
			def float(min, max)
				rand * (max - min) + min
			end
			
		end
		
	end
end
