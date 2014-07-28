require_relative '../model'
require_relative '../items/healthpot'

class Adventurer < Model
	
	attr_accessor :inv, :gold

	def initialize(name, hp, mp, att, defn, matt, mdefn, init, ac)
		super(name, hp, mp, att, defn, matt, mdefn, init, ac)
		@inv = []
		@gold = 20
	end

	def use_consumable(consumable)
		item_index = @inv.find_index { |i| i.name.downcase == consumable.name.downcase }
		consumable.consume(self)
		@inv.delete_at(item_index)
		@inv.compact
	end

	def level_up
		super
		new_hp = (10.0 + 998.0 * ((@lvl + 9.0)/(99.0 + 10.0)) ** 2).to_i
		new_mp = (6.0 + 694.0 * ((@lvl + 9.0)/(99.0 + 10.0)) ** 2).to_i
		hp_diff = new_hp - @hpmax
		mp_diff = new_mp - @mpmax
		@hpmax = new_hp
		@mpmax = new_mp
		@hp = @hp + hp_diff
		@mp = @mp + mp_diff
		puts "\n*** #{name} has reached level #{lvl} ***"
		puts "HP +#{hp_diff}"
		puts "MP +#{mp_diff}"
	end
end
