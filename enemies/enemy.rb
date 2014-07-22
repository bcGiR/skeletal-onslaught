require_relative '../model'
require_relative '../game'

class Enemy < Model

	def initialize(name, hp, mp, att, defn, init, ac)
		super(name, hp, mp, att, defn, init, ac)
	end

	def drop(hero)

	end

end
