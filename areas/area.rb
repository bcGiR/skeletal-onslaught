require_relative '../game'

class Area

	attr_accessor :names, :description, :adjacent, :npc, :spawns, :enemies, :objects

	def initialize(names, description, adjacent, npc, spawns, objects)
		@names = names
		@description = description
		@adjacent = adjacent
		@npc = npc
		@spawns = spawns
		@enemies = []
		@objects = objects
	end

	def has_enemies?
		if enemies.empty?
			return false
		else
			return true
		end
	end
end
