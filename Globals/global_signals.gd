extends Node

# Enumeration for selectable scenes
enum GameScene {MAIN_MENU, MERCHANT_SHOP, PLAYER_SHOP, PLAYER_FORGE}

# Signals to player
signal buy_item(item: Item, price: int)
signal sell_item(item: Item, price: int)
signal reputation_increase(title: String)

# UI Signals
signal inventory_full
signal not_enough_gold
signal item_not_found
signal update_gold
signal transaction_complete(item: Item, current_gold: int)

# Scene change signal
signal change_scene(load_scene: GameScene)

# Crafting signals
signal start_crafting
signal end_crafting
