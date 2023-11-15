extends Sprite3D

func _ready():
	texture = $SubViewport.get_texture()
	$SubViewport/Control/Label.text = get_node("..").name
