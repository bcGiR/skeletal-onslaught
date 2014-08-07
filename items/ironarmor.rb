require_relative 'equippable'
require_relative '../modifier'

class IronArmor < Equippable

	def initialize
		super(["Iron Armor", "Iron Arm"],
		      20,
		      "common",
		      [ Modifier.new(["IronArmorAC"],
				     "ac",
				     4 ) ] )
	end

	def equippable?
		true
	end

	def consumable?
		false
	end

end
