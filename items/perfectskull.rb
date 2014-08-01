require_relative 'equippable'
require_relative '../modifier'

class PerfectSkull < Equippable

	def initialize
		super("Perfect Whole Skull (M.ATT: +4 | ATT: +1)",
		      60,
		      "uncommon",
		      [ Modifier.new("SkullMatt",
				     "matt",
				     4 ),
	       		Modifier.new("SkullMatt",
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
