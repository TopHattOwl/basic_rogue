extends Node2D



# --- COMPONENTS ---

@export var HealthComp: HealthComponent
@export var StaminaComp: StaminaComponent

@export var AbilitiesComp: AbilitiesComponent
@export var SpellsComp: SpellsComponent

@export var SkillsComp: SkillsComponent

@export var AttributesComp: AttributesComponent

@export var EquipmentComp: EquipmentComponent
@export var InventoryComp: InventoryComponent

@export var MeleeCombatComp: MeleeCombatComponent
@export var StanceComp: StanceComponent

@export var IdentityComp: IdentityComponent

@export var PositionComp: PositionComponent

@export var StateComp: StateComponent

@export var PlayerComp: PlayerComponent

@export var ModifiersComp: ModifiersComponent


func _ready():
	pass

func _process(_delta: float) -> void:
	pass



func load_player_data() -> void:
	pass


