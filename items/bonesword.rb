require_relative 'equippable'
require_relative '../modifier'

class BoneSword < Equippable

	def initialize
		super("Bone Sword",
		      60,
		      "uncommon",
		      [ Modifier.new("BoneSwordAtt",
				     "att",
				     3 ),
	       		Modifier.new("BoneSwordDefn",
				     "defn",
				     1)	] )
	end

	def equippable?
		true
	end

	def consumable?
		false
	end

end
