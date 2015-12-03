

class Belmont
	attr_accessor :x, :y, :backwards, :standing

	def initialize(animation)
		@animation = animation
		@x = 10
		@y = 283
		@standing = true
	end

	def forward
		@x += 1
	end

	def backward
		@x -= 1
	end

	def animate(animation)
		img = animation[Gosu::milliseconds / 150 % animation.size];
		img.draw(@x, @y, 1)
	end

	def draw(pic)
		pic.draw(@x, @y, 1)
	end
end