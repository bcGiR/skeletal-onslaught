require_relative 'NPC'

class Wizard < NPC

	def initialize
		inv = []
		super("Old Wizard", inv)
	end

	def talk(hero)
		puts "\n\"Greetings #{hero.name}, you look like a capable adventurer. If you are \nplanning on delving into the depths of the dungeon, you had better go prepared. \nI think there might be some things around this inn which could help you. And if \nyou die down there at least I can see if that assassin is \nstill around here...\""
		Game.pause_short
	end
end
