require_relative 'NPC'
require_relative '../items/healthpot'
require_relative '../items/manapot'
require_relative '../items/ironsword'
require_relative '../items/ironshield'
require_relative '../items/ironarmor'
require_relative '../items/ironhelm'
require_relative '../items/silkrobe'

class Merchant < NPC

	def initialize
		inv = []
		super(["Travelling Merchant", "Travelling", "Merchant", "Merch"], inv)
	end
	
	def talk(hero)
		puts "\n\"Hello, my friend. I will give you top dollar for your treasures.\""
		puts "Sell something? (y/n)"
		answer = gets.chomp.downcase
		until answer == "y" || answer == "n"
			puts "\nType 'y' or 'n'"
			answer = gets.chomp.downcase
		end
		if answer == "y"
			self.buy(hero)
		end
		Game.pause_short
	end

	def buy(hero)
		puts "\n\"What can I take off your hands today?\""
		Game.pause_short
		puts "\n-- Inventory --\n\n"
				hero.inv.each do |i| 
					if i.equippable?
						if i.equipped?
							item_name = "*" + i.names[0] + " ("
							i.modifiers.each do |mod|
								item_name = item_name + "#{mod.attr.upcase}: +#{mod.value} "
							end
							item_name = item_name + ")"
							puts item_name	
						else
							item_name = i.names[0] + " ("
							i.modifiers.each do |mod|
								item_name = item_name + "#{mod.attr.upcase}: +#{mod.value} "
							end
							item_name = item_name + ")"
							puts item_name
						end
					else
						puts i.names[0]
					end
				end
				puts "\n(equipped: [*])"	
				puts "---------------"
		Game.pause_short
		puts "\nType the game of an item to sell it:"
		item = gets.chomp.downcase
		Game.pause_short
		if hero.inv.any? { |i| i.names.any? { |name| name.downcase == item } }
			item = hero.inv.find { |i| i.names.any? { |name| name.downcase == item } }
			puts "\n\"I will give you #{item.value/2} gold for your #{item.names[0]}\""
			puts "Sell? (y/n)"
			answer = gets.chomp.downcase
			until answer == "y" || answer == "n"
				puts "\nType 'y' or 'n'"
				answer = gets.chomp.downcase
			end
			if answer == 'y'
				hero.gold = hero.gold + item.value/2
				index = hero.inv.index(item)
				hero.inv.delete_at(index)
				puts "\n#{item.names[0]} sold for #{item.value/2} gold"
			end
		else
			puts "\n\"You don't have any of those.\""
		end
		Game.pause_short
		puts "\n\"Anything else I can bargain for?\" (y/n)"
		answer = gets.chomp.downcase
		until answer == "y" || answer == "n"
			puts "\nType 'y' or 'n'"
			answer = gets.chomp.downcase
		end
		if answer == 'y'
			self.buy(hero)
		end
		Game.pause_short
	end
end
