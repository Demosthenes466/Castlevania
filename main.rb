
require_relative "belmont"
require_relative "Stone_torch"
require 'gosu'

class Castlevania < Gosu::Window
	attr_accessor :backwards, :standing, :x, :y, :on_ground, :torchx

	def initialize
		@xpos = 0
		@ground_level = 283
		super 600, 360
		@background = Gosu::Image.new("background2.png", :tileable => true)

		@character_standing = Gosu::Image.new("belmont copy.png", :tileable => true)
		@character_forward = Gosu::Image::load_tiles("cst.png", 30, 60)
		@character_backward = Gosu::Image::load_tiles("cstback.png", 30, 60)
		@character_whipping = Gosu::Image::load_tiles("whippingL.png", 80, 60)

		@belmont = Belmont.new(@character_anim)
		@backwards = false
		@jump = false
		@torch = Gosu::Image.new("Stone Torch.png", :tileable => true)
		@entry_stone_torches = Array.new
		@torchx = 44
		for i in 0...5 do 
			@entry_stone_torches.push(Stone_Torch.new(@torchx, @ground_level))
			@torchx += 220
		end

		@seconds = 0
		@last_time = Gosu::milliseconds()
		@start_time = 0


	end

	def update
		@standing = true
		
		if Gosu::button_down? Gosu::KbRight
			# if @belmont.jump == false
				@belmont.forward
				@backwards = false
				@standing = false 
			# end
		end
		if Gosu::button_down? Gosu::KbLeft
			# if @belmont.jump == false
				@belmont.backward
				@backwards = true
				@standing = false
			# end
		end
		
		if (Gosu::button_down? Gosu::KbSpace) 
			@belmont.jump = true
		end

		if Gosu::button_down? Gosu::KbRightAlt
			@start_time = Gosu.milliseconds
			@belmont.whip = true
		end

			
		if 400 <= @belmont.x
			for i in 0...@entry_stone_torches.length do
				@entry_stone_torches[i].torchx -= 1.5
			end
			@belmont.x -= 1.5
			@xpos -= 1.5
		end	
	end 

	def draw
		@background.draw(@xpos,0,0)
		for i in 0...@entry_stone_torches.length do
			@entry_stone_torches[i].draw(@torch)
		end
		if (@backwards == false && @belmont.whip == true && @belmont.jump == false)
			if Gosu::milliseconds - @start_time < 300
				@belmont.animate(@character_whipping, 125)
			else
				@belmont.whip = false
			end
		elsif (@backwards == false && @belmont.whip == true && @belmont.jump == true)
			@belmont.jump_action
			if Gosu::milliseconds - @start_time < 0
				@belmont.animate(@character_whipping, 125)
			end
			if Gosu::milliseconds - @start_time < 1000
				@belmont.whip = false
			end
		elsif (@backwards == false && @belmont.jump == true && @standing == false)
			@belmont.jump_action
			@belmont.draw(@character_standing)
		elsif (@backwards == true && @belmont.jump == true && @standing == false)
			@belmont.jump_action
			@belmont.draw(@character_standing)
		elsif (@belmont.jump == true && @standing == true)
			@belmont.jump_action
			@belmont.draw(@character_standing)
		elsif (@backwards ==  false && @standing == false)
				@belmont.animate(@character_forward, 150)
		elsif (@backwards == true && @standing == false)
				@belmont.animate(@character_backward, 150)
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


