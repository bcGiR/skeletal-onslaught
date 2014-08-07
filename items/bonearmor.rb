require_relative 'equippable'
require_relative '../modifier'

class BoneArmor < Equippable

	def initialize
		super(["Bone Armor", "Bone Arm"],
		      80,
		      "uncommon",
		      [ Modifier.new(["BoneArmorAC"],
				     "ac",
				     4 ),
	       		Modifier.new(["BoneArmorHP"],
				     "hp",
				     8 ) ] )
	end

	def equippable?
		true
	end

	def consumable?
		false
	end

end
