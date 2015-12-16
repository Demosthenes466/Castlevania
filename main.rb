require_relative "belmont"
require_relative "Stone_Torch"
require_relative "ghoul"
require_relative "zorder"
require_relative "health"
require 'gosu'

class Castlevania < Gosu::Window
	attr_accessor :backwards, :standing, :x, :y, :on_ground

	def initialize
		@xpos = 0
		@ground_level = 283
		super 600, 360
		@background = Gosu::Image.new("media/background2.png", :tileable => true)
		@music = Gosu::Song.new("music.wav")
		@level = 0
		@GameOver = false
		@music.play(true)
		@font = Gosu::Font.new(20)
		@character_standing_forward = Gosu::Image.new("media/belmont copy.png", :tileable => true)
		@character_standing_backward = Gosu::Image.new("media/belmontback.png", :tileable => true)
		@character_forward = Gosu::Image::load_tiles("media/cst.png", 30, 60)
		@character_backward = Gosu::Image::load_tiles("media/cstback.png", 30, 60)
		@Fuckeverything = Gosu::Image.new("media/FuckEverything2.png", :tileable => true)
		@FuckeverythingBackwards = Gosu::Image.new("media/FuckEverythingBackwards2.png", :tileable => true)
		@ghoulBackwards = Gosu::Image.new("media/GhoulRight.png", :tileable => true)
		@Ghoul = Gosu::Image.new("media/Ghoul.png", :tileable => true)
		@stone_torch = Gosu::Image.new("media/Stone Torch.png", :tileable => true)
		@wall_torch = Gosu::Image.new("media/TorchN.png", :tileable => true)
		@belmontHealthBlock = Gosu::Image.new("media/HealthBlock.png", :tileable => true)
		@belmont = Belmont.new(@character_anim)
		@backwards = false
		@jump = false
		SetHealthArray()
		@ghouls = Array.new
		@ghoulSpeed = 1.25
		SetStoneTorchArray()
		SetWallTorchArray()
		@jumping = false
		@last_time = Gosu::milliseconds()
		@start_time = 0	
		SetFrontGhoulArray()
	end

	def update
		@standing = true
		if !@GameOver && !Win?
			if !LevelOne?
				if AtFinalStair?
					if Gosu::button_down? Gosu::KbUp
						@belmont.stair_start = true 
					end
				end
				if @belmont.y < 120
					@belmont.stair_start = false
				end
			end
			if Gosu::button_down? Gosu::KbO
				@ghouls.clear
			end
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
				RandomGhouls()
				ChaseBelmont()
				@belmont.running_collides(@ghouls)
			end
			if LevelOne? && EndOfFirstScreen? && @belmont.x > 517
				@level = 1
				@background = Gosu::Image.new("media/NewLevel.png", :tileable => true)
				@belmont.x = 10
				@belmont.y = 278
			end
		end
	end

	def draw
		@background.draw(@xpos,0,0)
		if @belmont.health == 0
			@GameOver = true
		end
		if Win?
			@font.draw("You win!", 200, 180, 1, 4.0, 4.0, 0xff_ff0000)
			@font.draw("Score: #{@belmont.score}", 200, 260, 1, 2.0, 2.0, 0xff_ff0000)
		else
			if !@GameOver
				for i in 0...@belmont.health do 
					@belmontHealth[i].draw(@belmontHealthBlock)
				end
				@font.draw("Score:  #{@belmont.score}", 5, 50, 1, 1.0, 1.0, 0xff_ffffff)
				@font.draw("Player Health", 5, 10, 1, 1.0, 1.0, 0xff_ffffff)

				if LevelOne?
					DrawObjects(@entry_stone_torches, @stone_torch)
				else
					DrawObjects(@wall_torches, @wall_torch)
					DrawCreeps(@ghouls, @Ghoul, @GhoulRight)
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
		end
	end

	def button_down(id)
		close if id == Gosu::KbEscape
	end
end

private

	def AtFinalStair?
		(@xpos < -1630 && @belmont.x > 390) ||(@xpos < -1800 && @belmont.x > 175 && @belmont.x < 190)
	end

	def DrawCreeps(creeps, picF, picB)
		for i in 0...creeps.length do 
			if creeps[i].x > @belmont.x 
				creeps[i].draw(picF)
			else
				creeps[i].draw(picB)
			end
		end
	end
	def SetFrontGhoulArray()
		prng = Random.new
		# @x = 700
		for i in 0..2 do
			@x = prng.rand(200...700)
			@ghouls.push(Ghoul.new(@x, @ground_level))
		end
		
	end
	def SetStoneTorchArray()
		@x = 44
		@entry_stone_torches = Array.new
		for i in 0...5 do 
			@entry_stone_torches.push(Torch.new(@x, @ground_level))
			@x += 220
		end
	end
	def SetWallTorchArray()
		@x = 44
		@wall_torches = Array.new
		for i in 0...5 do 
			@wall_torches.push(Torch.new(@x, 275))
			@x += 250
		end
	end
	def SetHealthArray()
		@belmontHealth = Array.new
		@healthx = 10
		for i in 0...@belmont.health do 
			@belmontHealth.push(Health.new(@healthx, 30))
			@healthx += 10
		end
	end
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
		if Gosu::milliseconds - @start_time < 200
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
	def RandomGhouls()
		if rand(100) < 4 && @xpos > -1200
			prng = Random.new
			@xt = @xpos - 100
			@xl = (@xpos* -1) + 500
			@x = prng.rand(500..@xl)
			@ghouls.push(Ghoul.new(@x, 283))
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
	def Win?()
		if @belmont.x > 550 && @belmont.y < 125
			true
		end
	end
window = Castlevania.new
window.show


