

class Belmont
	attr_accessor :x, :y, :backwards, :standing, :velocity, :jump, :screenx, :on_ground

	def initialize(animation)
		@on_ground = true
		@screenx = 10
		@animation = animation
		@x = 10
		@y = 283
		@standing = true
		@velocity = 5
		@jump = false
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

	def ground
		if @y == 283
			@on_ground = true
		else
			@on_ground = false
		end
	end


	def set_vel
		@velocity = 5
	end
# if @y <= 283
		# 	@y = 283
		# 	vy = 0
		# end
		
	

	def forward
		@x += 1
		# @screenx += 1
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