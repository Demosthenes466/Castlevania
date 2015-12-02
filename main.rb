require 'gosu'
class Castlevania < Gosu::Window
	def initialize
		super 600, 360
		@background = Gosu::Image.new("background.png", :tileable => true)
		@character = Gosu::Image.new("belmont.png", :tileable => true)
	end

	def draw
		@background.draw(0,0,0)
		@character.draw(10,10,1)
	end

end

window = Castlevania.new
window.show


