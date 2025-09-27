extends Sprite2D


@export var flash_interval: float = 1.0  # Time between flashes in seconds
@export var flash_duration: float = 0.2  # How long it stays invisible

var flash_timer: float = 0.0
var is_flashing: bool = false


func _ready():
    # Start flashing automatically
    start_flashing()

func _process(delta):
    if is_flashing:
        flash_timer += delta
        
        if flash_timer >= flash_interval:
            flash_timer = 0.0
            # Start the flash
            visible = false
            # Use a one-shot timer to make it visible again
            get_tree().create_timer(flash_duration).timeout.connect(_make_visible)

func _make_visible():
    visible = true

func start_flashing():
    is_flashing = true
    flash_timer = 0.0

func stop_flashing():
    is_flashing = false
    visible = true  # Ensure it's visible when stopped