require_relative 'heroes/mage'
require_relative 'heroes/thief'
require_relative 'heroes/fighter'
require_relative 'enemies/skeleton'
require_relative 'enemies/spider'
require_relative 'enemies/goblin'
require_relative 'enemies/zombie'
require_relative 'enemies/skelethognos'
require_relative 'items/item'
require_relative 'items/consumable'
require_relative 'items/container'
include Math

class Game

	attr_accessor :hero, :over, :hero_area, :combat, :timers

	#On game start: creates hero,
	def initialize(name, role, area)
		case role
		when "fighter"
			@hero = Fighter.new(name)
		when "thief"
			@hero = Thief.new(name)
		when "mage"
			@hero = Mage.new(name)
		else
			puts "----------------------------------"
			puts "| ERROR: PLEASE QUIT AND RESTART |"
			puts "----------------------------------"
		end
		@over = false
		@hero_area = area
		@combat = area.has_enemies?
		@timers = []
	end

	### Game pauses ###
	def self.pause_short
		sleep(1)
	end

	def self.pause_medium
		sleep(2)
	end

	def self.pause_long
		sleep(3)
	end
	
	### Dice Rolls ###
	def self.d2
		Random.rand(1..2)
	end

	def self.d3
		Random.rand(1..3)
	end

	def self.d4
		Random.rand(1..4)
	end

	def self.d6
		Random.rand(1..6)
	end

	def self.d8
		Random.rand(1..8)
	end

	def self.d10
		Random.rand(1..10)
	end

	def self.d12
		Random.rand(1..12)
	end

	def self.d20
		Random.rand(1..20)
	end

	def self.d100
		Random.rand(1..100)
	end

	### Mechanics ###
	
	def move_to(area)
		@hero_area = area
		area.spawns.each do |spawn|
			area.enemies << spawn.call
		end
		Game.describe(area)
		@combat = area.has_enemies?
		Game.pause_long
	end

	def self.describe(area)
		puts area.description
		puts "\n"
		Game.pause_long
		area.enemies.each do |enemy|
			puts "You see a #{enemy.name} (level #{enemy.lvl}) here, ready to attack!"
			Game.pause_short
		end
	end

	def get_user_action
		action = "error"
		until action == "look" || action == "talk" ||action == "search" || action == "move" || action == "item" || action == "status"
			puts "\nLook, Talk, Search, Move, Item, or Status?:"
			action = gets.chomp.downcase
		end
		if action == "talk"
			puts "\n-- #{@hero_area.name.capitalize} --\n\n"
			@hero_area.npc.each do |npc|
				Game.pause_short
				puts npc.name + "\n"
			end
			Game.pause_short
			puts "\nWho would you like to talk to?"
			talk_to = gets.chomp.downcase
			@hero_area.npc.each do |npc|
				if talk_to == npc.name.downcase
					action = action + talk_to
				end
			end

			if action == "talk"
				puts "There is no one here by that name"
				action = "error"
			end

		elsif action == "move"
			puts "\n-- #{@hero_area.name.capitalize} --\n\n"
			@hero_area.adjacent.each do |area|
				Game.pause_short
				puts area.name + "\n"
			end
			Game.pause_short
			puts "\nWhere would you like to go?"
			to_area = gets.chomp.downcase
			@hero_area.adjacent.each do |area|
				if area.name.downcase == to_area
					action = action + to_area
				end
			end
			#TODO: Clean this up!!
			if action == "move"
				puts "You can't go there from here"
				action = "error"
			end
				
		#if item was chosen show inventory and ask which item to use
		elsif action == "item"
				puts "\n-- Inventory --\n\n"
				@hero.inv.each do |i| 
					if i.equippable?
						if i.equipped?
							puts "*" + i.name
						else
							puts i.name
						end
					else
						puts i.name
					end
				end
				puts "\n(equipped: [*])"	
				puts "---------------"
				Game.pause_short
				puts "\nType the name of an item to use it:"
				item = gets.chomp.downcase
				#check to make sure the item is in the inv
				if @hero.inv.any? {|i| i.name.downcase == item}
					action = action + item
				else
					puts "\nYou do not have any #{item}"
					action = "error"		
				end
		end
		Game.pause_short
		action
	end
	
	#Called when the user needs to pick an action returns an action or error
	def get_user_combat_action
		#ask user to type an action
		action = "error"
		until action == "fight" || action == "special" || action == "item"
			puts "\nFight, Special, or Item?:"
			action = gets.chomp.downcase
		end
		#if special was chosen check mp
		if action == "special"
			puts "\nWhich ability?"
			Game.pause_short
			puts "\n-- #{@hero.name} --"
			@hero.special_list.each do |spec, cost|
				puts "\n#{spec.capitalize} (#{cost}MP)"
			end
			puts "\n"
			Game.pause_short
			choice = gets.chomp.downcase
			action = action + choice
			unless @hero.special_list.has_key?(choice)
				puts "\nYou do not have that ability"
				return "error"
			end
			if @hero.mp < @hero.special_list.fetch(choice)
				puts "\nYou do not have enough MP to do that"
				return "error"
			end
		
		#if item was chosen show inventory and ask which item to use
		elsif action == "item"
				puts "\n-- Inventory --\n\n"
				@hero.inv.each do |i| 
					if i.equippable?
						if i.equipped?
							puts "*" + i.name
						else
							puts i.name
						end
					else
						puts i.name
					end
				end
				puts "\n(equipped: [*])"	
				puts "---------------"
				Game.pause_short
				puts "\nType the name of an item to use it:"
				item = gets.chomp.downcase
				#check to make sure the item is in the inv
				if @hero.inv.any? {|i| i.name.downcase == item}
					action = action + item
				else
					puts "\nYou do not have any #{item}"
					return "error"		
				end
		end
		Game.pause_short
		action
	end

	#called during combat when a model must select the round's action
	def get_combat_action(model)
		if model == @hero
			self.get_user_combat_action
		else
			action = model.choose_action
			return action
		end
	end

	def choose_target(attacker, action)
		if attacker == @hero

			if @hero_area.enemies.count == 1
				return [@hero_area.enemies[0]]
			end

			case action
			when "item"
				return attacker
			when "fight"
				puts "\nAttack who?"
				Game.pause_short
				count = 1
				@hero_area.enemies.each do |enemy|
					puts "\n#{count}) #{enemy.name.capitalize} level #{enemy.lvl} (#{enemy.hp}HP)"
					count += 1
				end
				Game.pause_short
				choice = gets.chomp.downcase.to_i
				Game.pause_short
				until choice > 0 && choice < (count+1)
					puts "\nPlease choose again:"
					choice = gets.chomp.downcase.to_i
				end
				return [@hero_area.enemies[choice-1]]
			when /special/
				if hero.special_single_target(action[7..-1])
					puts "\nAttack who?"
					Game.pause_short
					count = 1
					@hero_area.enemies.each do |enemy|
						puts "\n#{count}) #{enemy.name.capitalize} level #{enemy.lvl} (#{enemy.hp}HP)"
						count += 1
					end
					Game.pause_short
					choice = gets.chomp.downcase.to_i
					Game.pause_short
					until choice > 0 && choice < (count+1)
						"\nPlease choose again:"
						choice = gets.chomp.downcase.to_i
					end
					return [@hero_area.enemies[choice-1]]
				end
			end
		else
			return [@hero]
		end
	end

	def perform_user_action(action)
		case action
		when "look"
			Game.describe(@hero_area)
		when /talk/
			action = action[4..-1]
			@hero_area.npc.find { |npc| npc.name.downcase == action }.talk(@hero)
			Game.pause_short
		when "search"
			puts "\nYou search the room thoroughly"
			Game.pause_short
			if @hero_area.objects.empty?
				puts "\nThere is nothing here"
				Game.pause_short
			else
				items_in_room = []
				@hero_area.objects.each do |object|
					if object.class == HealthPot || object.class == ManaPot
						puts "\nYou have found a discarded #{object.name}"
						Game.pause_short
						puts "Would you like to pick it up? (y/n)"
						confirm = ""
						until confirm == "n" || confirm == "y"
							confirm = gets.chomp.downcase
						end
						if confirm == "y"
							@hero.inv << object
						else
							items_in_room << object
						end
					elsif object.class == LockedWoodenChest
						puts "\nYou have found a #{object.name}"
						Game.pause_short
						if object.locked
							puts "\nIt appears to be locked. Try to unlock it? (y/n)"
							confirm = gets.chomp.downcase
							until confirm == "y" || confirm == "n"
								confirm = gets.chomp.downcase
							end
							if confirm == "y"
								object.unlock
							end
						end
						unless object.locked
							puts "\nWould you like to open it? (y/n)"
							confirm = gets.chomp.downcase
							until confirm == "y" || confirm == "n"
								confirm = gets.chomp.downcase
							end
							if confirm == "y"
								object.open(@hero)
							end
						end
					end
				end
				@hero_area.objects = items_in_room
			end
		when /move/
			#removes "move" from the string to leave just the name
			action = action[4..-1]
			#passes area name to the move_to method
			to_area = @hero_area.adjacent.select { |area| area.name.downcase == action }.first
			self.move_to(to_area)
		when /item/
			#removes "item" from the string to leave just the name
			action = action[4..-1]
			item = @hero.inv.find { |i| i.name.downcase == action }

			if item.equippable?
				if item.equipped?
					@hero.unequip(item)
				else
					@hero.equip(item)
				end
			elsif item.consumable?
				@hero.use_consumable(item)
			end
		when "status"
			puts "\n-- Status Details --"
			puts ""
			puts @hero.name
			puts "Level #{@hero.lvl}"
			puts "\nHP: #{@hero.hp}/#{@hero.hpmax}"
			puts "MP: #{@hero.mp}/#{@hero.mpmax}"
			puts "ATT: #{@hero.att}"
			puts "DEF: #{@hero.defn}"
			puts "M.ATT: #{@hero.matt}"
			puts "M.DEF: #{@hero.mdefn}"
			puts "INIT: #{@hero.init.to_i}"
			puts "AC: #{@hero.ac}"
			puts "\n--------------------"
			Game.pause_short
		end
	end

	#recieves the action and calls correct methods to perform it
	def perform_combat_action(model, target, action)

		#attack either with fight or special
		if action == "fight"
			self.attack(model, target, action)

		elsif /special/ === action
			action = action[7..-1]
			self.attack(model, target, action)
		
		#string action contains "item[nameOfItem]"
		elsif /item/ === action
			#removes "item" from the string to leave just the name
			action = action[4..-1]
			item = @hero.inv.find { |i| i.name.downcase == action }

			if item.equippable?
				if item.equipped?
					model.unequip(item)
				else
					model.equip(item)
				end
			elsif item.consumable?
				model.use_consumable(item)
			end
		end
	end

	#Carries out an attack by an attacker against a target
	def attack(attacker, target, type)

		target.each do |defender|

			damage = 0

			if type == "fight"
				damage = attacker.attack
				damage_ratio = ( attacker.att / defender.defn )
			else
				attack_stat = attacker.special_type(type)
				if attack_stat == "att"
					damage = attacker.special_attack(type, self)
					damage_ratio = ( attacker.att / defender.defn )
				else
					damage = attacker.special_attack(type, self)
					damage_ratio = ( attacker.matt / defender.mdefn )
				end
			end

			if damage_ratio > 1.5
				damage_ratio = 1.5
			elsif damage_ratio < 0.5
				damage_ratio = 0.5
			end

			damage = (damage * damage_ratio).to_i
            if type == "fight" || attack_stat == "att"
                damage = damage - defender.ac
            end


			#assign  damage
			unless damage <= 0
				defender.hp = defender.hp - damage #assign damage
				puts "\n#{attacker.name} has wounded #{defender.name} for #{damage}dmg. (#{defender.hp}HP remains)"
			else
				puts "\n#{attacker.name} has failed to damage #{defender.name}"
			end
			Game.pause_short

			#after attack check if the defender is dead and kill if they are
			if defender.dead?
				self.kill(defender)
			end
		end
	end

	def update_timers
		timers_temp = []
		@timers.each do |timer|
			timer.tick
			unless timer.rounds_left == 0
				timers_temp << timer
			end
		end
		@timers = timers_temp
	end

	#Creates new enemies at lvl and adds them to the array of enemies
	def spawn_enemy(enemy, lvl)
		enemy_lvl = @hero.lvl + lvl
		if enemy_lvl < 1
			enemy_lvl = 1
		end

		#spawns a new enemy and adds it to enemies
		case enemy
		when "skeleton"
			new_enemy = Skeleton.new
		when "skelethognos"
			new_enemy = Skelethognos.new
		when "spider"
		        new_enemy = Spider.new
        	when "goblin"
            		new_enemy = Goblin.new
        	when "zombie"
            		new_enemy = Zombie.new
		end

		#levels the enemy up according lvl parameter
		(enemy_lvl-1).times do
			until new_enemy.level_up?
				new_enemy.exp = new_enemy.exp + 1
			end
			new_enemy.level_up
		end

		new_enemy

	end

	#kills a model
	def kill(model)
		#if hero has been killed then the game is over
		if model == hero
			puts "\nYou have died. Your adventure ends here."
			Game.pause_long
		#if an enemy was killed, death_cry, drop loot, give exp
		else
			model.death_cry
			Game.pause_short

			model.drop(hero)

			if hero.level_up?
				hero.level_up
			end

			index = @hero_area.enemies.index(model)
			@hero_area.enemies.delete_at(index)
		end
	end
	
	#checks if the game is over and returns state
	def over?
		if hero.dead? || ((@hero_area.name == "dungeon" || @hero_area.name == "test3") && !combat)
			@over = true
		end
		@over
	end
end
