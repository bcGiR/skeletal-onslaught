require_relative '../items/manapot'
require_relative '../items/healthpot'
require_relative '../items/smallmanapot'
require_relative '../items/smallhealthpot'
require_relative '../items/perfectskull'
require_relative '../items/bonesword'
require_relative '../items/bonearmor'
require_relative '../items/bonebuckler'
require_relative '../items/bonenecklace'
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
			timer = CombatTimer.new("Spider Web", game, game.hero, 3, web.name, 'mod')
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
		@hp = (6 + 395 * ((@lvl+9.0)/(99.0+10.0)) ** 2).to_i

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
		roll = Game.d6

		if self.lvl < 10
			case roll
			when 1, 2, 3
				gold = Game.d6
				hero.gold = hero.gold + gold
				puts "\n#{hero.name} picks up #{gold} gold coins from the fallen #{self.name}"
			when 4, 5
				sub_roll = Game.d3
				if sub_roll == 1
					potion = MinorManaPot.new
				else
					potion = MinorHealthPot.new
				end
				hero.inv << potion
				puts "\n#{hero.name} picks up a #{potion.name} dropped by the fallen #{self.name}"
			when 6
				item_roll = Game.d4
				case item_roll
				when 1
					sub_roll = Game.d2
					if sub_roll == 1
						item = SmallManaPot.new
					else
						item = SmallHealthPot.new
					end
				when 2
					item = BoneArmor.new
				when 3
					item = BoneBuckler.new
				when 4
					item = BoneNecklace.new
				when 5
					item = BoneSword.new
				when 6
					item = PerfectSkull.new
				end
				hero.inv << item
				puts "\n#{hero.name} picks up a #{item.name} dropped by the fallen #{self.name}"
			end
			hero.exp = hero.exp + 4
		else
			case roll
			when 1, 2, 3
				gold = Game.d8 + 4
				hero.gold = hero.gold + gold
				puts "\n#{hero.name} picks up #{gold} gold coins from the fallen #{self.name}"
			when 4, 5
				sub_roll = Game.d3
				if sub_roll == 1
					potion = SmallManaPot.new
				else
					potion = SmallHealthPot.new
				end
				hero.inv << potion
				puts "\n#{hero.name} picks up a #{potion.name} dropped by the fallen #{self.name}"
			when 6
				item_roll = Game.d4
				case item_roll
				when 1
					sub_roll = Game.d2
					if sub_roll == 1
						item = SmallManaPot.new
					else
						item = SmallHealthPot.new
					end
				when 2
					item = BoneArmor.new
				when 3
					item = BoneBuckler.new
				when 4
					item = BoneNecklace.new
				when 5
					item = BoneSword.new
				when 6
					item = PerfectSkull.new
				end
				hero.inv << item
				puts "\n#{hero.name} picks up a #{item.name} dropped by the fallen #{self.name}"
			end
			hero.exp = hero.exp + 6
		end

		Game.pause_short
	end

	def death_cry
		puts "\n*** The spider shivels up in a ball of dead limbs ***"
	end
end
