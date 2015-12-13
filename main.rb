
require_relative "belmont"
require_relative "Stone_Torch"
require_relative "ghoul"
require_relative "zorder"
require_relative "health"
require 'gosu'

class Castlevania < Gosu::Window
	attr_accessor :backwards, :standing, :x, :y, :on_ground, :x, :collides, :health

	def initialize
		@xpos = 0
		@ground_level = 283
		super 600, 360
		@background = Gosu::Image.new("background2.png", :tileable => true)
		@level = 0

		@font = Gosu::Font.new(20)

		@character_standing_forward = Gosu::Image.new("belmont copy.png", :tileable => true)
		@character_standing_backward = Gosu::Image.new("belmontback.png", :tileable => true)
		@character_forward = Gosu::Image::load_tiles("cst.png", 30, 60)
		@character_backward = Gosu::Image::load_tiles("cstback.png", 30, 60)
		@character_whipping = Gosu::Image::load_tiles("bw.png", 35, 60)
		@Fuckeverything = Gosu::Image.new("FuckEverything2.png", :tileable => true)
		@FuckeverythingBackwards = Gosu::Image.new("FuckEverythingBackwards2.png", :tileable => true)

		

		@ghoulBackwards = Gosu::Image.new("GhoulRight.png", :tileable => true)
		@Ghoul = Gosu::Image.new("Ghoul.png", :tileable => true)
		@belmont = Belmont.new(@character_anim)
		@backwards = false
		@jump = false
		@stone_torch = Gosu::Image.new("Stone Torch.png", :tileable => true)
		@wall_torch = Gosu::Image.new("TorchN.png", :tileable => true)
		@entry_stone_torches = Array.new
		
		@x = 700
		@ghouls = Array.new
		for i in 0..10 do
			@ghouls.push(Ghoul.new(@x, @ground_level))
			@x += 75
		end
		@x = 44
		for i in 0...5 do 
			@entry_stone_torches.push(Torch.new(@x, @ground_level))
			@x += 220
		end

		@x = 44
		@wall_torches = Array.new
		for i in 0...5 do 
			@wall_torches.push(Torch.new(@x, 275))
			@x += 250
		end
		@jumping = false
		@seconds = 0
		@last_time = Gosu::milliseconds()
		@start_time = 0

		@belmontHealthBlock = Gosu::Image.new("HealthBlock.png", :tileable => true)
		@belmontHealth = Array.new
		@healthx = 10
		for i in 0...@belmont.health do 
			@belmontHealth.push(Health.new(@healthx, 30))
			@healthx += 10
		end
		@GameOver = false
		@ghoulSpeed = 1.25


	end

	def update
		@standing = true
		if !@GameOver
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
				if LevelOne?
					@belmont.whip_collides(@entry_stone_torches)
				else
					@belmont.whip_collides(@ghouls)
					@belmont.whip_collides(@wall_torches)
				end
			end

			if LevelOne? 
				if !EndOfFirstScreen?
					if FarRight?
						@belmont.x -= @belmont.speed
						@xpos -= @belmont.speed
						MoveObjectsRight(@entry_stone_torches)
						MoveObjectsRight(@wall_torches)
					end	
					if FarLeft?
						@xpos += @belmont.speed
						MoveObjectsLeft(@entry_stone_torches)
						MoveObjectsLeft(@wall_torches)
					end
				end
			else
				if !EndOfSecondScreen?
					if FarRight?
						@belmont.x -= @belmont.speed
						@xpos -= @belmont.speed
						MoveObjectsRight(@entry_stone_torches)
						MoveObjectsRight(@wall_torches)
						for i in 0...@ghouls.length do
							@ghouls[i].x -= @belmont.speed 
						end
					end	
					if FarLeft?
						@xpos += @belmont.speed
						MoveObjectsLeft(@entry_stone_torches)
						MoveObjectsLeft(@wall_torches)
					end
				else 
					if @belmont.x > 580
						@belmont.x -= @belmont.speed
					end
				end
			end

			if !LevelOne?
				ChaseBelmont()
			end

			if LevelOne? && EndOfFirstScreen? && @belmont.x > 517
				@level = 1
				@background = Gosu::Image.new("NewLevel.png", :tileable => true)
				@belmont.x = 10
				@belmont.y = 278
			end
		@belmont.running_collides(@ghouls)	
	end
	end


	def draw
		@background.draw(@xpos,0,0)
		if @belmont.health == 0
			@GameOver = true
		end
		if !@GameOver
			for i in 0...@belmont.health do 
				@belmontHealth[i].draw(@belmontHealthBlock)
			end
			@font.draw("Player Health", 5, 10, 1, 1.0, 1.0, 0xff_ffffff)

			if LevelOne?
				DrawObjects(@entry_stone_torches, @stone_torch)
			else
				DrawObjects(@wall_torches, @wall_torch)
				for i in 0...@ghouls.length do 
					if @ghouls[i].x > @belmont.x 
						@ghouls[i].draw(@Ghoul)
					else
						@ghouls[i].draw(@ghoulBackwards)
					end
				end

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
		else
			@font.draw("Game Over", 200, 180, 1, 3.0, 3.0, 0xff_ff0000)
		end



	
		# puts "Xpos: #{@xpos}"
		# puts "BelX: #{@belmont.x}"
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
			array[i].x -= @belmont.speed
		end
	end

	def MoveObjectsLeft(array)
		for i in 0...array.length do
			array[i].x += @belmont.speed
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

	def DrawObjects(array, pic)
		for i in 0...array.length do
			array[i].draw(pic)
		end
	end

	def ChaseBelmont()
		for i in 0...@ghouls.length do
			if @ghouls[i].x < @belmont.x 
				@ghouls[i].x += @ghoulSpeed
			else
				@ghouls[i].x -= @ghoulSpeed
			end
		end
	end



window = Castlevania.new
window.show


