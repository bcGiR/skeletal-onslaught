require_relative 'equippable'
require_relative '../modifier'

class IronShield < Equippable

	def initialize
		super(["Iron Shield"],
		      20,
		      "common",
		      [ Modifier.new(["IronShieldDefn"],
				     "defn",
				     1 ) ] )
	end

	def equippable?
		true
	end

	def consumable?
		false
	end

end
