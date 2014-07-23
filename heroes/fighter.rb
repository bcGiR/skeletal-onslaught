require_relative 'adventurer'
require_relative '../game'

class Fighter < Adventurer

	def initialize(name)
		super(name, 12, 20, 2, 6, 2, 1)
		@special_list = { 'flurry' => 4 }
	end

	def special_attack(action)
		case action
		when 'flurry'
			self.flurry
		end
	end

	def flurry

		@mp = @mp - 4

		damage = ( Game.d2 + Game.d2 + Game.d2 + Game.d2 + 1 ) * ( Math.log2(2 * @lvl) )

		puts "\n*** A flurry of sword strikes assualt the Fighters foe ***"
		Game.pause_short
		damage
	end

	def level_up
		super
		@att = @att + 1
		@defn = @defn + 1
		puts "ATT +1"
		puts "DEF +1"
		Game.pause_short
	end

end
