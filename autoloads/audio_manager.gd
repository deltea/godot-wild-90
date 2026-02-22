extends AudioStreamPlayer

var attack = preload("res://assets/sfx/universfield-swoosh-018-383967.mp3")
var hit = preload("res://assets/sfx/hit.wav")
var enemy_death = preload("res://assets/sfx/enemy_death.wav")
var card_hover = preload("res://assets/sfx/card_hover.wav")
var upgrade_appear = preload("res://assets/sfx/upgrade_appear.wav")
var upgrade = preload("res://assets/sfx/upgrade.wav")
var dash = preload("res://assets/sfx/click.wav")
var hurt = preload("res://assets/sfx/hurt.wav")
var death = preload("res://assets/sfx/death.wav")
var xp = preload("res://assets/sfx/pickupCoin (1).wav")

# var music = preload("res://assets/music.mp4")

var volume = 70

func _ready() -> void:
	connect("finished", func(): stream_paused = false)

func play_music(music: AudioStream):
	stream = music
	play()

func play_sound(sound: AudioStream, randomness: float = 0):
	var player = AudioStreamPlayer.new()
	player.pitch_scale = randf_range(1 - randomness, 1 + randomness)
	player.stream = sound
	player.connect("finished", player.queue_free)
	add_child(player)
	player.play()

func set_volume(value: int):
	volume = clamp(value, 0, 100)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(volume / 100.0))
