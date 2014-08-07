require_relative 'adventurer'
require_relative '../game'
require_relative '../modifier'

class Assassin < Adventurer

	def initialize(names)
		super(names, "Assassin", 20, 12, 2, 2, 2, 2, 3.1, 0)
		@special_list = { 'assassinate' => 8 }
	end

	def special_attack(action, game, target)
		case action
		when 'assassinate'
			self.assassinate(target)
		when 'gambit'
			self.gambit(target)
		when 'heal'
			self.heal
		when 'disarm'
			self.disarm(game, target)
		end
	end

	def special_type(action)
		case action
		when 'assassinate'
			return 'none'
		when 'gambit'
			return 'none'
		when 'heal'
			return 'self'
		when 'disarm'
			return 'att'
		end
	end

	def special_single_target(action)
		case action  
		when 'assassinate'
			return true
		when 'gambit'
			return false
		when 'heal'
			return true
		when 'disarm'
			return false
		end
	end


	def assassinate(target)
		if target.names[0].downcase == 'skelethognos'
			damage = target.hp/2
		else
			damage = target.hp
		end
		puts "\n*** The assassin skillfully dispatches his enemy ***"
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

	def gambit(target)
		damage = 0
		roll = Game.d2
		puts "\n*** The assassin summons a dangerously unstable amount of magical energy ***"
		Game.pause_short
		if roll == 1
			if target.names[0].downcase == 'skelethognos'
				damage = target.hp/2
			else
				damage = target.hp
			end
			puts "\n*** The assassin's death magic consumes its victim ***"
		else
			puts "\n*** The assassin was unable to control the violent force ***"
		end
		Game.pause_short
		damage
	end

	def disarm(game, target)
		damage = ( (Game.d4 + 1) + (Game.d100*3.0) * ((@lvl+9.0)/(99.0+10.0)) ** 2).to_i
		disarm = Modifier.new("disarmdefn", 'att', -2)
		unless target.modifiers.any? { |mod| mod.names[0] == disarm.names[0] }
			target.modify(disarm)
			timer = CombatTimer.new("Disarm", game, target, 4, disarm.names[0], 'mod')
			game.timers << timer
			puts "\n*** The Assassin's slight-of-hand disarms #{target.names[0]} (ATT -1) ***"
		else
			puts "\n*** #{target.names[0]} is already disarmed ***"
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
		puts "\n*** #{@names[0]} has reached level #{lvl} ***"
		Game.pause_short
		if @lvl == 3
			@special_list['gambit'] = 6
			puts "#{@names[0]} has learned Magic Gambit!"
			Game.pause_medium
		end
		if @lvl == 5
			@special_list['disarm'] = 4
			puts "#{@names[0]} has learned Disarm!"
			Game.pause_medium
		end
		new_hp = (12.0 + 998.0 * ((@lvl + 9.0)/(99.0 + 10.0)) ** 2).to_i
		new_mp = (6.0 + 694.0 * ((@lvl + 9.0)/(99.0 + 10.0)) ** 2).to_i
		new_att = ( 2.0 + 73.0 * ((@lvl-1.0)/99.0) ).to_i
		new_defn = ( 2.0 + 63.0 * ((@lvl-1.0)/99.0) ).to_i
		new_matt = ( 2.0 + 73.0 * ((@lvl-1.0)/99.0) ).to_i
		new_mdefn = ( 2.0 + 63.0 * ((@lvl-1.0)/99.0) ).to_i
		new_ac = ( 2.0 + 40.0 * ((@lvl-1.0)/99.0) ** 2).to_i

		hp_diff = new_hp - @hpmax
		mp_diff = new_mp - @mpmax
		att_diff = new_att - @att
		defn_diff = new_defn - @defn
		matt_diff = new_matt - @matt
		mdefn_diff = new_mdefn - @mdefn
		ac_diff = new_ac - @ac

		@hpmax = new_hp
		@mpmax = new_mp
		@hp = @hp + hp_diff
		@mp = @mp + mp_diff
		@att = new_att
		@defn = new_defn
		@matt = new_matt
		@mdefn = new_mdefn
		@ac = new_ac

		puts "HP +#{hp_diff}"
		puts "MP +#{mp_diff}"
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
