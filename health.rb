
class Health
	attr_accessor :x, :y

	def initialize(x, y)
		@x = x
		@y = y
	end

	def draw(pic)
		pic.draw(@x, @y, ZOrder::Belmont)
	end
end