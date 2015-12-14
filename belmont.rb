

class Belmont
	attr_accessor :x, :y, :backwards, :standing, :velocity, :jump, :screenx, :on_ground, :whip, :xpos, :collides, :torchx, :speed, :health

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
		@collides = false
		@speed = 1
		@health = 6
	end

	def jump_action
		@y -= @velocity 
		@velocity -= 0.3
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
			@x += @speed
	end

	def backward
		if @x >= 10
			@x -= @speed
		end
	end

	def animate(start, animation, speed)
		img = animation[start / speed % animation.size];
		img.draw(@x, @y, 1)
	end

	def draw(pic)
		pic.draw(@x, @y, ZOrder::Belmont)
	end

	def whip_collides(object)
		if object.reject! {|object| Gosu::distance(@x, @y, object.x, object.y) < 40 && Gosu::distance(@x, @y, object.x, object.y) > 20 }
			true
		else
			false
		end
	end

	def running_collides(objects)
		if objects.reject! {|objects|  Gosu::distance(@x, @y, objects.x, objects.y) < 20 } then
			@health -= 1
			true
		else
			false
		end
	end

end