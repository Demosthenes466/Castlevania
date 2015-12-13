
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

		@x = 44
		@wall_torches = Array.new
		for i in 0...5 do 
			@wall_torches.push(Torch.new(@x, 270))
			@x += 250
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
		end
		if Gosu::button_down? Gosu::KbLeft
				@belmont.backward
				@backwards = true
				@standing = false
		end
		
		if (Gosu::button_down? Gosu::KbSpace) 
			if (!@jumping)
				@belmont.jump = true
			end
		end

		if Gosu::button_down? Gosu::KbRightAlt
			@start_time = Gosu.milliseconds
			@belmont.whip = true
			@belmont.collides(@entry_stone_torches)
		end

		if LevelOne? 
			if !EndOfFirstScreen?
				if FarRight?
					@belmont.x -= 1.5
					@xpos -= 1.5
					MoveObjectsRight(@entry_stone_torches)
					MoveObjectsRight(@wall_torches)
				end	
				if FarLeft?
					@xpos += 1.5
					MoveObjectsLeft(@entry_stone_torches)
					MoveObjectsLeft(@wall_torches)
				end
			end
		else
			if !EndOfSecondScreen?
				if FarRight?
					@belmont.x -= 1.5
					@xpos -= 1.5
					MoveObjectsRight(@entry_stone_torches)
					MoveObjectsRight(@wall_torches)
				end	
				if FarLeft?
					@xpos += 1.5
					MoveObjectsLeft(@entry_stone_torches)
					MoveObjectsLeft(@wall_torches)
				end
			else 
				if @belmont.x > 580
					@belmont.x -= 1.5
				end
			end
		end

		if LevelOne? && EndOfFirstScreen? && @belmont.x > 5
			@level = 1
			@background = Gosu::Image.new("NewLevel.png", :tileable => true)
			@belmont.x = 10
			@belmont.y = 278
		end
	end 

	def draw
		@background.draw(@xpos,0,0)
		if LevelOne?
			DrawObjects(@entry_stone_torches)
		else
			DrawObjects(@wall_torches)
		end
		if ForwardWhipping?
			WhipForward()
		elsif BackwardWhipping?
			WhipBackward()
		elsif ForwardWhipJump?
			@belmont.jump_action
			@belmont.draw(@Fuckeverything)
		elsif BackwardWhipJump?
			@belmont.jump_action
			@belmont.draw(@FuckeverythingBackwards)
		elsif ForwardJumping?
			@belmont.jump_action
			@belmont.draw(@character_standing_forward)
		elsif BackwardJumping?
			@belmont.jump_action
			@belmont.draw(@character_standing_backward)
		elsif StraightJump?
			@belmont.jump_action
			@belmont.draw(@character_standing_forward)
		elsif WalkingForward?
				@belmont.animate(Gosu::milliseconds, @character_forward, 150)
		elsif WalkingBackward?
				@belmont.animate(Gosu::milliseconds, @character_backward, 150)
		else
			if !@backwards
				@belmont.draw(@character_standing_forward)
			else
				@belmont.draw(@character_standing_backward)
			end
		end

	
		puts "Xpos: #{@xpos}"
		puts "BelX: #{@belmont.x}"
	end

	def button_down(id)
		close if id == Gosu::KbEscape
	end

	
end
private

	def EndOfFirstScreen?
		@xpos < -571
	end

	def EndOfSecondScreen?
		@xpos < -1850
	end

	def FarRight?
		400 <= @belmont.x
	end

	def FarLeft?
		10 >= @belmont.x && @xpos > 1
	end

	def MoveObjectsRight(array)
		for i in 0...array.length do
			array[i].x -= 1.5
		end
	end

	def MoveObjectsLeft(array)
		for i in 0...array.length do
			array[i].x += 1.5
		end
	end

	def LevelOne?
		@level == 0
	end

	def ForwardWhipping?
		!@backwards && @belmont.whip && !@belmont.jump
	end

	def BackwardWhipping?
		@backwards && @belmont.whip && !@belmont.jump
	end

	def ForwardWhipJump?
		(!@backwards && @belmont.whip && @belmont.jump)
	end

	def BackwardWhipJump?
		(@backwards && @belmont.whip && @belmont.jump)
	end

	def ForwardJumping?
		(!@backwards && @belmont.jump && !@standing)
	end

	def BackwardJumping?
		(@backwards && @belmont.jump && !@standing)
	end

	def StraightJump?
		(@belmont.jump && @standing)
	end

	def WalkingForward?
		(!@backwards && !@standing)
	end

	def WalkingBackward?
		(@backwards && !@standing)
	end

	def WhipForward()
		if Gosu::milliseconds - @start_time < 300
			@belmont.draw(@Fuckeverything)
		else
			@belmont.whip = false
		end
	end

	def WhipBackward()
		if Gosu::milliseconds - @start_time < 200
			@belmont.draw(@FuckeverythingBackwards)
		else
			@belmont.whip = false
		end
	end

	def DrawObjects(array)
		for i in 0...array.length do
			array[i].draw(@stone_torch)
		end
	end



window = Castlevania.new
window.show


