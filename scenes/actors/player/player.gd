extends Node2D

@export var PlayerUI: CanvasLayer
# --- COMPONENTS ---

@export var HealthComp: HealthComponent
@export var StaminaComp: StaminaComponent

@export var AbilitiesComp: AbilitiesComponent
@export var SpellsComp: SpellsComponent
@export var HotbarComp: HotbarComponent

@export var SkillsComp: SkillsComponent

@export var AttributesComp: AttributesComponent

@export var EquipmentComp: EquipmentComponent
@export var InventoryComp: InventoryComponent

@export var MeleeCombatComp: MeleeCombatComponent
@export var DefenseStatsComp: DefenseStatsComponent
@export var BlockComp: BlockComponent
@export var StanceComp: StanceComponent

@export var EnergyComp: EnergyComponent

@export var IdentityComp: IdentityComponent

@export var PositionComp: PositionComponent

@export var StateComp: StateComponent

@export var PlayerComp: PlayerComponent

@export var ModifiersComp: ModifiersComponent


@export var text_color: String

# --- PLAYER UI ---

@export var player_ui: CanvasLayer

func _ready():
	pass
	
func _process(_delta: float) -> void:
	pass



func load_player_data() -> void:
	pass


func get_component(component_key: int) -> Node:
	return get_node("Components").get_node(GameData.get_component_name(component_key))