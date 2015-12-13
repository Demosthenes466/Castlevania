
require_relative "belmont"

class Ghoul
	attr_accessor :y, :x

	def initialize(x, y)
		@x = x
		@y = y
	end

	def forward
		@x += 1
	end

	def backward 
		@x -= 1
	end

	
	
	def draw(pic)
		pic.draw(@x, @y, 1)
	end

end
