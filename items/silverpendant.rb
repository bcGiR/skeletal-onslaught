require_relative 'equippable'
require_relative '../modifier'

class SilverPendant < Equippable

	def initialize
		super("Silver Pendant",
		      80,
		      "uncommon",
		      [ Modifier.new("SilverPendantMP",
				     "mp",
				     6 ),
	       		Modifier.new("SilverPendantMdefn",
				     "mdefn",
				     2 )] )
	end

	def equippable?
		true
	end

	def consumable?
		false
	end

end
