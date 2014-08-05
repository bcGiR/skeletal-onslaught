require_relative 'container'
require_relative 'smallhealthpot'
require_relative 'smallmanapot'

class SkelethognosChest < Container

	def initialize
		super(["Skelethognos' Chest", "Skel Chest", "Chest"],
		      [],
			false)
	end
end
