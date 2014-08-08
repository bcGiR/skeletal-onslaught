require_relative '../model'
require_relative '../game'

class Enemy < Model

	def initialize(names, hp, mp, att, defn, matt, mdefn, init, ac)
		super(names, hp, mp, att, defn, matt, mdefn, init, ac)
	end

	def drop(hero)

	end

end
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
		super(["Goblin"], 10, 0, 2, 1, 1, 1, 2, 0)
		@special_list = { 'cry' => 0 }
	end

	def special_attack(action, game, target)
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
			new_mod = Modifier.new(mod.names, mod.attr, mod.value)
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
				puts "\n#{hero.names[0]} picks up #{gold} gold coins from the fallen #{self.names[0]}"
			when 4, 5
				sub_roll = Game.d3
				if sub_roll == 1
					potion = MinorManaPot.new
				else
					potion = MinorHealthPot.new
				end
				hero.inv << potion
				puts "\n#{hero.names[0]} picks up a #{potion.names[0]} dropped by the fallen #{self.names[0]}"
			when 6
				item_roll = Game.d6
				case item_roll
				when 1
					hero.keys = hero.keys + 1
					puts "\n#{hero.names[0]} picks up a key dropped by the fallen #{self.names[0]}"
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
				unless item_roll == 1
					hero.inv << item
					puts "\n#{hero.names[0]} picks up a #{item.names[0]} dropped by the fallen #{self.names[0]}"
				end
			end
			hero.exp = hero.exp + 4
		else
			case roll
			when 1, 2, 3
				gold = Game.d8 + 4
				hero.gold = hero.gold + gold
				puts "\n#{hero.names[0]} picks up #{gold} gold coins from the fallen #{self.names[0]}"
			when 4, 5
				sub_roll = Game.d3
				if sub_roll == 1
					potion = SmallManaPot.new
				else
					potion = SmallHealthPot.new
				end
				hero.inv << potion
				puts "\n#{hero.names[0]} picks up a #{potion.names[0]} dropped by the fallen #{self.names[0]}"
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
				puts "\n#{hero.names[0]} picks up a #{item.names[0]} dropped by the fallen #{self.names[0]}"
			end
			hero.exp = hero.exp + 6
		end

		Game.pause_short
	end

	def death_cry
		puts "\n*** The goblin slumps down on the ground, dead ***"
	end
end
require_relative '../game'
require_relative '../items/manapot'
require_relative '../items/healthpot'
require_relative '../items/smallmanapot'
require_relative '../items/smallhealthpot'
require_relative '../items/skelethognostooth'
require_relative '../items/skelethognosskull'
require_relative '../items/skelethognosarm'
require_relative 'enemy'

class Skelethognos < Enemy

	def initialize
		super(["Skelethognos"], 27, 0, 2, 2, 1, 2, 3, 2)
		@special_list = { 'swing' => 0,
		    'call' => 0 }
	end

	def special_attack(action, game, target)
		case action
		when 'swing'
			self.swing
		when 'call'
			self.call(game)
		end
	end

	def special_type(action)
		case action
		when 'swing'
			return "att"
		when 'call'
			return "matt"
		end
	end

	def swing
		damage = ( ( Game.d10 + 1 ) + (Game.d100 * 7.0) * ( (@lvl+9.0)/(99.0+10.0) ) ** 2).to_i
		puts "\n*** Skelethognos pickes up a nearby skeleton, swinging it at you violently ***"
		Game.pause_short
		damage
	end

	def call(game)
		damage = 0
		puts "\n*** Skelethognos calls a fallen skeleton to rise and fight again! ***"
		Game.pause_short
		game.hero_area.enemies << game.spawn_enemy("skeleton", -2)
		damage
	end

	def attack
		damage = ( (Game.d6 + 2.0) + ( (Game.d100 * 5.0) + 184.0 ) * ( (@lvl+9.0)/(99.0+10.0) ) ** 2).to_i 
	end

	def level_up
		mods = []
		self.modifiers.each do |mod|
			new_mod = Modifier.new(mod.names, mod.attr, mod.value)
			mods << new_mod
			self.demodify(mod)
		end

		super
		@hp = (15.0 + 1485.0 * ((@lvl+9.0)/(99.0+10.0)) ** 2).to_i
		@att = ( 2.0 + 58.0 * ((@lvl-1.0)/99.0) ).to_i
		@defn = ( 2.0 + 58.0 * ((@lvl-1.0)/99.0) ).to_i
		@matt = ( 1.0 + 39.0 * ((@lvl-1.0)/99.0) ).to_i
		@mdefn = ( 2.0 + 48.0 * ((@lvl-1.0)/99.0) ).to_i
		@ac = ( 2.0 + 98.0 * ((@lvl-1.0)/99.0) ).to_i

		mods.each do |mod|
			self.modify(mod)
		end
	end

	def choose_action
		roll = Game.d6
		if roll == 1 || roll == 2
			return "specialswing"
		elsif roll == 3 || roll == 4
			return "specialcall"
		else
			return "fight"
		end
	end

	def drop(hero)
		roll = Game.d3
		case roll
		when 1
			item = SkelethognosArm.new
		when 2
			item = SkelethognosSkull.new
		when 3
			item = SkelethognosTooth.new
		end
		gold = Game.d12 + 6

		hero.inv << item
		hero.gold = hero.gold + gold
		hero.keys = hero.keys + 1
		hero.exp = hero.exp + 12

		puts "\n#{hero.names[0]} picks up a key dropped by the shattered #{self.names[0]}"
		Game.pause_short
		puts "\n#{hero.names[0]} picked up #{item.names[0]} from the vanquished #{self.names[0]}"
		Game.pause_short
		puts "\n#{hero.names[0]} found #{gold} gold among the bones of his defeated enemy"
		Game.pause_short
	end

	def death_cry
		puts "\n*** With a thunderous crack, the felled Skelethognos crashes to the dungeon floor, smashing into a hundred pieces ***"
		Game.pause_medium
	end
end
require_relative '../game'
require_relative 'enemy'
require_relative '../items/manapot'
require_relative '../items/healthpot'
require_relative '../items/smallmanapot'
require_relative '../items/smallhealthpot'
require_relative '../items/perfectskull'
require_relative '../items/bonesword'
require_relative '../items/bonearmor'
require_relative '../items/bonebuckler'
require_relative '../items/bonenecklace'

class Skeleton < Enemy

	def initialize
		super(["Skeleton", "Skelly"], 10, 0, 1, 2, 1, 1, 2, 0)
		@special_list = { 'lunge' => 0 }
	end

	def special_attack(action, game, target)
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
		mods = []
		self.modifiers.each do |mod|
			new_mod = Modifier.new(mod.names, mod.attr, mod.value)
			mods << new_mod
			self.demodify(mod)
		end

		super
		@hp = (6 + 495 * ((@lvl+9.0)/(99.0+10.0)) ** 2).to_i

		@att = ( 1.0 + 39.0 * ((@lvl-1.0)/99.0) ).to_i
		@defn = ( 2.0 + 48.0 * ((@lvl-1.0)/99.0) ).to_i
		@matt = ( 1.0 + 39.0 * ((@lvl-1.0)/99.0) ).to_i
		@mdefn = ( 1.0 + 39.0 * ((@lvl-1.0)/99.0) ).to_i

		mods.each do |mod|
			self.modify(mod)
		end
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
		roll = Game.d6

		if self.lvl < 10
			case roll
			when 1, 2, 3
				gold = Game.d6
				hero.gold = hero.gold + gold
				puts "\n#{hero.names[0]} picks up #{gold} gold coins from the fallen #{self.names[0]}"
			when 4, 5
				sub_roll = Game.d3
				if sub_roll == 1
					potion = MinorManaPot.new
				else
					potion = MinorHealthPot.new
				end
				hero.inv << potion
				puts "\n#{hero.names[0]} picks up a #{potion.names[0]} dropped by the fallen #{self.names[0]}"
			when 6
				item_roll = Game.d6
				case item_roll
				when 1
					hero.keys = hero.keys + 1
					puts "\n#{hero.names[0]} picks up a key dropped by the fallen #{self.names[0]}"
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
				unless item_roll == 1
					hero.inv << item
					puts "\n#{hero.names[0]} picks up a #{item.names[0]} dropped by the fallen #{self.names[0]}"
				end
			end
			hero.exp = hero.exp + 4
		else
			case roll
			when 1, 2, 3
				gold = Game.d8 + 4
				hero.gold = hero.gold + gold
				puts "\n#{hero.names[0]} picks up #{gold} gold coins from the fallen #{self.names[0]}"
			when 4, 5
				sub_roll = Game.d3
				if sub_roll == 1
					potion = SmallManaPot.new
				else
					potion = SmallHealthPot.new
				end
				hero.inv << potion
				puts "\n#{hero.names[0]} picks up a #{potion.names[0]} dropped by the fallen #{self.names[0]}"
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
				puts "\n#{hero.names[0]} picks up a #{item.names[0]} dropped by the fallen #{self.names[0]}"
			end
			hero.exp = hero.exp + 6
		end

		Game.pause_short
	end

	def death_cry
		puts "\n*** The skeleton collapses, it's bones rattling against the dungeon floor ***"
	end
end
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
		super(["Giant Spider", "Spider"], 10, 0, 1, 1, 2, 2, 3, 0)
		@special_list = { 'web' => 0 }
	end

	def special_attack(action, game, target)
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
		web = Modifier.new(["webdefn"], "defn", -1)
		unless game.hero.modifiers.any? { |mod| mod.names[0] == "webdefn" }
			game.hero.modify(web)
			timer = CombatTimer.new("Spider Web", game, game.hero, 3, web.names[0], 'mod')
			game.timers << timer
			puts "\n*** The spider entangles you with a web (DEFN -1) ***"
		else
			puts "\n*** You are already entangled in webs ***"
		end
		Game.pause_short
		damage
	end

	def level_up
		mods = []
		self.modifiers.each do |mod|
			new_mod = Modifier.new(mod.names, mod.attr, mod.value)
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
				puts "\n#{hero.names[0]} picks up #{gold} gold coins from the fallen #{self.names[0]}"
			when 4, 5
				sub_roll = Game.d3
				if sub_roll == 1
					potion = MinorManaPot.new
				else
					potion = MinorHealthPot.new
				end
				hero.inv << potion
				puts "\n#{hero.names[0]} picks up a #{potion.names[0]} dropped by the fallen #{self.names[0]}"
			when 6
				item_roll = Game.d6
				case item_roll
				when 1
					hero.keys = hero.keys + 1
					puts "\n#{hero.names[0]} picks up a key dropped by the fallen #{self.names[0]}"
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
				unless item_roll == 1
					hero.inv << item
					puts "\n#{hero.names[0]} picks up a #{item.names[0]} dropped by the fallen #{self.names[0]}"
				end
			end
			hero.exp = hero.exp + 4
		else
			case roll
			when 1, 2, 3
				gold = Game.d8 + 4
				hero.gold = hero.gold + gold
				puts "\n#{hero.names[0]} picks up #{gold} gold coins from the fallen #{self.names[0]}"
			when 4, 5
				sub_roll = Game.d3
				if sub_roll == 1
					potion = SmallManaPot.new
				else
					potion = SmallHealthPot.new
				end
				hero.inv << potion
				puts "\n#{hero.names[0]} picks up a #{potion.names[0]} dropped by the fallen #{self.names[0]}"
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
				puts "\n#{hero.names[0]} picks up a #{item.names[0]} dropped by the fallen #{self.names[0]}"
			end
			hero.exp = hero.exp + 6
		end

		Game.pause_short
	end

	def death_cry
		puts "\n*** The spider shivels up in a ball of dead limbs ***"
	end
end
