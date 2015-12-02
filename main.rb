
require_relative "belmont"
require 'gosu'

class Castlevania < Gosu::Window
	attr_reader :backwards

	def initialize
		super 600, 360
		@background = Gosu::Image.new("background.png", :tileable => true)
		@character_forward = Gosu::Image::load_tiles("cst.png", 20, 60)
		@character_backward = Gosu::Image::load_tiles("cstback.png", 20, 60)
		@belmont = Belmont.new(@character_anim)
	end

	def update

		@belmont.forward && @backwards = false if Gosu::button_down? Gosu::KbRight
		@belmont.backward && @backwards = true if Gosu::button_down? Gosu::KbLeft
	end

	def draw
		@background.draw(0,0,0)
		if @backwards
			@belmont.draw(@character_forward)	
		else
			@belmont.draw(@character_backward)
		end
	end

	def button_down(id)
		close if id == Gosu::KbEscape
	end

end

window = Castlevania.new
window.show


