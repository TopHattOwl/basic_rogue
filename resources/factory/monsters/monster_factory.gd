class_name MonsterFactory
extends Node


static func make_monster(monster_key: int = 0) -> MonsterBase:
    var _monster = MonsterNormal.new(MonsterDefinitions.monster_definitions[monster_key])
    return _monster