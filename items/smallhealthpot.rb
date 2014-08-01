require_relative 'consumable'
require_relative '../game'

class SmallHealthPot < Consumable

	def initialize
		super("Small Health Potion", 20, "common")
	end

	def consume(target)
		target.hp = target.hp + 20
		if target.hp > target.hpmax
			target.hp = target.hpmax
		end
		puts "\n#{target.name} drinks a #{self.name} and gains 20HP (#{target.hp}HP total)"
		Game.pause_short
	end

	def equippable?
		false
	end

	def consumable?
		true
	end

end
