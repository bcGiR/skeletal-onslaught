require_relative '../game'

class Container

	attr_accessor :names, :items, :locked

	def initialize(names, items, locked)
		@names = names
		@items = items
		@locked = locked
	end

	def open(model)
		unless @locked
			items_temp = []
			items.each do |item|
				puts "\nThe #{names[0]} contains a #{item.names[0]}. Would you like to take it? (y/n)"
				confirm = gets.chomp.downcase
				until confirm == "y" || confirm == "n"
					Game.pause_short
					puts "\nPlease enter y/n:"
					confirm = gets.chomp.downcase
				end
				Game.pause_short
				if confirm == "y"
					model.inv << item
				else
					items_temp << item
				end
			end
			@items = items_temp
		end
	end

	def unlock(model)
		@locked = false
	end
end
