
require_relative "belmont"
require_relative "Stone_torch"
require 'gosu'

class Castlevania < Gosu::Window
	attr_accessor :backwards, :standing, :x, :y, :on_ground, :x, :collides

	def initialize
		@xpos = 0
		@ground_level = 283
		super 600, 360
		@background = Gosu::Image.new("background2.png", :tileable => true)
		@level = 0

		@character_standing_forward = Gosu::Image.new("belmont copy.png", :tileable => true)
		@character_standing_backward = Gosu::Image.new("belmontback.png", :tileable => true)
		@character_forward = Gosu::Image::load_tiles("cst.png", 30, 60)
		@character_backward = Gosu::Image::load_tiles("cstback.png", 30, 60)
		@character_whipping = Gosu::Image::load_tiles("bw.png", 35, 60)
		@Fuckeverything = Gosu::Image.new("FuckEverything.png", :tileable => true)
		@FuckeverythingBackwards = Gosu::Image.new("FuckEverythingBackwards.png", :tileable => true)

		@belmont = Belmont.new(@character_anim)
		@backwards = false
		@jump = false
		@stone_torch = Gosu::Image.new("Stone Torch.png", :tileable => true)
		@wall_torch = Gosu::Image.new("TorchN.png", :tileable => true)
		@entry_stone_torches = Array.new
		@x = 44
		for i in 0...5 do 
			@entry_stone_torches.push(Torch.new(@x, @ground_level))
			@x += 220
		end
		@jumping = false
		@seconds = 0
		@last_time = Gosu::milliseconds()
		@start_time = 0


	end

	def update
		@standing = true
		if Gosu::button_down? Gosu::KbP
			@belmont.speed = 5
		end

		if Gosu::button_down? Gosu::KbRight
				@belmont.forward
				@backwards = false
				@standing = false 
			# end
		end
		if Gosu::button_down? Gosu::KbLeft
				@belmont.backward
				@backwards = true
				@standing = false
			# end
		end
		
		if (Gosu::button_down? Gosu::KbSpace) 
			# @start_time = Gosu.milliseconds
			if (!@jumping)
				@belmont.jump = true
			end
			# else
			# 	@belmont.jump = false
			# end
		end

		if Gosu::button_down? Gosu::KbRightAlt
			@start_time = Gosu.milliseconds
			@belmont.whip = true
			@belmont.collides(@entry_stone_torches)
		end

		if @xpos > -571		
			if 400 <= @belmont.x
				@belmont.x -= 1.5
				for i in 0...@entry_stone_torches.length do
					@entry_stone_torches[i].x -= 1.5
				end
				@xpos -= 1.5
			end 

			if 10 >= @belmont.x && @xpos > 1
				for i in 0...@entry_stone_torches.length do
					@entry_stone_torches[i].x += 1.5
				end
				@xpos += 1.5
			end
		end	

		if @belmont.x > 518
			@level = 1
			@background = Gosu::Image.new("NewLevel.png", :tileable => true)
			@belmont.x = 10
			@belmont.y = 278
			@x = 44
			@entry_stone_torches = []
			@wall_torches = Array.new
			for i in 0...5 do 
				@wall_torches.push(Torch.new(@x, 270))
				@x += 220
			end
		end

		
		

	end 

	def draw
		@background.draw(@xpos,0,0)
		if @level == 0
			for i in 0...@entry_stone_torches.length do
				@entry_stone_torches[i].draw(@stone_torch)
			end
		elsif @level == 1
			for i in 0...@wall_torches.length do
				@wall_torches[i].draw(@wall_torch)
			end
		end
		if (@backwards == false && @belmont.whip == true && @belmont.jump == false)
			if Gosu::milliseconds - @start_time < 300
				@belmont.draw(@Fuckeverything)
			else
				@belmont.whip = false
			end
		elsif (@backwards == true && @belmont.whip == true && @belmont.jump == false)
			if Gosu::milliseconds - @start_time < 200
				@belmont.draw(@FuckeverythingBackwards)
			else
				@belmont.whip = false
			end
		elsif (!@backwards && @belmont.whip && @belmont.jump)
			@belmont.jump_action
			@belmont.draw(@Fuckeverything)
		elsif (@backwards && @belmont.whip && @belmont.jump)
			@belmont.jump_action
			@belmont.draw(@FuckeverythingBackwards)
		elsif (@backwards == false && @belmont.jump == true && @standing == false)
			@belmont.jump_action
			@belmont.draw(@character_standing_forward)
		elsif (@backwards == true && @belmont.jump == true && @standing == false)
			@belmont.jump_action
			@belmont.draw(@character_standing_backward)
		elsif (@belmont.jump == true && @standing == true)
			@belmont.jump_action
			@belmont.draw(@character_standing_forward)
		elsif (@backwards ==  false && @standing == false)
				@belmont.animate(Gosu::milliseconds, @character_forward, 150)
		elsif (@backwards == true && @standing == false)
				@belmont.animate(Gosu::milliseconds, @character_backward, 150)
		else
			if @backwards == false
				@belmont.draw(@character_standing_forward)
			else
				@belmont.draw(@character_standing_backward)
			end
		end

		# for i in 0...@entry_stone_torches.length
		# 	puts @entry_stone_torches[i].x
		# end
puts "Xpos: #{@xpos}"
puts "BelX: #{@belmont.x}"
	end

	def button_down(id)
		close if id == Gosu::KbEscape
	end

end

window = Castlevania.new
window.show


