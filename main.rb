
require_relative "belmont"
require 'gosu'

class Castlevania < Gosu::Window
	attr_accessor :backwards, :standing, :x, :y

	def initialize
		@xpos = 0
		@ypos = 0
		super 600, 360
		@background = Gosu::Image.new("background.png", :tileable => true)
		@character_standing = Gosu::Image.new("belmont.png", :tileable => true)
		@character_forward = Gosu::Image::load_tiles("cst.png", 20, 60)
		@character_backward = Gosu::Image::load_tiles("cstback.png", 20, 60)
		@belmont = Belmont.new(@character_anim)
		@backwards = false
		@jump = false
	end

	def update
		if Gosu::button_down? Gosu::KbSpace
				@belmont.jump = true
		end

		if Gosu::button_down? Gosu::KbRight
			@belmont.forward
			@backwards = false
			@standing = false 
			@belmont.screenx += 1
			
		elsif Gosu::button_down? Gosu::KbLeft
			@belmont.backward
			@backwards = true
			@standing = false
			@belmont.screenx -= 1
		else
			@standing = true
		end
		if 400 <= @belmont.screenx
				@belmont.x -= 1
				@xpos -= 1
				@belmont.screenx -= 1
			end

		
	end

	def draw
		# puts @belmont.x
		# puts @belmont.y
		@background.draw(@xpos,0,0)
		if (@backwards ==  false && @standing == false)
			if @belmont.jump == true
				@belmont.jump_forward
				@belmont.draw(@character_standing)
				puts @belmont.velocity
			else
				@belmont.set_vel
				@belmont.animate(@character_forward)
			end
		elsif (@backwards == true && @standing == false)
			@belmont.animate(@character_backward)
		else
			@belmont.draw(@character_standing)
		end
	end

	def button_down(id)
		close if id == Gosu::KbEscape
	end

end

window = Castlevania.new
window.show


