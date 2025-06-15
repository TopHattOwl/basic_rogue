extends Node

var is_active := false

var current_spell: SpellNode = null


func _ready() -> void:
    set_process(is_active)

func _process(_delta: float) -> void:

    if Input.is_action_just_pressed("click_left"):
        print("spell casted")
        exit_spell_aiming()


func enter_spell_aiming() -> void:
    is_active = true
    set_process(is_active)
    print("enter spell aiming mode")

func exit_spell_aiming() -> void:
    is_active = false
    set_process(is_active)
    print("exiting spell aiming mode")


    # enter previous input mode
    GameData.player.PlayerComp.input_mode = GameData.player.PlayerComp.prev_input_mode