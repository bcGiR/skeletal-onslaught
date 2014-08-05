require_relative 'item'

class Consumable < Item

	def initialize(names, value, rarity)
		super(names, value, rarity)
	end

	def consume(target)
	end
	
end
