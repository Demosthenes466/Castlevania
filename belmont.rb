

class Belmont
	attr_reader :x, :y, :backwards, :standing

	def initialize(animation)
		@animation = animation
		@x = 10
		@y = 283
		@standing = true
	end

	def forward
		# @backwards = false
		@x += 1
		# @standing = false
	end

	def backward
		# @backwards = true
		@x -= 1
		# @standing = false
	end

	def animate(animation)
		img = animation[Gosu::milliseconds / 150 % animation.size];
		img.draw(@x, @y, 1)
	end

	def draw(pic)
		pic.draw(@x, @y, 1)
	end
end