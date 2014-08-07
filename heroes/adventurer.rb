require_relative '../model'
require_relative '../items/healthpot'

class Adventurer < Model
	
	attr_accessor :role, :inv, :gold, :keys

	def initialize(names, role, hp, mp, att, defn, matt, mdefn, init, ac)
		super(names, hp, mp, att, defn, matt, mdefn, init, ac)
		@role = role
		@inv = []
		@gold = 30
		@keys = 0
	end

	def use_consumable(consumable)
		item_index = @inv.find_index { |i| i.names[0].downcase == consumable.names[0].downcase }
		consumable.consume(self)
		@inv.delete_at(item_index)
		@inv.compact
	end

	def level_up
		super
	end
end
