require_relative '../game'

class Area

	attr_accessor :name, :description, :adjacent, :npc, :spawns, :enemies, :objects

	def initialize(name, description, adjacent, npc, spawns, objects)
		@name = name
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
