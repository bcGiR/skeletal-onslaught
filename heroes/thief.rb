require_relative 'adventurer'
require_relative '../game'

class Thief < Adventurer

	def initialize(name)
		super(name, 18, 12, 4, 4, 4, 4, 3, 1)
		@special_list = { 'backstab' => 4 }
	end

	def special_attack(action)
		case action
		when 'backstab'
			self.backstab
		end
	end

	def special_type(action)
		case action
		when 'backstab'
			return "att"
		end
	end

	def backstab

		@mp = @mp - 4

		damage = ( Game.d10 + 1 ) * ( Math.log2(2 * @lvl) )
		puts "\n*** The Thief tumbles behind his opponent, gouging his enemy's back ***"
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
