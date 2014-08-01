require_relative '../items/manapot'
require_relative '../items/healthpot'
require_relative '../items/smallmanapot'
require_relative '../items/smallhealthpot'
require_relative '../items/perfectskull'
require_relative '../items/bonesword'
require_relative '../items/bonearmor'
require_relative '../items/bonebuckler'
require_relative '../items/bonenecklace'
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
		damage = ( ( Game.d3 + Game.d3 + 1) + ( (Game.d100 + Game.d100 + Game.d100 + Game.d100 + Game.d100 ) * ( (@lvl+9.0)/(99.0+10.0) ) ** 2)).to_i 
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
		puts "\n*** The goblin slumps down on the ground, dead ***"
	end
end
