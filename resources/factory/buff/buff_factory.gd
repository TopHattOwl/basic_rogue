class_name BuffFactory
extends Node


static func make_buff(data: Dictionary) -> Buff:
	var _buff = Buff.new()

	if data.is_empty():
		push_error("no data for buff in buff factory")
		return null

	_buff.duration = data.get("duration", 5)
	_buff.modifiers = data.get("modifiers", [])
	_buff.buff_name = data.get("buff_name", "Unknown Buff")
	_buff.description = data.get("description", "")

	var sprite_path = data.get("buff_sprite_path", "")
	if not sprite_path:
		var _sprite = PlaceholderTexture2D.new()
		_sprite.set_size(Vector2(16, 24))
		_buff.buff_sprite = _sprite
	else:
		_buff.buff_sprite = load(sprite_path)

	return _buff
