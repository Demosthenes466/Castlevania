
class Torch
	attr_accessor :x, :y

	def initialize(x, y)
		@x = x
		@y = y
	end

	def draw(pic)
		pic.draw(@x, @y - 5, 1)
	end
end

