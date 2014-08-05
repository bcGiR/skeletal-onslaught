class Dungeon

	attr_accessor :names, :areas, :game, :clear

	def initialize(names, areas, game)
		@name = names
		@areas = areas
		@game = game
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
