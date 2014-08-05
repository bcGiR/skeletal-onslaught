require_relative 'item'

class Equippable < Item

	attr_accessor :equipped, :modifiers

	def initialize(names, value, rarity, modifiers)
		super(names, value, rarity)
		@equipped = false
		@modifiers = modifiers
	end

	def equipped?
		@equipped
	end
end
