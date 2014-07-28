require_relative '../items/healthpot'
require_relative '../items/manapot'
require_relative '../game'
require_relative 'enemy'
require_relative '../combattimer'

class Goblin < Enemy

	def initialize
		super("Goblin", 10, 0, 2, 1, 1, 1, 2, 0)
		@special_list = { 'cry' => 0 }
	end

	def special_attack(action, game)
		case action
		when 'cry'
			self.cry(game)
		end
	end

	def special_type(action)
		case action
		when 'cry'
			return "att"
		end
	end

	def cry(game)
		damage = ( ( Game.d3 + Game.d3 + 1) + ( (Game.d100 + Game.d100 + Game.d100 + Game.d100 + Game.d100 ) * ( (@lvl+9.0)/(99.0+10.0) ) ** 2).to_i 
        timer = CombatTimer.new("Goblin blade wound", game, game.hero, 2, (1 + 50 * ((@lvl+9.0)/(99.0+10.0)) ** 2).to_i, 'dmg')
        game.timers << timer
		puts "\n*** The goblin attempts a vicious strike ***"
		Game.pause_short
		damage
	end

	def level_up
		mods = []
		self.modifiers.each do |mod|
			new_mod = Modifier.new(mod.name, mod.attr, mod.value)
			mods << new_mod
			self.demodify(mod)
		end

		super
		@hp = (6 + 495 * ((@lvl+9.0)/(99.0+10.0)) ** 2).to_i

		@att = ( 2.0 + 48.0 * ((@lvl-1.0)/99.0) ).to_i
		@defn = ( 1.0 + 39.0 * ((@lvl-1.0)/99.0) ).to_i
		@matt = ( 1.0 + 39.0 * ((@lvl-1.0)/99.0) ).to_i
		@mdefn = ( 1.0 + 39.0 * ((@lvl-1.0)/99.0) ).to_i

		mods.each do |mod|
			self.modify(mod)
		end
	end

	def choose_action
		roll = Game.d4
		if roll == 1
			return "specialcry"
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

		hero.exp = hero.exp + ( 5 + 95 * ((self.lvl-1.0)/99.0) ).to_i
		Game.pause_short
	end

	def death_cry
		puts "\n*** The goblin slumps down on the ground, dead ***"
	end
end
