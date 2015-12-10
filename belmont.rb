

class Belmont
	attr_accessor :x, :y, :backwards, :standing, :velocity, :jump, :screenx, :on_ground, :whip, :xpos

	def initialize(animation)
		@on_ground = true
		@screenx = 10
		@animation = animation
		@x = 10
		@y = 283
		@standing = true
		@velocity = 5
		@jump = false
		@whip = false
	end

	def jump_action
		@y -= @velocity 
		@velocity -= 0.4
		if @y > 283
			@y = 283
			@velocity = 0
			@jump = false
			set_vel
		end
	end

	def set_vel
		@velocity = 5
	end

	def forward
			@x += 1
	end

	def backward
		if @x >= 10
			@x -= 1
		end
	end

	def animate(start, animation, speed)
		img = animation[start / speed % animation.size];
		img.draw(@x, @y, 1)
	end

	def draw(pic)
		pic.draw(@x, @y, 1)
	end

end