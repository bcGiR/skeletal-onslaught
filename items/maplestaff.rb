require_relative 'equippable'
require_relative '../modifier'

class MapleStaff < Equippable

	def initialize
		super("Maple Staff (M.ATT: +1",
		      10,
		      "common",
		      [ Modifier.new("MapleStaffMatt",
				     "matt",
				     1 ) ] )
	end

	def equippable?
		true
	end

	def consumable?
		false
	end

end
