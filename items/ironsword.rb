require_relative 'equippable'
require_relative '../modifier'

class IronSword < Equippable

	def initialize
		super("Iron Sword",
		      10,
		      "common",
		      [ Modifier.new("IronSwordAtt",
				     "att",
				     1 ) ] )
	end

	def equippable?
		true
	end

	def consumable?
		false
	end

end
