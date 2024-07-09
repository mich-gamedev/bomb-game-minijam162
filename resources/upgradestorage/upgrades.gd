class_name UpgradeStorage extends Resource

@export_range(0,2,0.01,"or_greater","suffix:x") var player_speed : float = 1
@export_range(0,2,0.01,"or_greater","suffix:x") var player_gravity : float = 1
@export_range(0,2,0.01,"or_greater","suffix:x") var player_jump : float = 1
@export_range(0,2,0.01,"or_greater","suffix:x") var player_slam_damage : float = 1
@export_range(0,2,0.01,"or_greater","suffix:x") var invincibility_time : float = 1
@export_range(0,2,0.01,"or_greater","suffix:x") var bomb_gravity : float = 1
@export_range(0,2,0.01,"or_greater","suffix:x") var bomb_speed : float = 1
@export_range(0,2,0.01,"or_greater","suffix:x") var bomb_damage: float = 1
@export_range(-90,90,0.01,"or_less","or_greater","suffix:°+") var bomb_spread: int = 15
@export_range(0,2,0.01,"or_greater","suffix:x") var explosion_radius :float = 1
@export_range(0,20,0.01,"or_greater","suffix:+") var bomb_count :int = 0
@export_range(0,20,0.01,"or_greater","suffix:+") var bomb_bounces :int = 0
@export_range(0,20,0.01,"or_greater","suffix:+") var dropped_bombs_on_death :int = 0
