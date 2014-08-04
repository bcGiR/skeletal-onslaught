require_relative 'consumable'
require_relative '../game'

class GoldSack < Consumable

	attr_accessor :gold

	def initialize
		@gold = Game.d10 + 9
		super("Small Sack of Gold", @gold, "common")
	end

	def consume(target)
		target.gold = target.gold + @gold
		puts "\n#{target.name} opens the #{self.name} and finds #{@gold} gold coins!"
		Game.pause_short
	end

	def equippable?
		false
	end

	def consumable?
		true
	end

end
