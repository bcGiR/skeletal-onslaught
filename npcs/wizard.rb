require_relative 'NPC'

class Wizard < NPC

	def initialize
		inv = []
		super("Old Wizard", inv)
	end

	def talk(hero)
		if hero.inv.any? { |i| i.name == "Black Pearl" }
			puts "\n\"You have done it! You have felled the Skeleton King! Wait... What's this? The Black Pearl!? It can't be... King Tygain... #{hero.name}, this is an artifact left from a kingdom whos name has been forgotton long before even I was born. You now hold the legacy of the Strongfist Clan. If you can restore the Black Pearl to it's rightful place, then the Curse of Cursed King my be lifted.\""
		else
			puts "\n\"Greetings #{hero.name}, you look like a capable adventurer. If you are \nplanning on delving into the depths of the dungeon, you had better go prepared. \nI think there might be some things around this inn which could help you. And if \nyou die down there at least I can see if that assassin is \nstill around here...\""
		end
		Game.pause_short
	end
end
