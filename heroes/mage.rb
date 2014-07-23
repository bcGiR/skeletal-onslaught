require_relative 'adventurer'
require_relative '../game'

class Mage < Adventurer

	def initialize(name)
		super(name, 12, 20, 4, 6, 1, 0)
		@special_list = { 'missile' => 4 }
	end

	def special_attack(action)
		case action
		when 'missile'
			self.magic_missile
		end
	end

	def magic_missile

		@mp = @mp - 4

		hit = Game.d100
		damage = 0
		if hit >= 20
			damage =  ( Game.d6 + Game.d6 + 3 ) * ( Math.log2(2 * @lvl) )
			puts "\n*** A magic missle erupts from the Mages fingertips ***"
		else
			puts "\n*** A flash of light erupts from the fizzled spell ***"
		end
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
