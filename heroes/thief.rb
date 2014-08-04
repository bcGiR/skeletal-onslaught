require_relative 'adventurer'
require_relative '../game'
require_relative '../modifier'

class Thief < Adventurer

	def initialize(name)
		super(name, 18, 12, 2, 1, 2, 1, 3.1, 1)
		@special_list = { 'backstab' => 4 }
	end

	def special_attack(action, game)
		case action
		when 'backstab'
			self.backstab
		when 'fan'
			self.fan
		when 'heal'
			self.heal
		end
	end

	def special_type(action)
		case action
		when 'backstab'
			return "att"
		when 'fan'
			return "att"
		when 'heal'
			return 'self'
		end
	end

	def special_single_target(action)
		case action  
		when 'backstab'
			return true
		when 'fan'
			return false
		end
	end


	def backstab
		damage = ( (Game.d10 + 1.0) + (Game.d100*7.0 + 1.0) * ( (@lvl + 9.0)/(99.0 + 10.0) ) ** 2 ).to_i
		puts "\n*** The Thief tumbles behind his opponent, gouging his enemy's back ***"
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
		puts "\n***#{@name} has healed for #{heal} HP ***"
	end

	def fan
		damage = ( Game.d6 + (Game.d100*3.5 + 1.0) * ((@lvl+9.0)/(99.0+10.0)) ** 2).to_i
		puts "\n*** A throwing dagger flashes out from the theif, plunging into his enemy ***"
		Game.pause_short
		damage
	end

	def level_up
		mods = []
		count = 0
		until count == self.modifiers.count
			new_mod = Modifier.new(self.modifiers[count].name, self.modifiers[count].attr, self.modifiers[count].value)
			mods << new_mod
			self.demodify(self.modifiers[count])
		end

		super
		if @lvl == 3
			@special_list['fan'] = 4
			puts "#{@name} has learned Fan of Knives!"
			Game.pause_medium
		end
		new_att = ( 2.0 + 78.0 * ((@lvl-1.0)/99.0) ).to_i
		new_defn = ( 1.0 + 49.0 * ((@lvl-1.0)/99.0) ).to_i
		new_matt = ( 2.0 + 78.0 * ((@lvl-1.0)/99.0) ).to_i
		new_mdefn = ( 1.0 + 49.0 * ((@lvl-1.0)/99.0) ).to_i
		new_ac = ( 1.0 + 54.0 * ((@lvl-1.0)/99.0) ** 2).to_i

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
