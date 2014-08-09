require_relative 'NPC'
require 'csv'

class Wizard < NPC

	attr_accessor :quit

	def initialize
		@quit = false
		@inv = []
		super(["Old Wizard", "Wiz", "Old Wiz" "Old"], inv)
	end

	def talk(hero)
		if hero.inv.any? { |i| i.names[0] == "Mysterious Black Pearl" }
			puts "\n\"You have done it! You have felled the Skeleton King! Wait... What's this? The \nBlack Pearl!? It can't be... King Tygain... #{hero.names[0]}, this is an artifact \nleft from a kingdom whos name has been forgotton long before even I was born. \nYou now hold the legacy of the Strongfist Clan. If you can restore the Black Pearl \nto it's rightful place, then the Curse of Cursed King my be lifted.\""
		else
			puts "\n\"Greetings #{hero.names[0]}, you look like a capable adventurer. If you are \nplanning on delving into the depths of the dungeon, you had better go prepared. \nI think there might be some things around this inn which could help you. And if \nyou die down there at least I can see if that assassin is \nstill around here...\""
		end
		Game.pause_short
		puts "\n\"Is your name ready to be written into the great stories?\" \n(Save? y/n)"
		confirm = gets.chomp.downcase
		until confirm == "y" || confirm == "n"
			puts "\nType 'y' or 'n'"
			confirm = gets.chomp.downcase
		end
		if confirm == "y"
			heal = 0
			pearl = 0
			if hero.special_list.has_key?('heal')
				heal = 1
			end
			if hero.inv.any? { |i| i.names[0] == "Mysterious Black Pearl" }
				pearl = 1
			end
			mhp = hero.inv.select { |i| i.names[0] == "Minor Health Potion" }.count
			mmp = hero.inv.select { |i| i.names[0] == "Minor Mana Potion" }.count
			shp = hero.inv.select { |i| i.names[0] == "Small Health Potion" }.count
			smp = hero.inv.select { |i| i.names[0] == "Small Mana Potion" }.count
			skull = hero.inv.select { |i| i.names[0] == "Skelethognos' Skull" }.count
			arm = hero.inv.select { |i| i.names[0] == "Skelethognos' Arm" }.count
			tooth = hero.inv.select { |i| i.names[0] == "Skelethognos' Biggest Tooth" }.count
			barmor = hero.inv.select { |i| i.names[0] == "Bone Armor" }.count
			bbuckler = hero.inv.select { |i| i.names[0] == "Bone Buckler" }.count
			bnecklace = hero.inv.select { |i| i.names[0] == "Necklace of Bones" }.count
			bsword = hero.inv.select { |i| i.names[0] == "Bone Sword" }.count
			pskull = hero.inv.select { |i| i.names[0] == "Perfect Whole Skull" }.count
			isword = hero.inv.select { |i| i.names[0] == "Iron Sword" }.count
			ishield = hero.inv.select { |i| i.names[0] == "Iron Shield" }.count
			iarmor = hero.inv.select { |i| i.names[0] == "Iron Armor" }.count
			silk = hero.inv.select { |i| i.names[0] == "Silk Mage's Robe" }.count
			helm = hero.inv.select { |i| i.names[0] == "Iron Helm" }.count
			staff = hero.inv.select { |i| i.names[0] == "Maple Staff" }.count
			gpend = hero.inv.select { |i| i.names[0] == "Gold Pendant" }.count
			spend = hero.inv.select { |i| i.names[0] == "Silver Pendant" }.count

			save = [hero.names[0], hero.lvl, hero.role, hero.gold, hero.exp, hero.keys, heal, pearl, mhp, mmp, shp, smp, skull, arm, tooth, barmor, bbuckler, bnecklace, bsword, pskull, isword, ishield, iarmor, silk, helm, staff, gpend, spend]

			new = true
			scores_csv = ENV['userprofile'] + '\SkeletalOnslaught\highscore.csv'
			
			CSV.foreach(scores_csv) do |row|
				if hero.names[0] == row[0]
					row = save
					new = false
				end
			end
			if new
				CSV.open(scores_csv, 'ab') do |csv|
					csv << save
				end
			end
			puts "\n#{hero.names[0]} saved the game!"
			Game.pause_medium
			puts "Quit? (y/n)"
			confirm = gets.chomp.downcase
			until confirm == "y" || confirm == "n"
				puts "\nType 'y' or 'n'"
				confirm = gets.chomp.downcase
			end
			if confirm == "y"
				@quit = true
			end
		end
	end
end
