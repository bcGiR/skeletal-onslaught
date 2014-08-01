require_relative 'consumable'
require_relative '../game'

class SmallManaPot < Consumable

	def initialize
		super("Small Mana Potion", 20, "common")
	end

	def consume(target)
		target.mp = target.mp + 20
		if target.mp > target.mpmax
			target.mp = target.mpmax
		end
		puts "\n#{target.name} drinks a #{self.name} and gains 20MP (#{target.mp}MP total)"
		Game.pause_short
	end

	def equippable?
		false
	end

	def consumable?
		true
	end

end
