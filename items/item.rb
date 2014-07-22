class Item

	attr_accessor :name, :value, :rarity

	def initialize(name, value, rarity)
		@name = name
		@value = value
		@rarity = rarity
	end

	def equippable?
	end
	
	def consumable?
	end
end
