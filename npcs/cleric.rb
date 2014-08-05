require_relative 'NPC'
require_relative '../items/smallmanapot'
require_relative '../items/smallhealthpot'
require_relative '../items/manapot'
require_relative '../items/healthpot'
require_relative '../game'

class Cleric < NPC

	attr_accessor :has_skill

	def initialize
		inv = [SmallManaPot.new, SmallHealthPot.new, SmallHealthPot.new, MinorHealthPot.new, MinorHealthPot.new, MinorManaPot.new, MinorManaPot.new]
		super(["Cleric"], inv)
		@has_skill = true
	end

	def talk(hero)
		if hero.hp < hero.hpmax || hero.mp < hero.mpmax
			puts "\nSeeing your exhaustion, the Cleric restores your HP and MP"
			hero.hp = hero.hpmax
			hero.mp = hero.mpmax
			Game.pause_short
		end
		if hero.inv.any? { |item| item.names[0][0..4] == "skel" } && @has_skill
			puts "\n\"You have done it! The King of Bones is defeated! Congratulations, brave hero, now I must be off-- oh... what? Oh right! The spell... yes, of course. Right away.\""
			hero.special_list['heal'] = 6
			puts "#{hero.names[0]} has learned Heal!"
			Game.pause_medium
			@has_skill = false
		elsif @has_skill
			puts "\n\"Oh! Well met adventurer! I was starting to think I was never going to make it \nout of this place. Listen, the King of Bones must die, but I am unable to do it \nmyself. If you defeat Skelethognos', I will teach you what you need to know to \nrecover from battle. Make haste hero, the skeletons do not stay dead for long...\""
		else
			puts "\n\"I have taught you what I can, brave hero, but you are not done learning. Your \ntrials will teach you more than I ever can, your destiny awaits!\""
		end
		Game.pause_short
		puts "\n\"I might have a few potions you would be interested in.\""
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
		puts "\n\"How can I help you?\""
		Game.pause_short
		puts "\n---- Cleric ----\n\n"
		self.inv.each do |i| 
			item_name = i.names[0]
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
		if self.inv.any? { |i| i.names.any? { |name| name.downcase == item } }
			item = self.inv.find { |i| i.names.any? { |name| name.downcase == item } }
			if hero.gold < item.value
				puts "\n\"I'm afraid I can't just give that away.\""
			else
				puts "\n#{item.names[0]} purchased for #{item.value}gold"
				hero.gold = hero.gold - item.value
				hero.inv << item
				index = self.inv.index(item)
				self.inv.delete_at(index)
			end
		else
			puts "\n\"I do not have any of those.\""
		end
		Game.pause_short
		puts "\n\"Anything else I can offer you?\" (y/n)"
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
