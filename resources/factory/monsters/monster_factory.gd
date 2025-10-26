class_name MonsterFactory
extends Node


static func make_monster(data: Dictionary, class_type: Variant) -> MonsterBase:
	var _monster: MonsterBase = class_type.new(data)
	_monster.add_to_group("monsters")
	return _monster


static func make_monster_remains(monster_key: int = 0) -> MonsterRemains:
	var _monster_remains = MonsterRemains.new(monster_key)
	return _monster_remains
