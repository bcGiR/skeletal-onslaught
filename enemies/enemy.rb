require_relative '../model'
require_relative '../game'

class Enemy < Model

	def initialize(names, hp, mp, att, defn, matt, mdefn, init, ac)
		super(names, hp, mp, att, defn, matt, mdefn, init, ac)
	end

	def drop(hero)

	end

end
