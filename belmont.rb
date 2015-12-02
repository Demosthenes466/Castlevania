

class Belmont
	attr_reader :x, :y, :backwards

	def initialize(animation)
		@animation = animation
		@x = 10
		@y = 20
	end

	def forward
		@backwards = false
		@x += 1
	end

	def backward
		@backwards = true
		@x -= 1

	end

	def draw(animation)
		img = animation[Gosu::milliseconds / 150 % animation.size];
		img.draw(@x, @y, 1)
	end
end