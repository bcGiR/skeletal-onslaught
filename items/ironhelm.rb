require_relative 'equippable'
require_relative '../modifier'

class IronHelm < Equippable

	def initialize
		super("Iron Helm",
		      10,
		      "common",
		      [ Modifier.new("IronHelmHP",
				     "hp",
				     3 ) ] )
	end

	def equippable?
		true
	end

	def consumable?
		false
	end

end
