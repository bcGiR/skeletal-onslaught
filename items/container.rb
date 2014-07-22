require_relative '../game'

class Container

	attr_accessor :name, :items, :locked

	def initialize(name, items, locked)
		@name = name
		@items = items
		@locked = locked
	end

	def open(model)
		unless @locked
			items.each do |item|
				puts "\nThe #{name} contains a #{item.name}. Would you like to take it? (y/n)"
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

	def unlock
		@locked = false
	end
end
