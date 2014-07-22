require_relative 'container'
require_relative 'healthpot'
require_relative 'manapot'

class LockedWoodenChest < Container

	def initialize
		super("Locked Wooden Chest",
		      [ HealthPot.new,
	  		ManaPot.new ],
			true)
	end

	def unlock
		puts "\nSay the magic words"
		words = gets.chomp.downcase
		if words == "open sesame"
			puts "\nThe lock clicks open and the chest latch loosens."
			Game.pause_short
			super
		end
	end
end
