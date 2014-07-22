require_relative '../model'
require_relative '../items/healthpot'

class Adventurer < Model
	
	attr_accessor :inv, :gold, :special_single_target

	def initialize(name, hp, mp, att, defn, init, ac)
		super(name, hp, mp, att, defn, init, ac)
		@inv = []
		@gold = 20
		@special_single_target = true
	end

	def use_consumable(consumable)
		item_index = @inv.find_index { |i| i.name.downcase == consumable.name.downcase }
		consumable.consume(self)
		@inv.delete_at(item_index)
		@inv.compact
	end

	def level_up
		super
		@hp = @hp + 4
		@hpmax = @hpmax + 4
		@mp = @mp + 4
		@mpmax = @mpmax + 4
		puts "\n*** #{name} has reached level #{lvl} ***"
		puts "HP +4"
		puts "MP +4"
	end
end
