require_relative 'adventurer'
require_relative '../game'

class Mage < Adventurer

	def initialize(name)
		super(name, 18, 12, 1, 2, 2, 2, 1.1, 0)
		@special_list = { 'missile' => 4 }
	end

	def special_attack(action, game)
		case action
		when 'missile'
			self.magic_missile
        when 'fireball'
            self.fireball
		end
	end

	def special_type(action)
		case action
		when 'missile'
			return "matt"
        when 'fireball'
            return "matt"
		end
	end

	def special_single_target(action)
        case action
        when 'missile'
            return true
        when 'fireball'
            return false
        end
    	end

	def magic_missile
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

    def fireball
        damage = ((Game.d4 + 1) + (Game.d100 + Game.d100 + Game.d100 + 150) * ((@lvl+9.0)/(99.0+10.0)) ** 2).to_i
        puts "\n*** The Mages fireball immolates everything in its path ***"
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
		if @lvl == 3
			@special_list['fireball'] = 4
			puts "\n#{@name} has learned Fireball!"
			Game.pause_medium
		end
		new_att = ( 1.0 + 49.0 * ((@lvl-1.0)/99.0) ).to_i
		new_defn = ( 2.0 + 58.0 * ((@lvl-1.0)/99.0) ).to_i
		new_matt = ( 2.0 + 78.0 * ((@lvl-1.0)/99.0) ).to_i
		new_mdefn = ( 2.0 + 78.0 * ((@lvl-1.0)/99.0) ).to_i
      	        new_ac = ( 0 + 20 * ((@lvl-1.0)/99.0) ** 2).to_i

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
