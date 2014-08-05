require_relative 'consumable'
require_relative '../game'

class GoldSack < Consumable

	attr_accessor :gold

	def initialize
		@gold = Game.d10 + 9
		super(["Small Sack of Gold", "Small Sack", "SSG", "Small Gold"], @gold, "common")
	end

	def consume(target)
		target.gold = target.gold + @gold
		puts "\n#{target.names[0]} opens the #{self.names[0]} and finds #{@gold} gold coins!"
		Game.pause_short
	end

	def equippable?
		false
	end

	def consumable?
		true
	end

end
