class Dungeon

	attr_accessor :name, :areas, :game, :clear

	def initialize(name, areas, game)
		@name = name
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
