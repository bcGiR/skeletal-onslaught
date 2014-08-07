require_relative 'dungeon'
require_relative 'area'
require_relative '../npcs/blacksmith'
require_relative '../game'
require_relative '../items/lockedwoodenchest'
require_relative '../items/skelethognoschest'
require_relative '../items/smallhealthpot'
require_relative '../items/smallmanapot'
require_relative '../items/healthpot'
require_relative '../items/manapot'
require_relative '../items/goldsack'
require_relative '../items/goldpendant'
require_relative '../items/silverpendant'
require_relative '../items/blackpearl'
require_relative '../npcs/cleric'

class CaveOfInfiniteSkeletons < Dungeon

	def initialize(game)
		super("Cave of Infinite Skeletons",
		      [ entrance = Area.new( ["Cave of Infinite Skeletons: entrance", 'cave', 'entrance'], #entrance_name
					     "\nYou descend into the dank, web-filled cavern called the Cave of Infinite \nSkeletons. The flickering of your torchlight against the uneven rock walls \ncauses intimidating shadows to dance around in the caverns. You are careful of \nyour step; who knows what pitfalls await in the dark? As you leave the light of \nthe outside world behind you begin to feel the creeping dispair of the \natmosphere of death around you taking over your thoughts. Suddenly, SKELETONS!", #entrance_description
					     Hash.new, #entrance_adjacent
					     [], #entrance_npcs
					     [ Proc.new { @game.spawn_enemy("skeleton", -1) } ], #entrance_enemies
					     [] ), #entrance_objects
		      walkway = Area.new( ["Cave Shaft", "Shaft"], #walkway_name
					 "\nYou walk down a narrow shaft leading from the entrance deeper into the cave. The \nlight of the surface fades from the western end of the walkway, and grows pitch \nblack in the east, where the sound of running water can be heard. The \nstalagtites and stalagmites that fill the shaft further to the east almost make \nthe pathway impassable. Here you get whiffs of fresh air from the surface, and \nmusty dank breezes from the east.", #walkway_description
					 Hash.new, #walkway_adjacent
					 [], #walkway_npcs
					 [ Proc.new { @game.spawn_enemy("skeleton", -1) },
					   Proc.new { @game.spawn_enemy("skeleton", 0) } ], #walkway_enemies
					 [MinorManaPot.new] ), #walkway_objects
		      pool = Area.new( ["Pool"], #pool_name
				      "\nYou enter a cavernous room, the crossroads of two shafts of the cave. Out of a \nsmall hole in the northwest wall a waterfall drops to the cavern floor and flows \ndown to a small pool in the center of the room. At the other end of the pool, \nabout 20 feet across, the pool empties into another stream which flows into a \nrabithole sized opening in the southeastern wall. A shaft leads out of this room \nto the north and one to the south. To the west, the light of the surface streams \nthrough the entrance.", #pool_description
				      Hash.new, #pool_adjacent
				      [], #pool_npcs
				      [ Proc.new { @game.spawn_enemy("skeleton", -1) },
					Proc.new { @game.spawn_enemy("goblin", -1) }], #pool_enemies
				      [MinorHealthPot.new] ), #pool_objects
		      a1 = Area.new( ["NorthWest Corridor", "NW Corridor", "NorthWest"], #a1_name
				    "\nYou stand one end of a long corridor. There is a natural cave to the south \nleading to the Pool, but beyond that the arched corridor is quite well crafted. \nLarge stone blocks carve out a room forty feet wide and over a hundred feet \nlong. At the western end, the cave leads down to the pool, to the east, a large \nwooden door stands in a heavy stone wall. Looking closer, you now notice that \nthe sconces on the wall are casting an orange glow on the socketed eyes and \ngrinning teeth of skulls decorating the walls, lined in rows that stretch up to \nthe ceiling and meet in the center.", #a1_description
				    Hash.new, #a1_adjacent
				    [], #a1_npcs
				    [ Proc.new { @game.spawn_enemy("spider", 0) } ], #a1_enemies
				    [] ), #a1_objects
		      a2 = Area.new( ["North Barrack", "North B"], #a2_name
				    "\nYou are standing in a skeletal armory. Bones line the floor of the skeletons \nthat have done combat, perhaps of would-be adventurers or perhaps just bored \nskeletons smashing each other to bits. There are racks of weapons filling the \ncorners and walls of the room; maces, swords, pikes, axes, and unidentifiable \nimpletments of death fill these racks. In the north end of this room, there is a \ngreat, unburning furnace, filled to the point of overflowing with bones and \nskulls. It seems to be a forge of the undead, where skeletal warriors are \nbirthed from the remnants of the defeated.", #a2_description
				    Hash.new, #a2_adjacent
				    [], #a2_npcs
				    [ Proc.new { @game.spawn_enemy("skeleton", 0) },
				      Proc.new { @game.spawn_enemy("zombie", 0) }], #a2_enemies
				    [MinorHealthPot.new] ), #a2_objects
		      a_treasure = Area.new( ["North Barrack Cache", "NBC", "Cache"], #a_treasure_name
					    "\nThe door at the south end of the barrack opens up into a small, dusty room \ncontaining cabinets, chests, barrels, and a table in the center of the room \ncluttered with torture implements, potions (or poisons?), and a scattering of \ngold pieces.", #a_treasure_description
					    Hash.new, #a_treasure_adjacent
					    [], #a_treasure_npcs
					    [], #a_treasure_enemies
					    [at_chest = LockedWoodenChest.new, SmallHealthPot.new, SmallManaPot.new, GoldSack.new] ), #a_treasure_objects
		      a3 = Area.new( ["NorthEast Corridor", "NEC", "NorthEast"], #a3_name
				     "\nYou enter a long room with heavy stone block walls and a high arched ceiling. \nThe room stretches over a hundred feet across: at the east end, the room ends in \nan empty wall, and at the other end, a large wooden door is placed in the middle \nof the stone wall. The arch above this heavy door is lined with skulls and bones \nof various kinds. In the south, at the eastern end of the room, a smaller wooden \ndoor exits the north corridor.", #a3_description
				     Hash.new, #a3_adjacent
				     [], #a3_npcs
				     [ Proc.new { @game.spawn_enemy("goblin", 0) } ], #a3_enemies
				     [] ), #a3_objects
		      b1 = Area.new( ["SouthWest Corridor", "SWC", "SouthWest"], #b1_name
				    "\nYou stand now in a cavernous, arched, stone corridor. At the eastern end, a \nlarge, wooden door with a heavy iron ring latch. The western end of the room \nends the corridor, with a natural cave opening to the Pool cavern north of here. \nThe sconces lining the walls here reveal the bones built into the architecture \nof the corridor, a grim reminder of the victims of this place. The structure of \nthe skeletal fortress is eerily well-contructed; precision does not come \nnaturally to skeletons.", #b1_description
				    Hash.new, #b1_adjacent
				    [], #b1_npcs
				    [Proc.new { @game.spawn_enemy("spider", 0) }], #b1_enemies
				    [] ), #b1_objects
		      b2 = Area.new( ["South Barrack", "SB"], #b2_name
				    "\nYou push past the wooden door and through the stone arch into a room much more \ncluttered than the rest. Filling the room are implements of torture, weapon \nracks, bones and skulls scattered about, and, at the northern end of the room, a \nforge of bones: the place where the skeletal warriors seem to be birthed. The \neast and west ends of the room have matching large wooden doors, and in the \nsouth, along the arched wall, a smaller door. Four round, stone pillars support \nthe arched roof in the middle of the room.", #b2_description
				    Hash.new, #b2_adjacent
				    [], #b2_npcs
				    [Proc.new { @game.spawn_enemy("skeleton", 0) },
				      Proc.new { @game.spawn_enemy("zombie", 0) }], #b2_enemies
				    [MinorHealthPot.new] ), #b2_objects
		      b_treasure = Area.new( ["South Barrack Cache", "SBC", "Cache"], #b_treasure_name
					    "\nThrough the small door in the south of the barrack you find a cluttered room \nfull of chests, cupboards, and drawers. There is a scattering of oils, potions, \ngold coins, and bones littering the surfaces in this room.", #b_treasure_description
					    Hash.new, #b_treasure_adjacent
					    [], #b_treasure_npcs
					    [], #b_treasure_enemies
					    [bt_chest = LockedWoodenChest.new, SmallManaPot.new, SmallHealthPot.new, GoldSack.new] ), #b_treasure_objects
		      b3 = Area.new( ["SouthEast Corridor", "SEC", "SouthEast"], #b3_name
				    "\nYou enter a long, stone room with an arched, vaulted ceiling. Your stepps echo \nominously in this room; it is hard to locate the origination of any sound in \nthis room. Concentrating more, you notice a gentle trickling, white noise that \nseems to be coming from the northern wall. Torchlight bathes the room in a \nred-orange glow, casting even a dim flickering on the towering ceiling overhead. \nThe corridor seems to continue through a door to the west. To the east, the \ncorridor ends, and at the eastern end of the room there is a small wooden door \nthat leads north.", #b3_description
				    Hash.new, #b3_adjacent
				    [], #b3_npcs
				    [Proc.new { @game.spawn_enemy("goblin", 0) }], #b3_enemies
				    [] ), #b3_objects
		      final = Area.new( ["Altar Room", "Altar", "AR"], #final_name
				       "\nYou come to a room filled with a grisly sight. The room contains, dead in the \ncenter, a sacraficial altar, bathed in dried blood and scattered with bones. \nAround the altar, aligning with the four corners, stand four spikes, taller than \nthe tallest man, with four, forgotten adventurers impaled on them. All that \nremains of these fallen heroes are their skulls and armor that cling to the \nspikes. You are filled with dread in this place. The north and south ends of the \nroom are both fitted with wooden doors. Amongst the bones, you notice someone \ncowering, hiding from the skeletons, looking up at you with desperate hope. In \nthe east wall of the room, there is an ornate, iron door, engraved with a \ndepiction of a monstrous skeleton, fitted with a crown of bones, wielding a \nsmaller skeleton as a club. Atop this door: one word -- 'Skelethognos'.", #final_description
				       Hash.new, #final_adjacent
				       [Cleric.new], #final_npcs
				       [ Proc.new { @game.spawn_enemy("skeleton", -2) },
					 Proc.new { @game.spawn_enemy("skeleton", -2) },
					 Proc.new { @game.spawn_enemy("spider", -1) },
					 Proc.new { @game.spawn_enemy("zombie", -1) }], #final_enemies
				       [SmallHealthPot.new, MinorManaPot.new] ), #final_objects
		      lair = Area.new( ["Skelethognos' Lair", "Skel", "SL"], #lair_name
					"\nYou enter the lair of the King of Bones. The room is scattered with the remnants \nof lost adventurers: their bones smashed across the room, their skulls craked, \nand equipment strewn on the ground. The Throne of Bones stands tall over the \nLord's defeated foes. Behind the throne, a gilded, gleaming chest.", #lair_description
					Hash.new, #lair_adjacent
					[], #lair_npcs
					[ Proc.new { @game.spawn_enemy( "skelethognos", 1) } ], #lair_enemies
					[SmallManaPot.new, SmallHealthPot.new, skel_chest = SkelethognosChest.new] ) ], game ) #lair_objects

		entrance.adjacent['east'] = pool

		pool.adjacent['west'] = entrance
		pool.adjacent['south'] = b1
		pool.adjacent['north'] = a1

		a1.adjacent['south'] = pool
		a1.adjacent['east'] = a2

		a2.adjacent['west'] = a1
		a2.adjacent['east'] = a3
		a2.adjacent['south'] = a_treasure
		
		a_treasure.adjacent['north'] = a2

		a3.adjacent['west'] = a2
		a3.adjacent['south'] = final

		b1.adjacent['north'] = pool
		b1.adjacent['east'] = b2

		b2.adjacent['west'] = b1
		b2.adjacent['east'] = b3
		b2.adjacent['south'] = b_treasure

		b_treasure.adjacent['north'] = b2

		b3.adjacent['west'] = b2
		b3.adjacent['north'] = final

		final.adjacent['south'] = b3
		final.adjacent['north'] = a3
		final.adjacent['east'] = lair

		lair.adjacent['west'] = final


		at_chest.items = [SilverPendant.new, GoldSack.new]
		
		bt_chest.items = [GoldPendant.new, GoldSack.new]

		skel_chest.items = [GoldSack.new, GoldSack.new, BlackPearl.new]
	end
end
