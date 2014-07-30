require_relative 'equippable'
require_relative '../modifier'

class SilkRobe < Equippable

	def initialize
		super("Silk Mage's Robe",
		      20,
		      "common",
		      [ Modifier.new("SilkRobeMdefn",
				     "mdefn",
				     1 ) ] )
	end

	def equippable?
		true
	end

	def consumable?
		false
	end

end
