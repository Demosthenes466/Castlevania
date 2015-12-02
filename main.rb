
require_relative "belmont"
require 'gosu'

class Castlevania < Gosu::Window
	def initialize
		super 600, 360
		@background = Gosu::Image.new("background.png", :tileable => true)
		@character_anim = Gosu::Image::load_tiles("cst.png", 20, 60)
		@belmont = Belmont.new(@character_anim)
	end

	def draw
		@background.draw(0,0,0)
		@belmont.draw
		
	end

end

window = Castlevania.new
window.show


