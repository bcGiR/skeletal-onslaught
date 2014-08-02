require_relative 'equippable'
require_relative '../modifier'

class BoneBuckler < Equippable

	def initialize
		super("Bone Buckler",
		      80,
		      "uncommon",
		      [ Modifier.new("BoneBucklerDefn",
				     "defn",
				     3 ),
	       		Modifier.new("BoneBucklerATT",
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
