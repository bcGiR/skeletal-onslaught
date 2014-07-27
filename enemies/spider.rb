require_relative '../items/healthpot'
require_relative '../items/manapot'
require_relative 'enemy'
require_relative '../modifier'
require_relative '../combattimer'
require_relative '../game'

class Spider < Enemy

	def initialize
		super("Giant Spider", 10, 0, 1, 1, 2, 2, 3, 0)
		@special_list = { 'web' => 0 }
	end

	def special_attack(action, game)
		case action
		when 'web'
			self.web(game)
		end
	end

	def special_type(action)
		case action
		when 'web'
			return "matt"
		end
	end

	def web(game)
		damage = ( Game.d4 + (Game.d100*3) * ( (@lvl+9.0)/(99.0+10.0) ) ** 2).to_i
		web = Modifier.new("webdefn", "defn", -1)
		unless game.hero.modifiers.any? { |mod| mod.name == "webdefn" }
			game.hero.modify(web)
			timer = CombatTimer.new("Spider Web", game, game.hero, 3, web, 'mod')
			game.timers << timer
			puts "\n*** The spider entangles you with a web (DEF -1) ***"
		else
			puts "\n*** You are already entangled in webs ***"
		end
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

		@att = ( 1.0 + 39.0 * ((@lvl-1.0)/99.0) ).to_i
		@defn = ( 1.0 + 29.0 * ((@lvl-1.0)/99.0) ).to_i
		@matt = ( 2.0 + 58.0 * ((@lvl-1.0)/99.0) ).to_i
		@mdefn = ( 2.0 + 48.0 * ((@lvl-1.0)/99.0) ).to_i

		mods.each do |mod|
			self.modify(mod)
		end
	end

	def choose_action
		roll = Game.d3
		if roll == 1
			return "specialweb"
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
		puts "\n*** The spider shivels up in a ball of dead limbs ***"
	end
end
