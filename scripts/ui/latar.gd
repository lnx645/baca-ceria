class_name Latar
extends Control
## Pemandangan ceria prosedural: langit gradasi, matahari, awan bergerak, bukit, bunga.

var _t: float = 0.0

func _ready() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	set_process(true)

func _process(delta: float) -> void:
	_t += delta
	queue_redraw()

func _draw() -> void:
	var w := size.x
	var h := size.y
	# Langit gradasi (pita horizontal)
	var pita := 24
	for i in pita:
		var f := float(i) / float(pita)
		draw_rect(Rect2(0, h * f, w, h / pita + 2), Gaya.LANGIT_ATAS.lerp(Gaya.LANGIT_BAWAH, f))
	# Matahari + cahaya
	var mt := Vector2(w - 150, 105)
	for r in [104, 88]:
		draw_circle(mt, r, Color(1, 0.85, 0.24, 0.14))
	draw_circle(mt, 62, Gaya.MATAHARI)
	draw_circle(mt, 62, Color(0, 0, 0, 0))
	# Awan (3, melayang pelan)
	_gambar_awan(Vector2(fmod(140.0 + _t * 9.0, w + 340.0) - 170.0, 84))
	_gambar_awan(Vector2(fmod(640.0 + _t * 6.0, w + 420.0) - 210.0, 150))
	_gambar_awan(Vector2(fmod(1020.0 + _t * 12.0, w + 300.0) - 150.0, 60))
	# Bukit rumput
	draw_circle(Vector2(w * 0.16, h + h * 0.42), w * 0.42, Gaya.RUMPUT)
	draw_circle(Vector2(w * 0.86, h + h * 0.5), w * 0.5, Gaya.RUMPUT_GELAP)
	draw_circle(Vector2(w * 0.52, h + h * 0.56), w * 0.46, Gaya.RUMPUT)
	# Bunga-bunga kecil
	var bunga: Array[Color] = [Color("FF6B6B"), Color("FFD93D"), Color("F15BB5"), Color.WHITE, Color("FFA94D")]
	for i in 14:
		var fx := fmod(float(i * 173) + 60.0, w - 40.0) + 20.0
		var fy := h - 18.0 - fmod(float(i * 61), 54.0)
		draw_circle(Vector2(fx, fy), 6, bunga[i % bunga.size()])
		draw_circle(Vector2(fx, fy), 2.5, Color("FFF3B0"))

func _gambar_awan(p: Vector2) -> void:
	var c := Color(1, 1, 1, 0.92)
	draw_circle(p, 30, c)
	draw_circle(p + Vector2(34, 6), 24, c)
	draw_circle(p + Vector2(-34, 8), 22, c)
	draw_circle(p + Vector2(4, 12), 24, c)
