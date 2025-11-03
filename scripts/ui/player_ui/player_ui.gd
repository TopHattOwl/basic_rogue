class_name PlayerUICanvas
extends CanvasLayer

# --- MESSAGE ---
@onready var message_log: RichTextLabel = $SideBar/MessageLog


# --- LOOK ---
@onready var look_ui: TextureRect = $LookUI
var look_ui_side = 1 # 1 = right, -1 = left
var look_target_stuff = []

# var look_target_stuff[0] = {
#     "texture": Texture2D,
#     "description": String,
#     "name": String,
# }

# --- STANCE BAR ---
@onready var stance_bar = $StanceBar

# --- INVENTORY ---
@onready var inventory: InventoryControlNode = $Inventory


# --- buffs & passives/bonuses ---
@onready var buffs_container: BuffsContainerHBox = $BuffsContainer
@onready var passives_container: HBoxContainer = $PassivesContainer


# --- BLOCK ---

func update_block_display(new_value, max_value):
	print("[PlayerUICanvas] blobk ui is not made yet")

# --- MESSAGE LOG ---
var last_message: String = ""
func log_message(message: String) -> void:
	var full_message = ">" + message + "\n"
	message_log.append_text(full_message)
	message_log.scroll_to_line(message_log.get_line_count()) # auto-scroll 
	last_message = message

func get_last_message() -> String:
	return message_log.get_text()

# --- LOOK UI ---
func toggle_look_ui() -> void:
	look_ui.visible = !look_ui.visible

func flip_look_ui() -> void:
	if look_ui_side == -1:
		get_node("LookUI").position.x = 400
	else:
		get_node("LookUI").position.x = 80
	look_ui_side *= -1

func set_look_ui_texture(texture: Texture2D) -> void:
	look_ui.get_node("TargetTileTexture").texture = texture

func update_look_ui(grid_pos: Vector2i) -> void:
	# update the look ui
	look_ui.get_node("TargetTileTexture").texture = look_target_stuff[0]["texture"]
	look_ui.get_node("Description").text = look_target_stuff[0]["description"]
	look_ui.get_node("Name").text = look_target_stuff[0]["name"]

	# update the position of the targeter
	var targeter = GameData.player.get_node("Targeter")
	targeter.top_level = true # this makes it not a child of the player so it's pos is not affected by player movement
	targeter.target_pos = grid_pos


func _ready() -> void:
	# hide/show ui
	inventory.visible = false
	stance_bar.visible = false
