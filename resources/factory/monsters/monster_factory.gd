class_name MonsterFactory
extends Node


static func make_monster(data: Dictionary, class_type: Variant) -> MonsterBase:
	var _monster = class_type.new(data)
	return _monster


static func make_monster_remains(monster_key: int = 0) -> MonsterRemains:
	var _monster_remains = MonsterRemains.new(monster_key)
	return _monster_remains


