extends Control


@export var background: TextureRect
@export var conversation: RichTextLabel
@export var options_container: VBoxContainer


var conversation_tree: Dictionary
var npc: NPCBase
var current_dialoge_uid: String
# var prev_dialoge_uid: String

func _ready() -> void:
	conversation.bbcode_enabled = true
	conversation.scroll_following = true
	conversation.scroll_active = false

	start_dialoge()

## Starts the base talk dialoge
func start_dialoge() -> void:
	var base_talk = conversation_tree.get("base_talk", {}).duplicate()
	if not base_talk:
		# TODO: handle error
		return

	current_dialoge_uid = "base_talk"
	var lines: PackedStringArray = base_talk.get("lines", [])
	var options: Array = base_talk.get("options", [])

	add_npc_text(lines)
	add_buttons(options)
	

func show_dialogue(doaloge: Dictionary, uid: String) -> void:
	var lines: PackedStringArray = doaloge.get("lines", [])
	var options: Array = doaloge.get("options", []).duplicate()

	current_dialoge_uid = uid

	add_npc_text(lines)
	add_buttons(options)

	
## Resets the talk screen to base but does not print out base talk lines
func back_to_base() -> void:
	current_dialoge_uid = "base_talk"
	var options: Array = conversation_tree.get("base_talk", {}).get("options", []).duplicate()
	add_buttons(options)
	

# --- DATA ---

func set_talk_screen_data(_npc: Node2D) -> void:
	reset_talk_screen_data()
	npc = _npc
	conversation_tree = npc.get_component(GameData.ComponentKeys.TALK).conversation_tree


func reset_talk_screen_data() -> void:
	npc = null
	conversation.text = ""
	current_dialoge_uid = ""
	conversation_tree = {}
	clear_options_container()

func clear_options_container() -> void:
	for button in options_container.get_children():
		button.queue_free()


# --- BUTTONS ---
func add_buttons(_options: Array) -> void:

	clear_options_container()
	var all_options = _options.duplicate()

	# if base dialogue add extra options
	if current_dialoge_uid == "base_talk":
		if npc.get_component(GameData.ComponentKeys.QUEST_GIVER):
			all_options.append({"label": "quest", "leads_to": "quest_uid", "priority": 20})
		if npc.get_component(GameData.ComponentKeys.SHOP_KEEPER):
			all_options.append({"label": "shop", "leads_to": "shop", "priority": 30})
	else: # if not base dialogue, add back button
		all_options.append({"label": "back", "leads_to": "base_talk", "priority": 1})


	# sort by priority, descending
	all_options.sort_custom(func(a, b): return a.get("priority", 1) > b.get("priority", 1))

	for option: Dictionary in all_options:
		make_button(option.get("label", "Error: no label"), option)
	
	print("all options: ", all_options)

	
func make_button(label: String, option: Dictionary) -> void:
	var button = Button.new()
	button.text = label
	button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	button.theme = load(DirectoryPaths.main_theme)
	button.add_theme_font_size_override("font_size", 6)

	button.pressed.connect(_on_option_pressed.bind(option))

	options_container.add_child(button)


func _on_option_pressed(option: Dictionary) -> void:
	print("option pressed: ", option)

	if option.has("action"):
		match option.action:
			"end_talk":
				TalkManager.close_talk_screen()
	
	if option.has("leads_to"):
		var leads_to = option.get("leads_to")
		if leads_to == "base_talk":
			back_to_base()
		elif conversation_tree.additional_dialoges.has(leads_to):
			show_dialogue(conversation_tree.additional_dialoges.get(leads_to), leads_to)


# --- TEXT ---
func add_npc_text(text_array: PackedStringArray) -> void:

	for text in text_array:
		var npc_text = "> " + text + "\n"
		conversation.append_text(npc_text)
	add_separator()

func add_player_text(text: String) -> void:

	var player_text = "[right]" + text + " <\n[/right]"
	conversation.append_text(player_text)
	add_separator()

func add_misc_text(text: String) -> void:

	var misc_text = "[center]" + text + "\n[/center]"
	conversation.append_text(misc_text)
	add_separator()


func add_separator() -> void:
	conversation.append_text("--------------------------------------------------------------------\n")


# when the node is deleted this runs
func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		reset_talk_screen_data()
		print("talk screen closed")
