class Item

	attr_accessor :names, :value, :rarity

	def initialize(names, value, rarity)
		@names = names
		@value = value
		@rarity = rarity
	end

	def equippable?
	end
	
	def consumable?
	end
end
