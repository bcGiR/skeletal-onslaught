class Dungeon

	attr_accessor :name, :areas, :clear

	def initialize(name, areas)
		@name = name
		@areas = areas
		@clear = false
	end

	def clear?
		@clear = true
		@areas.each do |area|
			if area.has_enemies?
				@clear = false
			end
		end
		@clear
	end
end
