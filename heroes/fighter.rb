require_relative 'adventurer'
require_relative '../game'
require_relative '../modifier'

class Fighter < Adventurer

	def initialize(names)
		super(names, 20, 12, 2, 2, 1, 2, 2.1, 2)
		@special_list = { 'flurry' => 4 }
	end

	def special_attack(action, game, target)
		case action
		when 'flurry'
			self.flurry
		when 'cleave'
			self.cleave
		when 'heal'
			self.heal
		when 'shout'
			self.shout(game, target)
		end
	end

	def special_type(action)
		case action
		when 'flurry'
			return 'att'
		when 'cleave'
			return 'att'
		when 'heal'
			return 'self'
		when 'shout'
			return 'matt'
		end

	end

	def special_single_target(action)
		case action
		when 'flurry'
			return true
		when 'cleave'
			return false
		when 'heal'
			return true
		when 'shout'
			return false
		end
	end

	def flurry
		damage = ( (Game.d2 + Game.d2 + Game.d2 + Game.d2 + 1.0) +
			  ( Game.d100 + Game.d100 + Game.d100 + 200.0 ) * ( (@lvl + 9.0)/(99.0 + 10.0) ) ** 2 ).to_i

		puts "\n*** A flurry of sword strikes assualt the Fighters foe ***"
		Game.pause_short
		damage
	end

	def cleave
		damage = ( (Game.d2 + Game.d2 + 1) + ( Game.d100 + Game.d100 + 100.0) * ((@lvl+9.0)/(99.0+10.0)) ** 2).to_i
		puts "\n*** The Fighter cleaves his sword through his opponents ***"
		Game.pause_short
		damage
	end

	def heal
		heal = ( (Game.d6 + 3.0) + ( (Game.d100 * 5.0) + 300.0 ) * ( (@lvl+9.0)/(99.0+10.0) ) ** 2).to_i
		if heal + @hp > @hpmax
			@hp = @hpmax
		else
			@hp = @hp + heal
		end
		puts "\n***#{@names[0]} has healed for #{heal} HP ***"
	end

	def shout(game, target)
		damage = ( (Game.d3 + 1) + ( Game.d100 + Game.d100 + 80.0 ) * ((@lvl+9.0)/(99.0+10.0)) ** 2).to_i
		shout1 = Modifier.new(["shoutatt"], 'att', -1)
		shout2 = Modifier.new(["shoutdefn"], 'defn', -1)
		unless target.modifiers.any? { |mod| mod.names[0] == shout1.names[0] }
			target.modify(shout1)
			target.modify(shout2)
			timer1 = CombatTimer.new("shout1timer", game, target, 4, shout1.names[0], 'mod')
			timer2 = CombatTimer.new("shout2timer", game, target, 4, shout2.names[0], 'mod')
			game.timers << timer1
			game.timers << timer2
			puts "\n*** The Fighter lets out a deafening war cry, demoralizing the #{target.names[0]} \n(ATT: -1 DEFN: -1) ***"
		else
			puts "\n*** #{target.names[0]} is already demoralized ***"
		end
		Game.pause_short
		damage
	end

	def level_up
		mods = []
		count = 0
		until count == self.modifiers.count
			new_mod = Modifier.new(self.modifiers[count].names, self.modifiers[count].attr, self.modifiers[count].value)
			mods << new_mod
			self.demodify(self.modifiers[count])
		end

		super
		if @lvl == 3
			special_list['cleave'] = 4
			puts "\n#{@names[0]} has learned Cleave!"
			Game.pause_medium
		end
		if @lvl == 5
			special_list['shout'] = 6
			puts "\n#{@names[0]} has learned Shout!"
			Game.pause_medium
		end
		new_att = ( 2.0 + 58.0 * ((@lvl-1.0)/99.0) ).to_i
		new_defn = ( 2.0 + 78.0 * ((@lvl-1.0)/99.0) ).to_i
		new_matt = ( 1.0 + 49.0 * ((@lvl-1.0)/99.0) ).to_i
		new_mdefn = ( 2.0 + 58.0 * ((@lvl-1.0)/99.0) ).to_i
		new_ac = ( 2.0 + 108 * ((@lvl-1.0)/(99.0)) ** 2).to_i

		att_diff = new_att - @att
		defn_diff = new_defn - @defn
		matt_diff = new_matt - @matt
		mdefn_diff = new_mdefn - @mdefn
		ac_diff = new_ac - @ac

		@att = new_att
		@defn = new_defn
		@matt = new_matt
		@mdefn = new_mdefn
		@ac = new_ac

		puts "ATT: +#{att_diff}"
		puts "DEF: +#{defn_diff}"
		puts "M.ATT: +#{matt_diff}"
		puts "M.DEF: +#{mdefn_diff}"
		puts "AC: +#{ac_diff}"


		mods.each do |mod|
			self.modify(mod)
		end

		Game.pause_short
	end

end
