extends Node
# autoload
# calls all resource factories to make the resources



func _ready() -> void:
    SkillFactory.initialize()
    # skill loading flow:
        # SkillDefinitions autoload hold data about all skills tree passives
        # ResourceFactory calls SkillFactory to make all passive skills
        # SkillFactory calls PassiveSkill to make a passive skill for each skill in SkillDefinitions