require_relative '../model'
require_relative '../game'

class Enemy < Model

	def initialize(name, hp, mp, att, defn, matt, mdefn, init, ac)
		super(name, hp, mp, att, defn, matt, mdefn, init, ac)
	end

	def drop(hero)

	end

end
