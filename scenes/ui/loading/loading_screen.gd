extends Control

@export var progress_bar: TextureProgressBar
@export var loading_label: Label


var progress: float

func _ready() -> void:
	SignalBus.loading_screen_progressed.connect(_loading_screen_progressed)
	SignalBus.loading_label_changed.connect(_on_loading_label_changed)

func _process(_delta: float) -> void:
	progress_bar.value = progress

func _loading_screen_progressed(_progress: float) -> void:
	progress = _progress

func _on_loading_label_changed(_label: String) -> void:
	loading_label.text = _label
