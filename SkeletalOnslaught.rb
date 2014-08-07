require_relative 'game'
require_relative 'items/healthpot'
require_relative 'items/manapot'
require_relative 'areas/area'
require_relative 'npcs/wizard'
require_relative 'npcs/blacksmith'
require_relative 'npcs/merchant'
require_relative 'areas/caveofinfiniteskeletons'
require_relative 'items/smallmanapot'
require_relative 'items/smallhealthpot'
require_relative 'items/perfectskull'
require_relative 'items/bonesword'
require_relative 'items/bonearmor'
require_relative 'items/bonebuckler'
require_relative 'items/bonenecklace'
require_relative 'items/skelethognostooth'
require_relative 'items/skelethognosskull'
require_relative 'items/skelethognosarm'
require_relative 'items/blackpearl'
require_relative 'items/ironsword'
require_relative 'items/ironshield'
require_relative 'items/ironarmor'
require_relative 'items/ironhelm'
require_relative 'items/silkrobe'
require_relative 'items/maplestaff'
require_relative 'items/silverpendant'
require_relative 'items/goldpendant'
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
puts "\n\n"
puts "                         ---      Instructions        ---"
Game.pause_medium
puts ""
puts "                    WELCOME TO THE SKELETAL ONSLAUGHT BETA TEST!"
puts ""
Game.pause_medium
puts "            This is a text adventure, role playing game. Everything will be"
puts "          described to you via text and you will enter commands by typing"
puts "          them and pressing ENTER. The game will tell you what you can do."
puts ""
Game.pause_medium
puts "            Fair warning: Enemies respawn, and you cannot flee from battle."
Game.pause_medium
puts "\n            TIP: When interacting with objects in the world (items, npcs,"
puts "          etc) You will not always have to type the full name. (I.E. Joe,"
puts "          the Blacksmith can be talked to by simply typing 'joe'. Another"
puts "          very useful one is 'mhp' instead of typing 'Minor Health"
puts "          Potion', 'mmp' for 'Minor Mana Potion' etc."
Game.pause_medium
puts "\n            TIP: You can use the 'up' and 'down' directional keys on your"
puts "          keyboard to cycle through previously entered commands. For"
puts "          instance, if you bought an Iron Sword and an Iron Shield, you"
puts "          can press up to cycle back to 'Iron Sword' and press ENTER to"
puts "          equip it."
Game.pause_medium
puts "\n            SAVING: The Old Wizard in town will save your game for you."
puts "          There is NO saving in a dungeon"
Game.pause_medium
puts "\n           Good Luck, Have Fun!"
puts "\n\n"
Game.pause_short

#Areas

#The town
town_description = "\nYou are sitting in the Brittle Bone Inn at a table by yourself. The dimly lit, \npungent hall is sparcely occupied; only a handful of dreary looking peasants sit \nand sip their tankards of ale, saying nothing and looking nowhere. After an \nhour, you are approached by an Old Wizardly looking man who tells you of great \nfourtune and fame to be gained by battling the Skeleton King of the Cave of \nInfinite Skeletons. Lacking any personal sovereignty, or freewill, you \nimmediately take up his quest and seek glory battling the undead."
town_adjacent = Hash.new
town_npcs = [wiz = Wizard.new, black = Blacksmith.new, merch = Merchant.new]
town_enemies = []
town_objects = [ MinorHealthPot.new, MinorManaPot.new]
town = Area.new(["Town"], town_description, town_adjacent, town_npcs, town_enemies, town_objects)

#User enters name
name_ok = false
until name_ok
	puts "Please enter your name:"
	Game.pause_short
	user_name = gets.chomp
	puts "\nYou have entered: #{user_name}. Is this correct? (y/n)"
	ok = gets.chomp.downcase
	until ok.downcase == "y" || ok.downcase == "n"
		puts "\nType 'y' or 'n'"
		ok = gets.chomp.downcase
	end
	if ok == "y"
		name_ok = true
	end
end

new_game = true
game = "variable_for_game"

CSV.foreach('C:\Users\Brendan\source\ruby\game\highscore.csv') do |row|
	if user_name == row[0]
		new_game = false
		game = Game.new(row[0], row[2].downcase, town)
		(row[1].to_i-1).times do
			until game.hero.level_up?
				game.hero.exp = game.hero.exp + 1
			end
			game.hero.level_up
		end
		game.hero.exp = row[4].to_i
		game.hero.keys = row[5].to_i
		game.hero.gold = row[3].to_i
		if row[6].to_i == 1
			game.hero.special_list['heal'] = 6
		end
		if row[7].to_i == 1
			game.hero.inv << BlackPearl.new
		end
		row[8].to_i.times { game.hero.inv << MinorHealthPot.new }
		row[9].to_i.times { game.hero.inv << MinorManaPot.new }
		row[10].to_i.times { game.hero.inv << SmallHealthPot.new }
		row[11].to_i.times { game.hero.inv << SmallManaPot.new }
		row[12].to_i.times { game.hero.inv << SkelethognosSkull.new }
		row[13].to_i.times { game.hero.inv << SkelethognosArm.new }
		row[14].to_i.times { game.hero.inv << SkelethognosTooth.new }
		row[15].to_i.times { game.hero.inv << BoneArmor.new }
		row[16].to_i.times { game.hero.inv << BoneBuckler.new }
		row[17].to_i.times { game.hero.inv << BoneNecklace.new }
		row[18].to_i.times { game.hero.inv << BoneSword.new }
		row[19].to_i.times { game.hero.inv << PerfectSkull.new }
		row[20].to_i.times { game.hero.inv << IronSword.new }
		row[21].to_i.times { game.hero.inv << IronShield.new }
		row[22].to_i.times { game.hero.inv << IronArmor.new }
		row[23].to_i.times { game.hero.inv << SilkRobe.new }
		row[24].to_i.times { game.hero.inv << IronHelm.new }
		row[25].to_i.times { game.hero.inv << MapleStaff.new }
		row[26].to_i.times { game.hero.inv << GoldPendant.new }
		row[27].to_i.times { game.hero.inv << SilverPendant.new }
	end
end

system("cls")

if new_game

	#User picks class
	puts "\nWelcome, brave #{user_name}. What sort of adventurer are you?"
	Game.pause_short
	puts "\n--------------------------------------------------------------------------------"
	puts "\nFighter: A natural brawler, the fighter is a seasoned combattant, capable of \nengaging almost anyone in melee combat"
	puts "\nHP:20 MP:12 ATT:2 DEFN:2 MATT:1 MDEFN:2 INIT:2 AC:6"
	puts "Special (Blade Flurry) 4MP"
	puts "\n--------------------------------------------------------------------------------"
	Game.pause_short
	puts "\nThief: As sneaky as he is cunning, the thief leverages his natural dexterity to \nsurprise his enemies with sneak attacks."
	puts "\nHP:20 MP:12 ATT:2 DEFN:1 MATT:2 MDEFN:1 INIT:3 AC:3"
	puts "Special: (Backstab) 4MP"
	puts "\n--------------------------------------------------------------------------------"
	Game.pause_short
	puts "\n\nMage: A wielder of powerful sorcery, the mage calls upon arcane forces to \nprotect herself and decimate her foes"
	puts "\nHP:20 MP:16 ATT:1 DEFN:2 MATT:2 MDEFN:2 INIT:1 AC:2"
	puts "Special: (Magic Missile) 4MP"
	puts "\n--------------------------------------------------------------------------------"
	Game.pause_short
	puts "\nPick your role: Fighter, Thief, Mage"
	role = "default"
	until role == "fighter" || role == "thief" || role == "mage" || role == "assassin"
		role = gets.chomp.downcase
		if  role == "fighter" || role == "thief" || role == "mage" || role == "assassin"
			puts "\nYou have chosen #{role.capitalize}"
			Game.pause_long
		else
			puts "\nThat is not a valid role, please choose again:\n\n"
		end
	end

	system("cls")

	#New Game
	game = Game.new(user_name, role, town)
	game.hero.inv << MinorHealthPot.new

end

dungeon = CaveOfInfiniteSkeletons.new(game)

town.adjacent['east'] = dungeon.areas[0]
dungeon.areas[0].adjacent['west'] = town


puts "................................................................................"
puts "#{game.hero.names[0]}: #{game.hero.hp}/#{game.hero.hpmax}HP #{game.hero.mp}/#{game.hero.mpmax}MP - Level #{game.hero.lvl} #{game.hero.role.capitalize} - #{game.hero.exp} Exp - #{game.hero.gold} Gold - #{game.hero.keys} Keys"
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
	puts "#{game.hero.names[0]}: #{game.hero.hp}/#{game.hero.hpmax}HP #{game.hero.mp}/#{game.hero.mpmax}MP - Level #{game.hero.lvl} #{game.hero.role.capitalize} - #{game.hero.exp} Exp - #{game.hero.gold} Gold - #{game.hero.keys} Keys"
	puts "................................................................................\n"

	#Combat
	if game.combat

		puts "\n\n*********************************** COMBAT ************************************"
		game.hero_area.enemies.each do |enemy|
			puts "\nThere is a level #{enemy.lvl} #{enemy.names[0]} attacking you with #{enemy.hp}HP left!"
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
high_scores = high_scores.sort_by {|s| s[4]}.reverse[0..9]

#displays high scores
puts "\n --------------------------------- HIGH SCORES ---------------------------------\n\n"
score_num = 1
high_scores.each do |score|
	puts "\n#{score_num} ... #{score[0]}, level #{score[1]} #{score[2]} - #{score[4]} Exp"
	score_num += 1
end

Game.pause_long
puts "\n\nPRESS ENTER>"
continue = gets.chomp
system("cls")

