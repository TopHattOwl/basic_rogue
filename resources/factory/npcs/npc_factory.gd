class_name NPCFactory
extends Node



static func make_npc(data: Dictionary) -> NPCBase:
	var _npc = NPCBase.new(data)
	return _npc
