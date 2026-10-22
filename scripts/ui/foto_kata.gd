class_name FotoKata
extends TextureRect
## Foto benda asli (Wikimedia Commons, CC) — sudah dipotong persegi & sudut bulat saat produksi.

var id_kata: String = "bola":
	set(v):
		id_kata = v
		_muat()

func _init(p_id: String = "bola") -> void:
	id_kata = p_id
	mouse_filter = MOUSE_FILTER_IGNORE
	expand_mode = EXPAND_IGNORE_SIZE
	stretch_mode = STRETCH_KEEP_ASPECT_CENTERED
	custom_minimum_size = Vector2(260, 260)
	_muat()

func _muat() -> void:
	var path := "res://aset/foto/%s.webp" % id_kata
	if ResourceLoader.exists(path):
		texture = load(path)
