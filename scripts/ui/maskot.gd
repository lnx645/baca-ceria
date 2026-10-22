class_name Maskot
extends Control
## Kiko, burung hantu ramah: digambar prosedural, berkedip & bergoyang; senang() = lompat.

var _kedip: float = 1.0
var _waktu: float = 0.0

func _ready() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	custom_minimum_size = Vector2(240, 260)
	var timer := Timer.new()
	timer.wait_time = 2.8
	timer.autostart = true
	add_child(timer)
	timer.timeout.connect(func() -> void:
		var tw := create_tween()
		tw.tween_property(self, "_kedip", 0.08, 0.07)
		tw.tween_property(self, "_kedip", 1.0, 0.12))
	set_process(true)

func _process(delta: float) -> void:
	_waktu += delta
	queue_redraw()

func senang() -> void:
	var tw := create_tween()
	tw.tween_property(self, "scale", Vector2(1.1, 0.9), 0.09)
	tw.tween_property(self, "scale", Vector2(0.94, 1.1), 0.12)
	tw.tween_property(self, "scale", Vector2.ONE, 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	pivot_offset = size / 2.0

func _draw() -> void:
	var cx := size.x / 2.0
	var bob := sin(_waktu * 2.2) * 4.0
	var cy := size.y / 2.0 + bob
	var badan := Color("00B4A2")
	var perut := Color("FFF3D6")
	var sayap := Color("009E8C")
	# Kaki
	draw_ellipse(Rect2(cx - 52, cy + 92, 34, 16), Color("FFA94D"))
	draw_ellipse(Rect2(cx + 18, cy + 92, 34, 16), Color("FFA94D"))
	# Sayap
	draw_ellipse(Rect2(cx - 108, cy - 8, 44, 84), sayap)
	draw_ellipse(Rect2(cx + 64, cy - 8, 44, 84), sayap)
	# Badan
	draw_ellipse(Rect2(cx - 84, cy - 96, 168, 196), badan)
	# Perut
	draw_ellipse(Rect2(cx - 52, cy + 6, 104, 84), perut)
	# Jambul telinga
	draw_colored_polygon(PackedVector2Array([Vector2(cx - 66, cy - 74), Vector2(cx - 84, cy - 116), Vector2(cx - 34, cy - 94)]), badan)
	draw_colored_polygon(PackedVector2Array([Vector2(cx + 66, cy - 74), Vector2(cx + 84, cy - 116), Vector2(cx + 34, cy - 94)]), badan)
	# Mata besar
	for sisi: float in [-1.0, 1.0]:
		var mx: float = cx + sisi * 38.0
		draw_circle(Vector2(mx, cy - 30), 30, Color.WHITE)
		draw_circle(Vector2(mx, cy - 30 + (1.0 - _kedip) * 6.0), 15, Color("333333"))
		if _kedip < 0.3:
			draw_line(Vector2(mx - 26, cy - 30), Vector2(mx + 26, cy - 30), Color("333333"), 6)
		else:
			draw_circle(Vector2(mx + 5, cy - 36), 5, Color.WHITE)
	# Paruh
	draw_colored_polygon(PackedVector2Array([Vector2(cx - 13, cy + 2), Vector2(cx + 13, cy + 2), Vector2(cx, cy + 20)]), Color("FF8A3D"))
	# Pipi
	draw_circle(Vector2(cx - 58, cy + 14), 11, Color(1, 0.55, 0.6, 0.55))
	draw_circle(Vector2(cx + 58, cy + 14), 11, Color(1, 0.55, 0.6, 0.55))

func draw_ellipse(r: Rect2, c: Color) -> void:
	var pts := PackedVector2Array()
	var tengah := r.get_center()
	for i in 28:
		var a := TAU * float(i) / 28.0
		pts.append(tengah + Vector2(cos(a) * r.size.x / 2.0, sin(a) * r.size.y / 2.0))
	draw_colored_polygon(pts, c)
