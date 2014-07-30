require_relative 'consumable'
require_relative '../game'

class MinorHealthPot < Consumable

	def initialize
		super("Minor Health Potion", 10, "common")
	end

	def consume(target)
		target.hp = target.hp + 10
		if target.hp > target.hpmax
			target.hp = target.hpmax
		end
		puts "\n#{target.name} drinks a #{self.name} and gains 10HP (#{target.hp}HP total)"
		Game.pause_short
	end

	def equippable?
		false
	end

	def consumable?
		true
	end

end
