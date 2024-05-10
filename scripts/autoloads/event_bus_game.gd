extends Node

signal change_scene(instance: Node)
# Draft phase
signal new_game()
# Market phase
signal start_game()
## From market to battle phase
#signal start_battle()
## From battle back to market phase
#signal end_battle()
# Results screen
signal end_game()
