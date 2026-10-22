class_name Bintang
extends Control
## Bintang penghargaan digambar prosedural (emas / abu).

var emas: bool = true

func _init(p_emas: bool = true, ukuran: float = 84.0) -> void:
	emas = p_emas
	custom_minimum_size = Vector2(ukuran, ukuran)
	mouse_filter = MOUSE_FILTER_IGNORE

func _draw() -> void:
	var t := size / 2.0
	var r_luar: float = minf(size.x, size.y) * 0.48
	var r_dalam: float = r_luar * 0.48
	var pts := PackedVector2Array()
	for i in 10:
		var a := -PI / 2.0 + PI * float(i) / 5.0
		var r := r_luar if i % 2 == 0 else r_dalam
		pts.append(t + Vector2(cos(a), sin(a)) * r)
	draw_colored_polygon(pts, Color("FFC93D") if emas else Color("C9CED6"))
	var tutup := PackedVector2Array(pts)
	tutup.append(pts[0])
	draw_polyline(tutup, Color("D9930D") if emas else Color("9AA0A8"), 4)
