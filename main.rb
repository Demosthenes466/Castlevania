
require_relative "belmont"
require 'gosu'

class Castlevania < Gosu::Window
	attr_accessor :backwards, :standing

	def initialize
		super 600, 360
		@background = Gosu::Image.new("background.png", :tileable => true)
		@character_standing = Gosu::Image.new("belmont.png", :tileable => true)
		@character_forward = Gosu::Image::load_tiles("cst.png", 20, 60)
		@character_backward = Gosu::Image::load_tiles("cstback.png", 20, 60)
		@belmont = Belmont.new(@character_anim)
		@backwards = false
	end

	def update
		if Gosu::button_down? Gosu::KbRight
			@belmont.forward
			@backwards = false
			@standing = false 
		elsif Gosu::button_down? Gosu::KbLeft
			@belmont.backward
			@backwards = true
			@standing = false
		else
			@standing = true
		end
	end

	def draw
		@background.draw(0,0,0)
		if (@backwards ==  false && @standing == false)
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


