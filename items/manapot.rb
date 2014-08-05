require_relative 'consumable'
require_relative '../game'

class MinorManaPot < Consumable

	def initialize
		super(["Minor Mana Potion", "Minor Mana", "MMP"], 10, "common")
	end

	def consume(target)
		target.mp = target.mp + 10
		if target.mp > target.mpmax
			target.mp = target.mpmax
		end
		puts "\n#{target.names[0]} drinks a #{self.names[0]} and gains 10MP (#{target.mp}MP total)"
		Game.pause_short
	end

	def equippable?
		false
	end

	def consumable?
		true
	end

end
