require_relative 'game'

class Model

	attr_accessor :name, :hp, :hpmax, :mp, :mpmax, :att, :defn, :init, :ac, :exp, :lvl, :modifiers, :special_list

	def initialize(name, hp, mp, att, defn, init, ac)
		@name = name
		@hp = hp
		@hpmax = hp
		@mp = mp
		@mpmax = mp
		@att = att
		@defn = defn
		@init = init
		@ac = ac
		@exp = 0
		@lvl = 1
		@modifiers = []
	end

	def attack
		Game.d6 + @att
	end

	def special_attack(action)
	end

	def modify(modifier)
		case modifier.attr
			when "hp"
				self.hp = self.hp + modifier.value
				self.hpmax = self.hpmax + modifier.value
			when "mp"
				self.mp = self.mp + modifier.value
				self.mpmax = self.mpmax + modifier.value
			when "att"
				self.att = self.att + modifier.value
			when "defn"
				self.defn = self.defn + modifier.value
			when "init"
				self.init = self.init + modifier.value
			when "ac"
				self.ac = self.ac + modifier.value
		end
		self.modifiers << modifier
	end

	def demodify(modifier)
		case modifier.attr
			when "hp"
				self.hp = self.hp - modifier.value
				self.hpmax = self.hpmax - modifier.value
			when "mp"
				self.mp = self.mp - modifier.value
				self.mpmax = self.mpmax - modifier.value
			when "att"
				self.att = self.att - modifier.value
			when "defn"
				self.defn = self.defn - modifier.value
			when "init"
				self.init = self.init - modifier.value
			when "ac"
				self.ac = self.ac - modifier.value
		end
		modifiers.delete(modifier)
	end

	def equip(item)
		unless item.equipped?
			item.equipped = true

			item.modifiers.each do |modifier|
				self.modify(modifier)
			end

			puts "\n#{@name} has equipped #{item.name}"
			Game.pause_short
		end
	end

	def unequip(item)
		if item.equipped?
			item.equipped = false

			item.modifiers.each do |modifier|
				self.demodify(modifier)
			end

			puts "\n#{@name} has unequipped #{item.name}"
			Game.pause_short
		end
	end

	def level_up?
		if @exp >= ( @lvl*10 + ( (@lvl-1)*10 ) )
			return true
		end
		false
	end

	def level_up
		@lvl = @lvl + 1
	end

	def dead?
		if hp <= 0
			return true
		end
		return false
	end

end
