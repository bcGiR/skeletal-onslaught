require_relative 'item'

class Equippable < Item

	attr_accessor :equipped, :modifiers

	def initialize(name, value, rarity, modifiers)
		super(name, value, rarity)
		@equipped = false
		@modifiers = modifiers
	end

	def equipped?
		@equipped
	end
end
