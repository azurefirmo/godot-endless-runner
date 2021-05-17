extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity = Vector2.ZERO

export var jump_velocity = 600.0
export var gravity_scale = 20.0

var can_jump = true

onready var animation = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.play("Run")
	# pass # Replace with function body.

func _physics_process(delta):
	velocity.y += gravity_scale
	move_and_collide(velocity*delta)

func _input(event):
	if can_jump:
		velocity = Vector2.ZERO
		if event.is_action_pressed("Jump"):
			velocity.y -= jump_velocity
			animation.play("Jump")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if body is StaticBody2D:
		print("Player on Floor!")
		can_jump = true
		animation.play("Run")

func _on_Area2D_body_exited(body):
	if body is StaticBody2D:
		can_jump = false
		print("Player not on Floor!")
		animation.play("Jump")
