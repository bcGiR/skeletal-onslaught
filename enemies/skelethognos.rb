require_relative '../game'
require_relative 'enemy'

class Skelethognos < Enemy

	def initialize
		super("Skelethognos", 27, 0, 6, 6, 6, 6, 3, 1)
		@special_list = { 'swing' => 0 }
	end

	def special_attack(action)
		case action
		when 'swing'
			self.swing
		end
	end

	def special_type(action)
		case action
		when 'swing'
			return "att"
		end
	end

	def swing
		damage = ( Game.d10 + 3 ) * ( Math.log2(2 * @lvl) )
		puts "\n*** Skelethognos pickes up a nearby skeleton, swinging it at you violently ***"
		Game.pause_short
		damage
	end

	def attack
		damage = ( Game.d8 + 1 ) * ( Math.log2(2 * @lvl) ) 
	end

	def level_up
		super
		@hp = (15.0 + 1485.0 * ((@lvl+9.0)/(99.0+10.0)) ** 2).to_i
		@att = @att + 1
		@defn = @defn + 1
	end

	def choose_action
		roll = Game.d4
		if roll == 1
			return "specialswing"
		else
			return "fight"
		end
	end

	def drop(hero)
		gold = Game.d20
		hero.gold = hero.gold + gold
		puts "\n#{hero.name} picks up #{gold} gold dropped by the fallen #{self.name}"

		hero.exp = hero.exp + 10
		Game.pause_short
	end

	def death_cry
		puts "\n*** With a thunderous crack, the felled Skelethognos crashes to the dungeon floor, smashing into a hundred pieces ***"
		Game.pause_medium
	end
end
