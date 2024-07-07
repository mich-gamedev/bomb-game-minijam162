@tool
extends Area2D

@onready var desc: RichTextLabel = %Description
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var ui: Control = $UpgradeUI

@export_multiline var sign_text: String
@export var visible_in_editor := true

func _ready() -> void:
	if !Engine.is_editor_hint():
		body_entered.connect(_on_body_entered)
		body_exited.connect(_on_body_exited)
		ui.visible = false

func _physics_process(delta: float) -> void:
	desc.text = sign_text
	if Engine.is_editor_hint():
		ui.visible = visible_in_editor

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		print("player entered")
		anim.play(&"open")

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		print("player eexited")
		anim.play(&"close")
