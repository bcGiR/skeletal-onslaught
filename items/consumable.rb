require_relative 'item'

class Consumable < Item

	def initialize(name, value, rarity)
		super(name, value, rarity)
	end

	def consume(target)
	end
	
end
