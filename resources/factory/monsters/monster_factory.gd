class_name MonsterFactory
extends Node


static func make_monster(monster_key: int = 0) -> MonsterBase:
	var _monster = MonsterNormal.new(MonsterDefinitions.monster_definitions[monster_key])
	return _monster


static func make_monster_remains(monster_key: int = 0) -> MonsterRemains:
	var _monster_remains = MonsterRemains.new(monster_key)
	return _monster_remains
