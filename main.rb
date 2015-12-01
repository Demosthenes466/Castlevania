
class Castlevania < Gosu::Window
	def initialize
		super 1024, 1024
		@background = Gosu::Image.new("background.jpg", :tileable => true)
	end


