require_relative 'adventurer'
require_relative '../game'
require_relative '../modifier'

class Fighter < Adventurer

	def initialize(name)
		super(name, 18, 12, 2, 2, 1, 2, 2.1, 1)
		@special_list = { 'flurry' => 4 }
	end

	def special_attack(action, game)
		case action
		when 'flurry'
			self.flurry
		end
	end

	def special_type(action)
		case action
		when 'flurry'
			return "att"
		end
	end

	def flurry

		@mp = @mp - 4

		damage = ( (Game.d2 + Game.d2 + Game.d2 + Game.d2 + 1.0) +
			  ( Game.d100 + Game.d100 + Game.d100 + 200.0 ) * ( (@lvl + 9.0)/(99.0 + 10.0) ) ** 2 ).to_i

		puts "\n*** A flurry of sword strikes assualt the Fighters foe ***"
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
		new_att = ( 2.0 + 58.0 * ((@lvl-1.0)/99.0) ).to_i
		new_defn = ( 2.0 + 78.0 * ((@lvl-1.0)/99.0) ).to_i
		new_matt = ( 1.0 + 49.0 * ((@lvl-1.0)/99.0) ).to_i
		new_mdefn = ( 2.0 + 58.0 * ((@lvl-1.0)/99.0) ).to_i

		att_diff = new_att - @att
		defn_diff = new_defn - @defn
		matt_diff = new_matt - @matt
		mdefn_diff = new_mdefn - @mdefn

		@att = new_att
		@defn = new_defn
		@matt = new_matt
		@mdefn = new_mdefn

		puts "ATT: +#{att_diff}"
		puts "DEF: +#{defn_diff}"
		puts "M.ATT: +#{matt_diff}"
		puts "M.DEF: +#{mdefn_diff}"

		mods.each do |mod|
			self.modify(mod)
		end
		Game.pause_short
	end

end
