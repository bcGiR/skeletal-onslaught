require_relative '../game'

class Area

	attr_accessor :name, :description, :adjacent, :npc, :enemies, :objects

	def initialize(name, description, adjacent, npc, enemies, objects)
		@name = name
		@description = description
		@adjacent = adjacent
		@npc = npc
		@enemies = enemies
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
