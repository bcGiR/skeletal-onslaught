require_relative '../game'
require_relative 'enemy'

class Skelethognos < Enemy

	def initialize
		super("Skelethognos", 27, 0, 2, 2, 1, 2, 3, 1)
		@special_list = { 'swing' => 0,
                          'call' => 0 }
	end

	def special_attack(action, game)
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
			new_mod = Modifier.new(mod.name, mod.attr, mod.value)
			mods << new_mod
			self.demodify(mod)
		end

		super
		@hp = (15.0 + 1485.0 * ((@lvl+9.0)/(99.0+10.0)) ** 2).to_i
		@att = ( 2.0 + 58.0 * ((@lvl-1.0)/99.0) ).to_i
		@defn = ( 2.0 + 58.0 * ((@lvl-1.0)/99.0) ).to_i
		@matt = ( 1.0 + 39.0 * ((@lvl-1.0)/99.0) ).to_i
		@mdefn = ( 2.0 + 48.0 * ((@lvl-1.0)/99.0) ).to_i

		mods.each do |mod|
			self.modify(mod)
		end
	end

	def choose_action
		roll = Game.d6
		if roll == 1 || roll == 2
			return "specialswing"
        elsif roll == 3
            return "specialcall"
		else
			return "fight"
		end
	end

	def drop(hero)
		gold = Game.d20
		hero.gold = hero.gold + gold
		puts "\n#{hero.name} picks up #{gold} gold dropped by the fallen #{self.name}"

		hero.exp = hero.exp + 10
		Game.pause_short
	end

	def death_cry
		puts "\n*** With a thunderous crack, the felled Skelethognos crashes to the dungeon floor, smashing into a hundred pieces ***"
		Game.pause_medium
	end
end
