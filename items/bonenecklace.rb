require_relative 'equippable'
require_relative '../modifier'

class BoneNecklace < Equippable

	def initialize
		super(["Necklace of Bones", "Neck Bone", "Necklace"],
		      80,
		      "uncommon",
		      [ Modifier.new(["BoneNecklaceMatt"],
				     "matt",
				     1 ),
	       		Modifier.new(["BoneNecklaceMdefn"],
				     "mdefn",
				     3 )] )
	end

	def equippable?
		true
	end

	def consumable?
		false
	end

end
