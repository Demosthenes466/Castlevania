
require_relative "belmont"
require 'gosu'

class Castlevania < Gosu::Window
	attr_accessor :backwards, :standing, :x, :y, :on_ground

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
		

		if Gosu::button_down? Gosu::KbRight
			if @belmont.jump == false
				@belmont.forward
				@backwards = false
				@standing = false 
				@belmont.screenx += 1
			end
		elsif Gosu::button_down? Gosu::KbLeft
			@belmont.backward
			@backwards = true
			@standing = false
			@belmont.screenx -= 1
		else
			@standing = true
		end

		if (Gosu::button_down? Gosu::KbSpace) 
			@belmont.jump = true
		end

		if 400 <= @belmont.screenx
				@belmont.x -= 1
				@xpos -= 1
				@belmont.screenx -= 1
			end	
	end 

	def draw
		# puts @belmont.jump
		@background.draw(@xpos,0,0)
		if (@backwards == false && @belmont.jump == true && @standing == false)
			@belmont.jump_action
			@belmont.x += 2
			@belmont.draw(@character_standing)
		elsif (@backwards == true && @belmont.jump == true && @standing == false)
			@belmont.jump_action
			@belmont.x -= 1
			@belmont.draw(@character_standing)
		elsif (@belmont.jump == true && @standing == true)
			@belmont.jump_action
			@belmont.draw(@character_standing)
		elsif (@backwards ==  false && @standing == false)
				@belmont.animate(@character_forward)
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


