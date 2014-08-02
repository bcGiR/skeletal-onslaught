require_relative 'NPC'
require_relative '../items/healthpot'
require_relative '../items/manapot'
require_relative '../items/ironsword'
require_relative '../items/ironshield'
require_relative '../items/ironarmor'
require_relative '../items/ironhelm'
require_relative '../items/silkrobe'

class Blacksmith < NPC

	def initialize
		inv = [MinorHealthPot.new, MinorManaPot.new, IronSword.new, IronShield.new, IronArmor.new, SilkRobe.new, IronHelm.new]
		super("Joe, the Blacksmith", inv)
	end
	
	def talk(hero)
		puts "\n\"If you've got gold, you can buy something. Otherwise, get the hell out of my \nface.\""
		puts "Buy something? (y/n)"
		answer = gets.chomp.downcase
		until answer == "y" || answer == "n"
			puts "\nType 'y' or 'n'"
			answer = gets.chomp.downcase
		end
		if answer == "y"
			self.sell(hero)
		end
		Game.pause_short
	end

	def sell(hero)
		puts "\n\"Let me know if you see anything you like.\""
		Game.pause_short
		puts "\n-- Blacksmith --\n\n"
		self.inv.each do |i| 
			item_name = i.name
		       if i.equippable?
			       item_name = item_name + "( "
				i.modifiers.each do |mod|
			 		item_name = item_name + "#{mod.attr.upcase}: +#{mod.value} "
				end
				item_name = item_name + ")"
		       end
    			item_name = item_name + " - " + i.value.to_s + "gold"
			puts item_name
		end
		puts "\n----------------"
		Game.pause_short
		puts "\nType the game of an item to buy it:"
		item = gets.chomp.downcase
		Game.pause_short
		if self.inv.any? { |i| i.name.downcase == item }
			item = self.inv.find { |i| i.name.downcase == item}
			if hero.gold < item.value
				puts "\n\"You don't have enough gold for that! Get outta here ya bum!\""
			else
				puts "\n#{item.name} purchased for #{item.value}gold"
				hero.gold = hero.gold - item.value
				hero.inv << item
				index = self.inv.index(item)
				self.inv.delete_at(index)
			end
		else
			puts "\n\"I do not have any of those.\""
		end
		Game.pause_short
		puts "\n\"Anything else I can get you?\" (y/n)"
		answer = gets.chomp.downcase
		until answer == "y" || answer == "n"
			puts "\nType 'y' or 'n'"
			answer = gets.chomp.downcase
		end
		if answer == 'y'
			self.sell(hero)
		end
		Game.pause_short
	end
end
