require_relative 'equippable'
require_relative '../modifier'

class IronSword < Equippable

	def initialize
		super("Iron Sword (ATT: +1)",
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
