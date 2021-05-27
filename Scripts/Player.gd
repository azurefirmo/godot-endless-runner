extends KinematicBody2D

var velocity = Vector2.ZERO

export var jump_velocity = 800.0
export var gravity_scale = 20.0

var score = 0

enum {
	JUMP,
	RUN,
	IDLE
}

var state = RUN

onready var animation = $AnimatedSprite
onready var jump_sound = $JumpSound
onready var death_sound = $DeathSound

func _ready():
	Signals.connect("rewardplayer", self, "rewardplayer")
	Signals.connect("killplayer", self, "killplayer")

func _physics_process(delta):
	match state:
		RUN:
			animation.play("Run")
		JUMP:
			velocity = Vector2.ZERO
			velocity.y -= jump_velocity
			animation.play("Jump")
			jump_sound.play()
			state = IDLE
		IDLE:
			pass	
	
	velocity.y += gravity_scale
	move_and_collide(velocity*delta)

func _input(event):
	if state == RUN:
		if event.is_action_pressed("Jump"):
			state = JUMP

func _on_Area2D_body_entered(body):
	if body is StaticBody2D:
		state = RUN

func _on_Area2D_body_exited(body):
	if body is StaticBody2D:
		state = JUMP

func rewardplayer(scoretoadd):
	score+=scoretoadd
	Signals.emit_signal("updatescore", score)

func killplayer():
	death_sound.play()
	yield(death_sound,"finished")
	queue_free()
