require_relative 'equippable'
require_relative '../modifier'

class BlackPearl < Equippable

	def initialize
		super(["Mysterious Black Pearl", "Black Pearl", "MBP", "Mysterious"],
		      100,
		      "rare",
		      [] )
	end

	def equippable?
		true
	end

	def consumable?
		false
	end

end
