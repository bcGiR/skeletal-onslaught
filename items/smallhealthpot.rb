require_relative 'consumable'
require_relative '../game'

class SmallHealthPot < Consumable

	def initialize
		super(["Small Health Potion", "Small Health", "SHP"], 20, "common")
	end

	def consume(target)
		target.hp = target.hp + 20
		if target.hp > target.hpmax
			target.hp = target.hpmax
		end
		puts "\n#{target.names[0]} drinks a #{self.names[0]} and gains 20HP (#{target.hp}HP total)"
		Game.pause_short
	end

	def equippable?
		false
	end

	def consumable?
		true
	end

end
