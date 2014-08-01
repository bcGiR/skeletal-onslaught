require_relative 'equippable'
require_relative '../modifier'

class IronArmor < Equippable

	def initialize
		super("Iron Armor (AC +1)",
		      20,
		      "common",
		      [ Modifier.new("IronArmorAC",
				     "ac",
				     1 ) ] )
	end

	def equippable?
		true
	end

	def consumable?
		false
	end

end
