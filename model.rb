require_relative 'game'
include Math

class Model

	attr_accessor :name, :hp, :hpmax, :mp, :mpmax, :att, :defn, :matt, :mdefn, :init, :ac, :exp, :lvl, :modifiers, :special_list

	def initialize(name, hp, mp, att, defn, matt, mdefn, init, ac)
		@name = name
		@hp = hp
		@hpmax = hp
		@mp = mp
		@mpmax = mp
		@att = att
		@defn = defn
		@matt = matt
		@mdefn = mdefn
		@init = init
		@ac = ac
		@exp = 0
		@lvl = 1
		@modifiers = []
	end

	def attack
		damage = ( (Game.d6 + 1.0) + ( (Game.d100 * 5.0) + 92.0 ) * ( (@lvl+9.0)/(99.0+10.0) ) ** 2).to_i

	end

	def special_attack(action, game)
	end

	def special_type(action)
	end

    def special_single_target(action)
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
                if self.att - modifier.value < 1
                    modifier.value = self.att - 1
                end
				self.att = self.att + modifier.value
			when "defn"
                if self.defn - modifier.value < 1
                    modifier.value = self.defn - 1
                end
				self.defn = self.defn + modifier.value
			when "matt"
                if self.matt - modifier.value < 1
                    modifier.value = self.matt - 1
                end
				self.matt = self.matt + modifier.value
			when "mdefn"
                if self.mdefn - modifier.value < 1
                    modifier.value = self.mdefn - 1
                end
				self.mdefn = self.mdefn + modifier.value
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
			when "matt"
				self.matt = self.matt - modifier.value
			when "mdefn"
				self.mdefn = self.mdefn - modifier.value
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
		level = @lvl
		required = 0
		until level == 0
			required += exp_needed(level)
			level -= 1
		end
		if @exp >= required
			return true
		end
		false
	end

	def exp_needed(level)
		if level == 0
			return 0
		elsif level == 1
			return 10
		else 
			self.exp_needed_i(level, 10)
		end
	end

	def exp_needed_i(level, total)
		if level == 1
			return total
		else
			return exp_needed_i(level-1, total*1.1)
		end
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
