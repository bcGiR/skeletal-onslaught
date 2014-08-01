require_relative 'equippable'
require_relative '../modifier'

class SkelethognosArm < Equippable

	def initialize
		super("Skelethognos' Arm (ATT: +6 | M.ATT: +6)",
		      120,
		      "rare",
		      [ Modifier.new("SkelArmAtt",
				     "att",
				     6 ),
	       		Modifier.new("SkelArmMatt",
				     "matt",
				     6 ) ] )
	end

	def equippable?
		true
	end

	def consumable?
		false
	end

end
