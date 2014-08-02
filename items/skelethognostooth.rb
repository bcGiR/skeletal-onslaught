require_relative 'equippable'
require_relative '../modifier'

class SkelethognosTooth < Equippable

	def initialize
		super("Skelethognos' Biggest Tooth",
		      140,
		      "rare",
		      [ Modifier.new("SkelToothHP",
				     "hp",
				     16 ),
	       		Modifier.new("SkelToothMP",
				     "mp",
				     16 ),
	       		Modifier.new("SkelSkullAC",
				     "ac",
				     4 ) ] )
	end

	def equippable?
		true
	end

	def consumable?
		false
	end

end
