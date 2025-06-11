extends HBoxContainer

@onready var buffs_container = $Buffs
@onready var debuffs_container = $Debuffs


func _ready() -> void:
	SignalBus.buff_added.connect(_on_buff_added)
	SignalBus.buff_removed.connect(_on_buff_removed)

	pass


func _on_buff_added(buff: Buff, actor: Node2D) -> void:
	if !actor.is_in_group("player"):
		return
	var buff_icon = load(DirectoryPaths.buff_icon_scene).instantiate()

	buff_icon.set_buff(buff)

	buffs_container.add_child(buff_icon)


func _on_buff_removed(buff: Buff, actor: Node2D) -> void:
	if !actor.is_in_group("player"):
		return

	for child in buffs_container.get_children():
		if child.buff == buff:
			child.queue_free()
