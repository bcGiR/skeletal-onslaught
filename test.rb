require_relative 'game'
require_relative 'enemies/skeleton'
require_relative 'areas/area'
require_relative 'items/healthpot'
require_relative 'items/manapot'

test = Area.new("test", "This is a test", [], [],
		[ Game.spawn_enemy("skeleton", 0),
    		  Game.spawn_enemy("skeleton", 0) ], [])
test1 = Area.new("test1", "This is a test", [], [],
		[ Game.spawn_enemy("skeleton", 0),
    		  Game.spawn_enemy("skeleton", 0) ], [])
test2 = Area.new("test2", "This is a test", [], [],
		[ Game.spawn_enemy("skeleton", 0),
    		  Game.spawn_enemy("skeleton", 0) ], [])
test3 = Area.new("test3", "This is a test", [], [],
		[ Game.spawn_enemy("skeleton", -1),
    		  Game.spawn_enemy("skeleton", -1),
		  Game.spawn_enemy("skeleton", -1) ], [])

areas = [test, test1, test2, test3]
areas.each do |area|
	area.adjacent = areas
end

role = "fighter"
game = Game.new("Beldan", role, test)
game.hero.inv = [ HealthPot.new, HealthPot.new, HealthPot.new, HealthPot.new, ManaPot.new, ManaPot.new ]

#Main game loop: skeletons and hero do battle until either is defeated
until game.over?

	system("cls")

	#Status bar displaying user stats and current situation
	puts "................................................................................"
	puts "#{game.hero.name}: #{game.hero.hp}/#{game.hero.hpmax}HP #{game.hero.mp}/#{game.hero.mpmax}MP - Level #{game.hero.lvl} #{role.capitalize} - #{game.hero.gold} Gold"
	puts "................................................................................\n"
	
	#Combat
	if game.combat

		puts "\n\n*********************************** COMBAT ************************************"
		game.hero_area.enemies.each do |enemy|
			puts "\nThere is a level #{enemy.lvl} #{enemy.name} attacking you with #{enemy.hp}HP left!"
		end
		puts "\n*******************************************************************************"
		if game.hero.hp <= 5
			puts "\nYOUR HEALTH IS LOW!"
		end
		Game.pause_short
		
		combattants = []
		combattants << game.hero
		game.hero_area.enemies.each do |enemy|
			combattants << enemy
		end

		combattants.sort! { |a,b| b.init <=> a.init }

		combattants.each do |attacker|
			unless attacker.dead? || game.over?
				action = game.get_combat_action(attacker)
				while action == "error"
					action = game.get_combat_action(attacker)
				end
	
				defender = game.choose_target(attacker, action)

				game.perform_combat_action(attacker, defender, action)
			end
		end 

		game.combat = game.hero_area.has_enemies?

	#Non-combat
	else 
		hero_action = game.get_user_action

		while hero_action == "error"
			hero_action = game.get_user_action
		end

		game.perform_user_action(hero_action)
	end
	
	#promt user so they have time to read the rounds effects
	puts "\n\nPRESS ENTER>"
	continue = gets.chomp
end

#End screen
system("cls")
if game.hero.dead?
	#Defeat
	puts "\nSkeletons continuted to swarm out of the dungeon after the demise of our hero; \ncounties burned, castles crumbled, and all was lost.\n\n"
	puts "                           THE END\n"
else
	#Victory
	puts "Victorious, you stand over a pile of your defeated foes. You cannot tell which \nof the bones belonged to which enemy at this point, but it does not matter. The \nskeletons don't care. They live out they're days in perfect bliss, living \nalongside their kin for eternity. You will join them now. Their calls are \ngrowing more audible in your ear. \"Come, adventurer, sleep with us. Sleep with \nus for eternity.\"\n\n"
	puts "                           THE END\n"
end
