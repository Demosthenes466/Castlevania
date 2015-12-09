

class Belmont
	attr_accessor :x, :y, :backwards, :standing, :velocity, :jump, :screenx, :on_ground, :whip 

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

	def update
		end



	def set_vel
		@velocity = 5
	end

	def forward
		@x += 1
	end

	def backward
		@x -= 1
	end

	def animate(animation, speed)
		img = animation[Gosu::milliseconds / speed % animation.size];
		img.draw(@x, @y, 1)
	end

	def draw(pic)
		pic.draw(@x, @y, 1)
	end

end