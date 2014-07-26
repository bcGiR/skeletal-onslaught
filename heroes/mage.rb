require_relative 'adventurer'
require_relative '../game'

class Mage < Adventurer

	def initialize(name)
		super(name, 18, 12, 4, 4, 6, 6, 1, 0)
		@special_list = { 'missile' => 4 }
	end

	def special_attack(action)
		case action
		when 'missile'
			self.magic_missile
		end
	end

	def special_type(action)
		case action
		when 'missile'
			return "matt"
		end
	end

	def magic_missile

		@mp = @mp - 4

		hit = Game.d100
		damage = 0
		if hit >= 20
			damage = ( ( Game.d4 + Game.d4 + 3 ) + ( (Game.d100 + Game.d100 + Game.d100)*2 + 300 ) * ( (@lvl + 9.0)/(99.0 + 10.0) ) ** 2 ).to_i
			puts "\n*** A magic missle erupts from the Mages fingertips ***"
		else
			puts "\n*** A flash of light erupts from the fizzled spell ***"
		end
		Game.pause_short
		damage
	end

	def level_up
		super
		new_att = ( 1.0 + 49.0 * ((@lvl-1)/99) ).to_i
		new_defn = ( 2.0 + 58.0 * ((@lvl-1)/99) ).to_i
		new_matt = ( 2.0 + 78.0 * ((@lvl-1)/99) ).to_i
		new_mdefn = ( 2.0 + 78.0 * ((@lvl-1)/99) ).to_i

		att_diff = new_att - @att
		defn_diff = new_defn - @defn
		matt_diff = new_matt - @matt
		mdefn_diff = new_mdefn - @mdefn

		@att = new_att
		@defn = new_defn
		@matt = new_matt
		@mdefn = new_mdefn

		puts "\nATT: +#{att_diff}"
		puts "\nDEF: +#{def_diff}"
		puts "\nM.ATT: +#{matt_diff}"
		puts "\nM.DEF: +#{mdefn_diff}"
		Game.pause_short
	end

end
