require_relative 'container'
require_relative 'smallhealthpot'
require_relative 'smallmanapot'

class LockedWoodenChest < Container

	def initialize
		super("Locked Wooden Chest",
		      [],
			true)
	end

	def unlock(model)
		if model.keys < 0
			puts "\nUse a key to open the chest? (y/n)"
			confirm = ""
			until confirm == "n" || confirm == "y"
				confirm = gets.chomp.downcase
			end
			if confirm == "y"
				model.keys = model.keys - 1
				puts "\nThe latch clicks and the chest swings open"
				super
			end
		else
			puts "\nThis chest requires a key to open"
		end
	end
end
