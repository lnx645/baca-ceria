class_name GambarKata
extends Control
## Ilustrasi kata bergaya flat anak, digambar prosedural per id kata.

var id_kata: String = "bola"

func _init(p_id: String = "bola") -> void:
	id_kata = p_id
	mouse_filter = MOUSE_FILTER_IGNORE
	custom_minimum_size = Vector2(220, 180)

func _draw() -> void:
	var t := size / 2.0
	match id_kata:
		"bola":
			draw_circle(t, 72, Color("FF8A3D"))
			draw_arc(t, 72, 0, TAU, 48, Color("B3541E"), 6)
			draw_circle(t, 26, Color.WHITE)
			for a: float in [0.0, 1.26, 2.51, 3.77, 5.03]:
				draw_circle(t + Vector2(cos(a), sin(a)) * 52, 14, Color.WHITE)
		"buku":
			var sb_sampul := StyleBoxFlat.new()
			sb_sampul.bg_color = Color("4D96FF")
			sb_sampul.corner_radius_top_left = 16
			sb_sampul.corner_radius_top_right = 16
			sb_sampul.corner_radius_bottom_left = 16
			sb_sampul.corner_radius_bottom_right = 16
			draw_style_box(sb_sampul, Rect2(t.x - 82, t.y - 58, 164, 116))
			var sb_halaman := StyleBoxFlat.new()
			sb_halaman.bg_color = Color.WHITE
			sb_halaman.corner_radius_top_left = 10
			sb_halaman.corner_radius_top_right = 10
			sb_halaman.corner_radius_bottom_left = 10
			sb_halaman.corner_radius_bottom_right = 10
			draw_style_box(sb_halaman, Rect2(t.x - 74, t.y - 50, 68, 100))
			draw_style_box(sb_halaman, Rect2(t.x + 6, t.y - 50, 68, 100))
			for i in 3:
				draw_line(Vector2(t.x - 60, t.y - 24 + i * 26), Vector2(t.x - 22, t.y - 24 + i * 26), Color("B9C6D2"), 6)
				draw_line(Vector2(t.x + 20, t.y - 24 + i * 26), Vector2(t.x + 58, t.y - 24 + i * 26), Color("B9C6D2"), 6)
		"mata":
			_elips(Rect2(t.x - 86, t.y - 46, 172, 92), Color.WHITE)
			draw_arc(t, 84, 0, PI, 40, Color("4A3B32"), 6)
			draw_arc(t, 84, PI, TAU, 40, Color("4A3B32"), 6)
			draw_circle(t, 40, Color("7B4B2A"))
			draw_circle(t, 19, Color("26221F"))
			draw_circle(t + Vector2(9, -10), 7, Color.WHITE)
			for i: float in [-1.0, 0.0, 1.0]:
				draw_line(t + Vector2(i * 44, -48), t + Vector2(i * 52, -66), Color("4A3B32"), 6)
		"topi":
			draw_arc(t + Vector2(0, 26), 62, PI, TAU, 40, Color("FF6B6B"))
			draw_circle(t + Vector2(0, 26), 62, Color(0, 0, 0, 0))
			_elips(Rect2(t.x - 92, t.y + 12, 184, 30), Color("E14B4B"))
			draw_circle(t + Vector2(0, -38), 13, Color("FFD93D"))
			# tutup setengah lingkaran dengan poligon
			var pts := PackedVector2Array()
			for i in 25:
				var a := PI + PI * float(i) / 24.0
				pts.append(t + Vector2(0, 26) + Vector2(cos(a), sin(a)) * 62)
			pts.append(t + Vector2(62, 26))
			draw_colored_polygon(pts, Color("FF6B6B"))
			_elips(Rect2(t.x - 92, t.y + 12, 184, 30), Color("E14B4B"))
		"roti":
			_elips(Rect2(t.x - 84, t.y - 52, 168, 104), Color("E8A24B"))
			_elips(Rect2(t.x - 84, t.y - 52, 168, 60), Color("F4BC6B"))
			for i: float in [-1.0, 0.0, 1.0]:
				draw_line(t + Vector2(i * 42 - 12, -34), t + Vector2(i * 42 + 12, -16), Color("C97F2D"), 7)
		"susu":
			draw_rect(Rect2(t.x - 46, t.y - 26, 92, 96), Color("4D96FF"))
			draw_colored_polygon(PackedVector2Array([Vector2(t.x - 46, t.y - 26), Vector2(t.x, t.y - 66), Vector2(t.x + 46, t.y - 26)]), Color("3A7BD5"))
			draw_rect(Rect2(t.x - 46, t.y + 8, 92, 26), Color.WHITE)
			draw_circle(t + Vector2(0, 46), 13, Color.WHITE)
		"roda":
			draw_circle(t, 74, Color("3B3B45"))
			draw_circle(t, 52, Color("C9CED6"))
			for i in 5:
				var a := TAU * float(i) / 5.0
				draw_line(t, t + Vector2(cos(a), sin(a)) * 48, Color("8A8F99"), 9)
			draw_circle(t, 17, Color("5A5E68"))
		"meja":
			_elips(Rect2(t.x - 92, t.y - 44, 184, 30), Color("B07B4F"))
			draw_rect(Rect2(t.x - 78, t.y - 16, 16, 76), Color("96683F"))
			draw_rect(Rect2(t.x + 62, t.y - 16, 16, 76), Color("96683F"))
			draw_rect(Rect2(t.x - 30, t.y - 62, 60, 20), Color("F15BB5"))

func _elips(r: Rect2, c: Color) -> void:
	var pts := PackedVector2Array()
	var tengah := r.get_center()
	for i in 28:
		var a := TAU * float(i) / 28.0
		pts.append(tengah + Vector2(cos(a) * r.size.x / 2.0, sin(a) * r.size.y / 2.0))
	draw_colored_polygon(pts, c)
