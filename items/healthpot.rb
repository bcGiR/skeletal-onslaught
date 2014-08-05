require_relative 'consumable'
require_relative '../game'

class MinorHealthPot < Consumable

	def initialize
		super(["Minor Health Potion", "Minor Health", "MHP"], 10, "common")
	end

	def consume(target)
		target.hp = target.hp + 10
		if target.hp > target.hpmax
			target.hp = target.hpmax
		end
		puts "\n#{target.names[0]} drinks a #{self.names[0]} and gains 10HP (#{target.hp}HP total)"
		Game.pause_short
	end

	def equippable?
		false
	end

	def consumable?
		true
	end

end
