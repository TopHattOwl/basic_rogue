class_name TravelVisualComponent
extends SpellComponent
## if travel speed 0 -> instant anmation like lightning spells

@export var travel_animation: SpriteFrames

## tracel speed in pixels per second
@export var rotation_adjust: float = 0.0
var active_animation: Array = []


func on_cast(_spell: SpellResource, _spell_instance: SpellNode, _caster: Node2D, _target_grid: Variant = null) -> void:
    print("making travel visual")

    # var caster_grid_pos = _caster.get_component(GameData.ComponentKeys.POSITION).grid_pos
    # var caster_pos = MapFunction.to_world_pos(caster_grid_pos)

    # var target_pos = MapFunction.to_world_pos(_target_grid)

    # var projectile = AnimatedSprite2D.new()

    # projectile.frames = travel_animation
    # projectile.animation = "default"
    # projectile.centered = true
    # projectile.position = caster_pos

    # # rotation
    # var direction = (target_pos - caster_pos).normalized()

    # projectile.rotation = direction.angle() + deg_to_rad(rotation_adjust)

    # # add to scene
    # GameData.main_node.add_child(projectile)
    # projectile.play()
    # active_animation.append(projectile)

    # var tween = GameData.main_node.create_tween()

    # tween.tween_property(
    #     projectile,
    #     "position",
    #     target_pos,
    #     1.0 / travel_speed
    # )
    # tween.tween_callback(_on_travel_complete.bind(_spell, _caster, projectile, _target_grid))


    # once travel is completed call _on_travel_complete
    # _on_travel_complete(_spell, _caster, projectile, _target_grid)



# func _on_travel_complete(_spell: SpellResource, _caster: Node2D, projectile: AnimatedSprite2D, _target_grid: Variant = null) -> void:
#     projectile.queue_free()


#     # call hit visual component to make on hit visual and particles
#     if _spell.get_component(HitVisualComponent):
#         _spell.get_component(HitVisualComponent).on_hit(_spell, _caster, _target_grid)

#     if _spell.get_component(HitPariclesComponent):
#         _spell.get_component(HitPariclesComponent).on_hit(_spell, _caster, _target_grid)
