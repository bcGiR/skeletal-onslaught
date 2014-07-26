require_relative '../game'
require_relative 'enemy'
require_relative '../items/healthpot'
require_relative '../items/manapot'

class Skeleton < Enemy

	def initialize
		super("Skeleton", 10, 0, 2, 4, 2, 4, 2, 0)
		@special_list = { 'lunge' => 0 }
	end

	def special_attack(action)
		case action
		when 'lunge'
			self.lunge
		end
	end

	def special_type(action)
		case action
		when 'lunge'
			return "att"
		end
	end

	def lunge
		damage = ( ( Game.d8 + 1 ) + (Game.d100 * 6.0) * ( (@lvl+9.0)/(99.0+10.0) ) ** 2).to_i 
		puts "\n*** Shrieking, the skeleton lunges at you ***"
		Game.pause_short
		damage
	end

	def level_up
		super
		@hp = (6 + 495 * ((@lvl+9.0)/(99.0+10.0)) ** 2).to_i
		@att = @att + 1
		@defn = @defn + 1
	end

	def choose_action
		roll = Game.d4
		if roll == 1
			return "speciallunge"
		else
			return "fight"
		end
	end

	def drop(hero)
		#Rolls d100 and adds +5 to the roll per level after level 1
		roll = Game.d100 + (self.lvl - 1) * 5
		if roll > 100
			roll = 100
		end

		case roll
		when 1..90
			gold = Game.d4 + (self.lvl - 1)
			hero.gold = hero.gold + gold
			puts "\n#{hero.name} picks up #{gold} gold dropped by the fallen #{self.name}"
		when 91..100
			sub_roll = Game.d3
			if sub_roll == 1
				potion = ManaPot.new
			else
				potion = HealthPot.new
			end
			hero.inv << potion
			puts "\n#{hero.name} picks up a #{potion.name} dropped by the fallen #{self.name}"
		end

		hero.exp = hero.exp + 5 + (self.lvl - 1)
		Game.pause_short
	end

	def death_cry
		puts "\n*** The skeleton collapses, it's bones rattling against the dungeon floor ***"
	end
end
