require_relative 'game'
require_relative 'items/healthpot'
require_relative 'items/manapot'
require_relative 'areas/area'
require_relative 'npcs/wizard'
require_relative 'npcs/blacksmith'
require_relative 'areas/caveofinfiniteskeletons'
require 'csv'

system("cls")
Game.pause_short
#Title screen
puts "\n\n"
puts "                         ................................"
puts "                         .Welcome to Skeletal Onslaught!."
puts "                         ................................"
puts "\n\n"
Game.pause_long

#User enters name
name_ok = false
until name_ok
	puts "Please enter your name:"
	Game.pause_short
	user_name = gets.chomp
	puts "\nYou have entered: #{user_name}. Is this correct? (y/n)"
	ok = ""
	until ok.downcase == "y" || ok.downcase == "n"
		ok = gets.chomp
	end
	if ok == "y"
		name_ok = true
	end
end	

system("cls")

#User picks class
puts "Welcome, brave #{user_name}. What sort of adventurer are you?"
Game.pause_short
puts "\n--------------------------------------------------------------------------------"
puts "\nFighter: A natural brawler, the fighter is a seasoned combattant, capable of \nengaging almost anyone in melee combat"
puts "\nHP:18 MP:12 ATT:2 DEF:2 M.ATT:1 M.DEF:2 INIT:2 AC:1"
puts "Special (Blade Flurry) 4MP"
puts "\n--------------------------------------------------------------------------------"
Game.pause_short
puts "\nThief: As sneaky as he is cunning, the thief leverages his natural dexterity to \nsurprise his enemies with sneak attacks."
puts "\nHP:18 MP:12 ATT:2 DEF:1 M.ATT:2 M.DEF:1 INIT:3 AC:1"
puts "Special: (Backstab) 4MP"
puts "\n--------------------------------------------------------------------------------"
Game.pause_short
puts "\n\nMage: A wielder of powerful sorcery, the mage calls upon arcane forces to \nprotect herself and decimate her foes"
puts "\nHP:18 MP:12 ATT:1 DEF:2 M.ATT:2 M.DEF:2 INIT:1 AC:0"
puts "Special: (Magic Missile) 4MP"
puts "\n--------------------------------------------------------------------------------"
Game.pause_short
puts "\nPick your role: Fighter, Thief, Mage"
role = "default"
until role == "fighter" || role == "thief" || role == "mage"
	role = gets.chomp.downcase
	if  role == "fighter" || role == "thief" || role == "mage"
		puts "\nYou have chosen #{role.capitalize}"
		Game.pause_long
	else
		puts "\nThat is not a valid role, please choose again:\n\n"
	end
end

system("cls")

#Areas

#The town
town_description = "\nYou are sitting in the Brittle Bone Inn at a table by yourself. The dimly lit, \npungent hall is sparcely occupied; only a handful of dreary looking peasants sit \nand sip their tankards of ale, saying nothing and looking nowhere. After an \nhour, you are approached by an Old Wizardly looking man who tells you of great \nfourtune and fame to be gained by battling the Skeleton King of the Cave of \nInfinite Skeletons. Lacking any personal sovereignty, or freewill, you \nimmediately take up his quest and seek glory battling the undead."
town_adjacent = []
town_npcs = [wiz = Wizard.new, black = Blacksmith.new]
town_enemies = []
town_objects = [h1 = MinorHealthPot.new, h2 = MinorHealthPot.new, m1 = MinorManaPot.new]
town = Area.new("town", town_description, town_adjacent, town_npcs, town_enemies, town_objects)

#New Game
game = Game.new(user_name, role, town)

dungeon = CaveOfInfiniteSkeletons.new(game)

town.adjacent = [dungeon.areas[0]]
dungeon.areas[0].adjacent << town

puts "................................................................................"
puts "#{game.hero.name}: #{game.hero.hp}/#{game.hero.hpmax}HP #{game.hero.mp}/#{game.hero.mpmax}MP - Level #{game.hero.lvl} #{role.capitalize} - #{game.hero.gold} Gold - #{game.hero.exp} exp"
puts "................................................................................\n"

Game.describe(town)

Game.pause_long
puts "\n\nPRESS ENTER>"
continue = gets.chomp

#Main game loop: skeletons and hero do battle until either is defeated
until game.over?

	system("cls")

	#Status bar displaying user stats and current situation
	puts "................................................................................"
	puts "#{game.hero.name}: #{game.hero.hp}/#{game.hero.hpmax}HP #{game.hero.mp}/#{game.hero.mpmax}MP - Level #{game.hero.lvl} #{role.capitalize} - #{game.hero.gold} Gold - #{game.hero.exp} exp"
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
		game.hero_area.enemies.each do |enemy|
			combattants << enemy
		end
		combattants << game.hero

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

		if game.combat
			game.update_timers
		else
			game.timers.each do |timer|
				timer.expires
			end
			game.timers = []
		end

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

#Add current score to the csv file if the hero was victorious
unless game.hero.dead?
	CSV.open('C:\Users\Brendan\source\ruby\game\highscore.csv', 'ab') do |csv|
		csv << [user_name, game.hero.lvl, role.capitalize, game.hero.gold]
	end
end

Game.pause_long
puts "\n\nPRESS ENTER>"
continue = gets.chomp
system("cls")

#Holds high scores for display
high_scores = []

#Add csv scores to high_scores
CSV.foreach('C:\Users\Brendan\source\ruby\game\highscore.csv') do |row|
	high_scores << row
end

#sorts high scores by gold earned and then selects the top 10
high_scores = high_scores.sort_by {|s| s[3]}.reverse[0..9]

#displays high scores
puts "\n --------------------------------- HIGH SCORES ---------------------------------\n\n"
score_num = 1
high_scores.each do |score|
	puts "\n#{score_num} ... #{score[0]}, level #{score[1]} #{score[2]} - #{score[3]} Gold"
	score_num += 1
end

Game.pause_long
puts "\n\nPRESS ENTER>"
continue = gets.chomp
system("cls")

