
class Stone_Torch
	attr_accessor :torchx, :y

	def initialize(torchx, y)
		@torchx = torchx
		@y = y
	end

	def draw(pic)
		pic.draw(@torchx, @y - 5, 1)
	end
end

