require_relative 'equippable'
require_relative '../modifier'

class GoldPendant < Equippable

	def initialize
		super(["Gold Pendant", "Gold Pend", "G Pendant", "Gold P"],
		      80,
		      "uncommon",
		      [ Modifier.new(["GoldPendantHP"],
				     "hp",
				     10 ),
	       		Modifier.new(["GoldPendantMatt"],
				     "matt",
				     2 )] )
	end

	def equippable?
		true
	end

	def consumable?
		false
	end

end
