require_relative 'adventurer'
require_relative '../game'
require_relative '../modifier'

class Mage < Adventurer

	def initialize(name)
		super(name, 20, 12, 1, 2, 2, 2, 1.1, 0)
		@special_list = { 'missile' => 4 }
	end

	def special_attack(action, game, target)
		case action
		when 'missile'
			self.magic_missile
		when 'fireball'
			self.fireball
		when 'heal'
			self.heal
		when 'storm'
			self.storm(game, target)
		end
	end

	def special_type(action)
		case action
		when 'missile'
			return 'matt'
		when 'fireball'
			return 'matt'
		when 'heal'
			return 'self'
		when 'storm'
			return 'matt'
		end
	end

	def special_single_target(action)
		case action
		when 'missile'
			return true
		when 'fireball'
			return false
		when 'heal'
			return true
		when 'storm'
			return false
		end
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
	
	def storm(game, target)
		damage = ((Game.d3 + 1) + (Game.d100 + Game.d100 + Game.d100 + 100) * ((@lvl+9.0)/(99.0+10.0)) ** 2).to_i
		storm = Modifier.new("storminit", 'init', -2)
		unless target.modifiers.any? { |mod| mod.name == storm.name }
			target.modify(storm)
			timer = CombatTimer.new("stormtimer", game, target, 4, storm.name, 'mod')
			game.timers << timer
			puts "\n*** A swirling Ice Storm envelops #{target.name} (INIT -2) ***"
		else
			puts "\n*** A storm already envelops #{target.name} ***"
		end
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
			@special_list['fireball'] = 4
			puts "\n#{@name} has learned Fireball!"
			Game.pause_medium
		end
		if @lvl == 5
			@special_list['storm'] = 6
			puts "\n#{@name} has learned Storm!"
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
