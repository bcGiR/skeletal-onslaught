class CombatTimer

	attr_accessor :name, :game, :model, :rounds_left, :effect, :effect_type

	def initialize(name, game, model, rounds_left, effect, effect_type)
		@name = name
		@game = game
		@model = model
		@rounds_left = rounds_left
		@effect = effect
		@effect_type = effect_type
	end

	def tick
		if @effect_type == 'dmg'
			@model.hp = @model.hp - effect
			puts "\n#{@model.name} has suffered #{@effect} damage from #{@name}"
			Game.pause_short
			if @model.dead?
				game.kill(@model)
			end
		end
		@rounds_left = @rounds_left - 1
		if @rounds_left == 0
			self.expires
		end
	end

	def expires
		case @effect_type
		when 'mod'
			model.demodify(@effect)
		end
		puts "\n#{game.hero.name}level#{game.hero.lvl}att#{game.hero.att}defn#{game.hero.defn}matt#{game.hero.matt}mdefn#{game.hero.mdefn}"
		
		puts "\n#{@name} affecting #{@model.name} has worn off"
		Game.pause_short
	end

end
