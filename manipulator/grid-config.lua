-- Grid configuration
if not manipulator_module then qerror('Only usable from within manipulator') end

column {group = 0, color = 7, profession = 'MINER', labor = 'MINE', skill = 'MINING', label = "Mi", special = true}
-- Woodworking
column {group = 1, color = 14, profession = 'CARPENTER', labor = 'CARPENTER', skill = 'CARPENTRY', label = "Ca"}
column {group = 1, color = 14, profession = 'BOWYER', labor = 'BOWYER', skill = 'BOWYER', label = "Bw"}
column {group = 1, color = 14, profession = 'WOODCUTTER', labor = 'CUTWOOD', skill = 'WOODCUTTING', label = "WC", special = true}
-- Stoneworking
column {group = 2, color = 15, profession = 'MASON', labor = 'MASON', skill = 'MASONRY', label = "Ma"}
column {group = 2, color = 15, profession = 'ENGRAVER', labor = 'DETAIL', skill = 'DETAILSTONE', label = "En"}
-- Hunting/Related
column {group = 3, color = 2, profession = 'ANIMAL_TRAINER', labor = 'ANIMALTRAIN', skill = 'ANIMALTRAIN', label = "Tn"}
column {group = 3, color = 2, profession = 'ANIMAL_CARETAKER', labor = 'ANIMALCARE', skill = 'ANIMALCARE', label = "Ca"}
column {group = 3, color = 2, profession = 'HUNTER', labor = 'HUNT', skill = 'SNEAK', label = "Hu", special = true}
column {group = 3, color = 2, profession = 'TRAPPER', labor = 'TRAPPER', skill = 'TRAPPING', label = "Tr"}
column {group = 3, color = 2, profession = 'ANIMAL_DISSECTOR', labor = 'DISSECT_VERMIN', skill = 'DISSECT_VERMIN', label = "Di"}
-- Healthcare
column {group = 4, color = 5, profession = 'DIAGNOSER', labor = 'DIAGNOSE', skill = 'DIAGNOSE', label = "Di"}
column {group = 4, color = 5, profession = 'SURGEON', labor = 'SURGERY', skill = 'SURGERY', label = "Su"}
column {group = 4, color = 5, profession = 'BONE_SETTER', labor = 'BONE_SETTING', skill = 'SET_BONE', label = "Bo"}
column {group = 4, color = 5, profession = 'SUTURER', labor = 'SUTURING', skill = 'SUTURE', label = "St"}
column {group = 4, color = 5, profession = 'DOCTOR', labor = 'DRESSING_WOUNDS', skill = 'DRESS_WOUNDS', label = "Dr"}
column {group = 4, color = 5, profession = 'NONE', labor = 'FEED_WATER_CIVILIANS', skill = 'NONE', label = "Fd"}
column {group = 4, color = 5, profession = 'NONE', labor = 'RECOVER_WOUNDED', skill = 'NONE', label = "Re"}
-- Farming/Related
column {group = 5, color = 6, profession = 'BUTCHER', labor = 'BUTCHER', skill = 'BUTCHER', label = "Bu"}
column {group = 5, color = 6, profession = 'TANNER', labor = 'TANNER', skill = 'TANNER', label = "Ta"}
column {group = 5, color = 6, profession = 'PLANTER', labor = 'PLANT', skill = 'PLANT', label = "Gr"}
column {group = 5, color = 6, profession = 'DYER', labor = 'DYER', skill = 'DYER', label = "Dy"}
column {group = 5, color = 6, profession = 'SOAP_MAKER', labor = 'SOAP_MAKER', skill = 'SOAP_MAKING', label = "So"}
column {group = 5, color = 6, profession = 'WOOD_BURNER', labor = 'BURN_WOOD', skill = 'WOOD_BURNING', label = "WB"}
column {group = 5, color = 6, profession = 'POTASH_MAKER', labor = 'POTASH_MAKING', skill = 'POTASH_MAKING', label = "Po"}
column {group = 5, color = 6, profession = 'LYE_MAKER', labor = 'LYE_MAKING', skill = 'LYE_MAKING', label = "Ly"}
column {group = 5, color = 6, profession = 'MILLER', labor = 'MILLER', skill = 'MILLING', label = "Ml"}
column {group = 5, color = 6, profession = 'BREWER', labor = 'BREWER', skill = 'BREWING', label = "Br"}
column {group = 5, color = 6, profession = 'HERBALIST', labor = 'HERBALIST', skill = 'HERBALISM', label = "He"}
column {group = 5, color = 6, profession = 'THRESHER', labor = 'PROCESS_PLANT', skill = 'PROCESSPLANTS', label = "Th"}
column {group = 5, color = 6, profession = 'CHEESE_MAKER', labor = 'MAKE_CHEESE', skill = 'CHEESEMAKING', label = "Ch"}
column {group = 5, color = 6, profession = 'MILKER', labor = 'MILK', skill = 'MILK', label = "Mk"}
column {group = 5, color = 6, profession = 'SHEARER', labor = 'SHEARER', skill = 'SHEARING', label = "Sh"}
column {group = 5, color = 6, profession = 'SPINNER', labor = 'SPINNER', skill = 'SPINNING', label = "Sp"}
column {group = 5, color = 6, profession = 'COOK', labor = 'COOK', skill = 'COOK', label = "Co"}
column {group = 5, color = 6, profession = 'PRESSER', labor = 'PRESSING', skill = 'PRESSING', label = "Pr"}
column {group = 5, color = 6, profession = 'BEEKEEPER', labor = 'BEEKEEPING', skill = 'BEEKEEPING', label = "Be"}
column {group = 5, color = 6, profession = 'GELDER', labor = 'GELD', skill = 'GELD', label = "Ge"}
-- Fishing/Related
column {group = 6, color = 1, profession = 'FISHERMAN', labor = 'FISH', skill = 'FISH', label = "Fi"}
column {group = 6, color = 1, profession = 'FISH_CLEANER', labor = 'CLEAN_FISH', skill = 'PROCESSFISH', label = "Cl"}
column {group = 6, color = 1, profession = 'FISH_DISSECTOR', labor = 'DISSECT_FISH', skill = 'DISSECT_FISH', label = "Di"}
-- Metalsmithing
column {group = 7, color = 8, profession = 'FURNACE_OPERATOR', labor = 'SMELT', skill = 'SMELT', label = "Fu"}
column {group = 7, color = 8, profession = 'WEAPONSMITH', labor = 'FORGE_WEAPON', skill = 'FORGE_WEAPON', label = "We"}
column {group = 7, color = 8, profession = 'ARMORER', labor = 'FORGE_ARMOR', skill = 'FORGE_ARMOR', label = "Ar"}
column {group = 7, color = 8, profession = 'BLACKSMITH', labor = 'FORGE_FURNITURE', skill = 'FORGE_FURNITURE', label = "Bl"}
column {group = 7, color = 8, profession = 'METALCRAFTER', labor = 'METAL_CRAFT', skill = 'METALCRAFT', label = "Cr"}
-- Jewelry
column {group = 8, color = 10, profession = 'GEM_CUTTER', labor = 'CUT_GEM', skill = 'CUTGEM', label = "Cu"}
column {group = 8, color = 10, profession = 'GEM_SETTER', labor = 'ENCRUST_GEM', skill = 'ENCRUSTGEM', label = "Se"}
-- Crafts
column {group = 9, color = 9, profession = 'LEATHERWORKER', labor = 'LEATHER', skill = 'LEATHERWORK', label = "Le"}
column {group = 9, color = 9, profession = 'WOODCRAFTER', labor = 'WOOD_CRAFT', skill = 'WOODCRAFT', label = "Wo"}
column {group = 9, color = 9, profession = 'STONECRAFTER', labor = 'STONE_CRAFT', skill = 'STONECRAFT', label = "St"}
column {group = 9, color = 9, profession = 'BONE_CARVER', labor = 'BONE_CARVE', skill = 'BONECARVE', label = "Bo"}
column {group = 9, color = 9, profession = 'GLASSMAKER', labor = 'GLASSMAKER', skill = 'GLASSMAKER', label = "Gl"}
column {group = 9, color = 9, profession = 'WEAVER', labor = 'WEAVER', skill = 'WEAVING', label = "We"}
column {group = 9, color = 9, profession = 'CLOTHIER', labor = 'CLOTHESMAKER', skill = 'CLOTHESMAKING', label = "Cl"}
column {group = 9, color = 9, profession = 'STRAND_EXTRACTOR', labor = 'EXTRACT_STRAND', skill = 'EXTRACT_STRAND', label = "Ad"}
column {group = 9, color = 9, profession = 'POTTER', labor = 'POTTERY', skill = 'POTTERY', label = "Po"}
column {group = 9, color = 9, profession = 'GLAZER', labor = 'GLAZING', skill = 'GLAZING', label = "Gl"}
column {group = 9, color = 9, profession = 'WAX_WORKER', labor = 'WAX_WORKING', skill = 'WAX_WORKING', label = "Wx"}
column {group = 9, color = 9, profession = 'PAPERMAKER', labor = 'PAPERMAKING', skill = 'PAPERMAKING', label = "Pa"}
column {group = 9, color = 9, profession = 'BOOKBINDER', labor = 'BOOKBINDING', skill = 'BOOKBINDING', label = "Bk"}
-- Engineering
column {group = 10, color = 12, profession = 'SIEGE_ENGINEER', labor = 'SIEGECRAFT', skill = 'SIEGECRAFT', label = "En"}
column {group = 10, color = 12, profession = 'SIEGE_OPERATOR', labor = 'SIEGEOPERATE', skill = 'SIEGEOPERATE', label = "Op"}
column {group = 10, color = 12, profession = 'MECHANIC', labor = 'MECHANIC', skill = 'MECHANICS', label = "Me"}
column {group = 10, color = 12, profession = 'PUMP_OPERATOR', labor = 'OPERATE_PUMP', skill = 'OPERATE_PUMP', label = "Pu"}
-- Hauling
column {group = 11, color = 3, profession = 'NONE', labor = 'HAUL_STONE', skill = 'NONE', label = "St"}
column {group = 11, color = 3, profession = 'NONE', labor = 'HAUL_WOOD', skill = 'NONE', label = "Wo"}
column {group = 11, color = 3, profession = 'NONE', labor = 'HAUL_ITEM', skill = 'NONE', label = "It"}
column {group = 11, color = 3, profession = 'NONE', labor = 'HAUL_BODY', skill = 'NONE', label = "Bu"}
column {group = 11, color = 3, profession = 'NONE', labor = 'HAUL_FOOD', skill = 'NONE', label = "Fo"}
column {group = 11, color = 3, profession = 'NONE', labor = 'HAUL_REFUSE', skill = 'NONE', label = "Re"}
column {group = 11, color = 3, profession = 'NONE', labor = 'HAUL_FURNITURE', skill = 'NONE', label = "Fu"}
column {group = 11, color = 3, profession = 'NONE', labor = 'HAUL_ANIMALS', skill = 'NONE', label = "An"}
column {group = 11, color = 3, profession = 'NONE', labor = 'HANDLE_VEHICLES', skill = 'NONE', label = "Ve"}
column {group = 11, color = 3, profession = 'NONE', labor = 'HAUL_TRADE', skill = 'NONE', label = "Tr"}
column {group = 11, color = 3, profession = 'NONE', labor = 'HAUL_WATER', skill = 'NONE', label = "Wa"}
-- Other Jobs
column {group = 12, color = 4, profession = 'ARCHITECT', labor = 'ARCHITECT', skill = 'DESIGNBUILDING', label = "Ar"}
column {group = 12, color = 4, profession = 'ALCHEMIST', labor = 'ALCHEMIST', skill = 'ALCHEMY', label = "Al"}
column {group = 12, color = 4, profession = 'NONE', labor = 'CLEAN', skill = 'NONE', label = "Cl"}
column {group = 12, color = 4, profession = 'NONE', labor = 'PULL_LEVER', skill = 'NONE', label = "Lv"}
column {group = 12, color = 4, profession = 'NONE', labor = 'BUILD_ROAD', skill = 'NONE', label = "Ro"}
column {group = 12, color = 4, profession = 'NONE', labor = 'BUILD_CONSTRUCTION', skill = 'NONE', label = "Co"}
column {group = 12, color = 4, profession = 'NONE', labor = 'REMOVE_CONSTRUCTION', skill = 'NONE', label = "CR"}
-- Military - Weapons
column {group = 13, color = 7, profession = 'WRESTLER', labor = 'NONE', skill = 'WRESTLING', label = "Wr"}
column {group = 13, color = 7, profession = 'AXEMAN', labor = 'NONE', skill = 'AXE', label = "Ax"}
column {group = 13, color = 7, profession = 'SWORDSMAN', labor = 'NONE', skill = 'SWORD', label = "Sw"}
column {group = 13, color = 7, profession = 'MACEMAN', labor = 'NONE', skill = 'MACE', label = "Mc"}
column {group = 13, color = 7, profession = 'HAMMERMAN', labor = 'NONE', skill = 'HAMMER', label = "Ha"}
column {group = 13, color = 7, profession = 'SPEARMAN', labor = 'NONE', skill = 'SPEAR', label = "Sp"}
column {group = 13, color = 7, profession = 'CROSSBOWMAN', labor = 'NONE', skill = 'CROSSBOW', label = "Cb"}
column {group = 13, color = 7, profession = 'THIEF', labor = 'NONE', skill = 'DAGGER', label = "Kn"}
column {group = 13, color = 7, profession = 'BOWMAN', labor = 'NONE', skill = 'BOW', label = "Bo"}
column {group = 13, color = 7, profession = 'BLOWGUNMAN', labor = 'NONE', skill = 'BLOWGUN', label = "Bl"}
column {group = 13, color = 7, profession = 'PIKEMAN', labor = 'NONE', skill = 'PIKE', label = "Pk"}
column {group = 13, color = 7, profession = 'LASHER', labor = 'NONE', skill = 'WHIP', label = "La"}
-- Military - Other Combat
column {group = 14, color = 15, profession = 'NONE', labor = 'NONE', skill = 'BITE', label = "Bi"}
column {group = 14, color = 15, profession = 'NONE', labor = 'NONE', skill = 'GRASP_STRIKE', label = "St"}
column {group = 14, color = 15, profession = 'NONE', labor = 'NONE', skill = 'STANCE_STRIKE', label = "Ki"}
column {group = 14, color = 15, profession = 'NONE', labor = 'NONE', skill = 'MISC_WEAPON', label = "Mi"}
column {group = 14, color = 15, profession = 'NONE', labor = 'NONE', skill = 'MELEE_COMBAT', label = "Fg"}
column {group = 14, color = 15, profession = 'NONE', labor = 'NONE', skill = 'RANGED_COMBAT', label = "Ac"}
column {group = 14, color = 15, profession = 'NONE', labor = 'NONE', skill = 'ARMOR', label = "Ar"}
column {group = 14, color = 15, profession = 'NONE', labor = 'NONE', skill = 'SHIELD', label = "Sh"}
column {group = 14, color = 15, profession = 'NONE', labor = 'NONE', skill = 'DODGING', label = "Do"}
-- Military - Misc
column {group = 15, color = 8, profession = 'NONE', labor = 'NONE', skill = 'LEADERSHIP', label = "Ld"}
column {group = 15, color = 8, profession = 'NONE', labor = 'NONE', skill = 'TEACHING', label = "Te"}
column {group = 15, color = 8, profession = 'NONE', labor = 'NONE', skill = 'KNOWLEDGE_ACQUISITION', label = "St"}
column {group = 15, color = 8, profession = 'NONE', labor = 'NONE', skill = 'DISCIPLINE', label = "Di"}
column {group = 15, color = 8, profession = 'NONE', labor = 'NONE', skill = 'CONCENTRATION', label = "Co"}
column {group = 15, color = 8, profession = 'NONE', labor = 'NONE', skill = 'SITUATIONAL_AWARENESS', label = "Ob"}
column {group = 15, color = 8, profession = 'NONE', labor = 'NONE', skill = 'COORDINATION', label = "Cr"}
column {group = 15, color = 8, profession = 'NONE', labor = 'NONE', skill = 'BALANCE', label = "Ba"}
column {group = 15, color = 8, profession = 'NONE', labor = 'NONE', skill = 'CLIMBING', label = "Cl"}
-- Social
column {group = 16, color = 3, profession = 'NONE', labor = 'NONE', skill = 'PERSUASION', label = "Pe"}
column {group = 16, color = 3, profession = 'NONE', labor = 'NONE', skill = 'NEGOTIATION', label = "Ne"}
column {group = 16, color = 3, profession = 'NONE', labor = 'NONE', skill = 'JUDGING_INTENT', label = "Ju"}
column {group = 16, color = 3, profession = 'NONE', labor = 'NONE', skill = 'LYING', label = "Li"}
column {group = 16, color = 3, profession = 'NONE', labor = 'NONE', skill = 'INTIMIDATION', label = "In"}
column {group = 16, color = 3, profession = 'NONE', labor = 'NONE', skill = 'CONVERSATION', label = "Cn"}
column {group = 16, color = 3, profession = 'NONE', labor = 'NONE', skill = 'COMEDY', label = "Cm"}
column {group = 16, color = 3, profession = 'NONE', labor = 'NONE', skill = 'FLATTERY', label = "Fl"}
column {group = 16, color = 3, profession = 'NONE', labor = 'NONE', skill = 'CONSOLE', label = "Cs"}
column {group = 16, color = 3, profession = 'NONE', labor = 'NONE', skill = 'PACIFY', label = "Pc"}
-- Noble
column {group = 17, color = 5, profession = 'TRADER', labor = 'NONE', skill = 'APPRAISAL', label = "Ap"}
column {group = 17, color = 5, profession = 'ADMINISTRATOR', labor = 'NONE', skill = 'ORGANIZATION', label = "Or"}
column {group = 17, color = 5, profession = 'CLERK', labor = 'NONE', skill = 'RECORD_KEEPING', label = "RK"}
-- Miscellaneous
column {group = 18, color = 3, profession = 'NONE', labor = 'NONE', skill = 'THROW', label = "Th"}
column {group = 18, color = 3, profession = 'NONE', labor = 'NONE', skill = 'CRUTCH_WALK', label = "CW"}
column {group = 18, color = 3, profession = 'NONE', labor = 'NONE', skill = 'SWIMMING', label = "Sw"}
column {group = 18, color = 3, profession = 'NONE', labor = 'NONE', skill = 'KNAPPING', label = "Kn"}

column {group = 19, color = 6, profession = 'NONE', labor = 'NONE', skill = 'WRITING', label = "Wr"}
column {group = 19, color = 6, profession = 'NONE', labor = 'NONE', skill = 'PROSE', label = "Pr"}
column {group = 19, color = 6, profession = 'NONE', labor = 'NONE', skill = 'POETRY', label = "Po"}
column {group = 19, color = 6, profession = 'NONE', labor = 'NONE', skill = 'READING', label = "Rd"}
column {group = 19, color = 6, profession = 'NONE', labor = 'NONE', skill = 'SPEAKING', label = "Sp"}
column {group = 19, color = 6, profession = 'NONE', labor = 'NONE', skill = 'DANCE', label = "Dn"}
column {group = 19, color = 6, profession = 'NONE', labor = 'NONE', skill = 'MAKE_MUSIC', label = "MM"}
column {group = 19, color = 6, profession = 'NONE', labor = 'NONE', skill = 'SING_MUSIC', label = "SM"}
column {group = 19, color = 6, profession = 'NONE', labor = 'NONE', skill = 'PLAY_KEYBOARD_INSTRUMENT', label = "PK"}
column {group = 19, color = 6, profession = 'NONE', labor = 'NONE', skill = 'PLAY_STRINGED_INSTRUMENT', label = "PS"}
column {group = 19, color = 6, profession = 'NONE', labor = 'NONE', skill = 'PLAY_WIND_INSTRUMENT', label = "PW"}
column {group = 19, color = 6, profession = 'NONE', labor = 'NONE', skill = 'PLAY_PERCUSSION_INSTRUMENT', label = "PP"}

column {group = 20, color = 4, profession = 'NONE', labor = 'NONE', skill = 'CRITICAL_THINKING', label = "CT"}
column {group = 20, color = 4, profession = 'NONE', labor = 'NONE', skill = 'LOGIC', label = "Lo"}
column {group = 20, color = 4, profession = 'NONE', labor = 'NONE', skill = 'MATHEMATICS', label = "Ma"}
column {group = 20, color = 4, profession = 'NONE', labor = 'NONE', skill = 'ASTRONOMY', label = "As"}
column {group = 20, color = 4, profession = 'NONE', labor = 'NONE', skill = 'CHEMISTRY', label = "Ch"}
column {group = 20, color = 4, profession = 'NONE', labor = 'NONE', skill = 'GEOGRAPHY', label = "Ge"}
column {group = 20, color = 4, profession = 'NONE', labor = 'NONE', skill = 'OPTICS_ENGINEER', label = "OE"}
column {group = 20, color = 4, profession = 'NONE', labor = 'NONE', skill = 'FLUID_ENGINEER', label = "FE"}

column {group = 20, color = 5, profession = 'NONE', labor = 'NONE', skill = 'MILITARY_TACTICS', label = "MT"}
column {group = 20, color = 5, profession = 'NONE', labor = 'NONE', skill = 'TRACKING', label = "Tr"}
column {group = 20, color = 5, profession = 'NONE', labor = 'NONE', skill = 'MAGIC_NATURE', label = "Dr"}

-- Skill levels
level {name = "Dabbling",     points = 500,  abbr = '0'}
level {name = "Novice",       points = 600,  abbr = '1'}
level {name = "Adequate",     points = 700,  abbr = '2'}
level {name = "Competent",    points = 800,  abbr = '3'}
level {name = "Skilled",      points = 900,  abbr = '4'}
level {name = "Proficient",   points = 1000, abbr = '5'}
level {name = "Talented",     points = 1100, abbr = '6'}
level {name = "Adept",        points = 1200, abbr = '7'}
level {name = "Expert",       points = 1300, abbr = '8'}
level {name = "Professional", points = 1400, abbr = '9'}
level {name = "Accomplished", points = 1500, abbr = 'A'}
level {name = "Great",        points = 1600, abbr = 'B'}
level {name = "Master",       points = 1700, abbr = 'C'}
level {name = "High Master",  points = 1800, abbr = 'D'}
level {name = "Grand Master", points = 1900, abbr = 'E'}
level {name = "Legendary",    points = 2000, abbr = 'U'}
level {name = "Legendary+1",  points = 2100, abbr = 'V'}
level {name = "Legendary+2",  points = 2200, abbr = 'W'}
level {name = "Legendary+3",  points = 2300, abbr = 'X'}
level {name = "Legendary+4",  points = 2400, abbr = 'Y'}
level {name = "Legendary+5",  points = 0,    abbr = 'Z'}
