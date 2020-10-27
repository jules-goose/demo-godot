extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var orb
var material 
var colorstring
# Called when the node enters the scene tree for the first time.
func _ready():
	orb = $Orb
	material = SpatialMaterial.new()
	pass # Replace with function body.
func update_color():
	var color = Color(colorstring)
	material.set_albedo(color)
	orb.material_override = material

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_color();
	pass
