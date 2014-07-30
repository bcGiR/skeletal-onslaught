require_relative 'consumable'
require_relative '../game'

class MinorManaPot < Consumable

	def initialize
		super("Minor Mana Potion", 10, "common")
	end

	def consume(target)
		target.mp = target.mp + 10
		if target.mp > target.mpmax
			target.mp = target.mpmax
		end
		puts "\n#{target.name} drinks a #{self.name} and gains 10MP (#{target.mp}MP total)"
		Game.pause_short
	end

	def equippable?
		false
	end

	def consumable?
		true
	end

end
