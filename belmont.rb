

class Belmont
	attr_reader :x, :y

	def initialize(animation)
		@animation = animation
		@x = 10
		@y = 20
	end

	def draw
		img = @animation[Gosu::milliseconds / 100 % @animation.size];
		img.draw(@x, @y, 1)
	end
end