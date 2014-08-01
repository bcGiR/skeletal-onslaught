require_relative 'equippable'
require_relative '../modifier'

class SkelethognosSkull < Equippable

	def initialize
		super("Skelethognos' Skull (HP: +16 | DEF: +2 | M.DEF +2)",
		      160,
		      "rare",
		      [ Modifier.new("SkelSkullHP",
				     "hp",
				     16 ),
	       		Modifier.new("SkelSkullDef",
				     "def",
				     2 ),
	       		Modifier.new("SkelSkullMdef",
				     "mdef",
				     2 ) ] )
	end

	def equippable?
		true
	end

	def consumable?
		false
	end

end
