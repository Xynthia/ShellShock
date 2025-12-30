extends Node3D

@onready var fire_init: GPUParticles3D = $"fire init"
@onready var smoke_spread: GPUParticles3D = $"smoke spread"

# Called when the node enters the scene tree for the first time.
func particle_start() -> void:
	smoke_spread.emitting = true
	fire_init.emitting = true
