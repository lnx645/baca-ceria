class_name Gaya
## Sistem desain "Ceria": warna permen, sudut sangat bulat, font Baloo 2.

const LANGIT_ATAS := Color("6ECBF5")
const LANGIT_BAWAH := Color("D8F7FF")
const RUMPUT := Color("7ED957")
const RUMPUT_GELAP := Color("57B93E")
const MATAHARI := Color("FFD93D")
const TEKS := Color("4A3B32")
const TEKS_LEMBUT := Color("8A7364")
const PUTIH := Color.WHITE
const PERMEN: Array[Color] = [
	Color("FF6B6B"), Color("FFA94D"), Color("FFD93D"), Color("6BCB77"),
	Color("4D96FF"), Color("9B5DE5"), Color("F15BB5"), Color("00C2A8"),
]
const BIRU := Color("4D96FF")
const HIJAU := Color("6BCB77")
const ORANYE := Color("FFA94D")
const PINK := Color("F15BB5")
const UNGU := Color("9B5DE5")
const EMAS := Color("FFC93D")

static var _font_tebal: Font
static var _font_judul: Font
static var _font_biasa: Font

static func font_tebal() -> Font:
	if _font_tebal == null:
		_font_tebal = load("res://aset/font/Baloo2-800.ttf")
	return _font_tebal

static func font_judul() -> Font:
	if _font_judul == null:
		_font_judul = load("res://aset/font/Baloo2-800.ttf")
	return _font_judul

static func font_biasa() -> Font:
	if _font_biasa == null:
		_font_biasa = load("res://aset/font/Baloo2-700.ttf")
	return _font_biasa

static func _kotak(warna: Color, radius: int, kedalaman: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = warna
	s.corner_radius_top_left = radius
	s.corner_radius_top_right = radius
	s.corner_radius_bottom_left = radius
	s.corner_radius_bottom_right = radius
	s.border_width_bottom = kedalaman
	s.border_color = warna.darkened(0.22)
	s.shadow_color = Color(0.2, 0.3, 0.4, 0.18)
	s.shadow_size = 6
	s.shadow_offset = Vector2(0, 3)
	s.content_margin_left = 18
	s.content_margin_right = 18
	s.content_margin_top = 10
	s.content_margin_bottom = 10 + kedalaman
	return s

## Tombol permen besar khas anak: bulat, berwarna, ada efek kedalaman.
static func tombol(teks: String, warna: Color, ukuran_font: int = 34) -> Button:
	var b := Button.new()
	b.text = teks
	b.add_theme_font_override("font", font_tebal())
	b.add_theme_font_size_override("font_size", ukuran_font)
	b.add_theme_color_override("font_color", PUTIH)
	b.add_theme_color_override("font_hover_color", PUTIH)
	b.add_theme_color_override("font_pressed_color", PUTIH)
	b.add_theme_stylebox_override("normal", _kotak(warna, 30, 8))
	b.add_theme_stylebox_override("hover", _kotak(warna.lightened(0.08), 30, 8))
	b.add_theme_stylebox_override("pressed", _kotak(warna.darkened(0.06), 30, 2))
	b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	b.button_down.connect(func() -> void:
		var tw := b.create_tween()
		tw.tween_property(b, "scale", Vector2(0.93, 0.93), 0.06))
	b.button_up.connect(func() -> void:
		var tw := b.create_tween()
		tw.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tw.tween_property(b, "scale", Vector2.ONE, 0.18))
	b.pivot_offset = b.size / 2.0
	b.resized.connect(func() -> void: b.pivot_offset = b.size / 2.0)
	return b

## Panel putih bulat lembut untuk kartu & popup.
static func panel(radius: int = 36) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = Color(1, 1, 1, 0.97)
	s.corner_radius_top_left = radius
	s.corner_radius_top_right = radius
	s.corner_radius_bottom_left = radius
	s.corner_radius_bottom_right = radius
	s.shadow_color = Color(0.2, 0.3, 0.4, 0.22)
	s.shadow_size = 14
	s.shadow_offset = Vector2(0, 6)
	s.content_margin_left = 28
	s.content_margin_right = 28
	s.content_margin_top = 22
	s.content_margin_bottom = 22
	return s

static func label(teks: String, ukuran: int = 28, warna: Color = TEKS, tebal: bool = false) -> Label:
	var l := Label.new()
	l.text = teks
	l.add_theme_font_override("font", font_tebal() if tebal else font_biasa())
	l.add_theme_font_size_override("font_size", ukuran)
	l.add_theme_color_override("font_color", warna)
	return l

static func judul(teks: String, ukuran: int = 54) -> Label:
	var l := label(teks, ukuran, TEKS, true)
	l.add_theme_color_override("font_shadow_color", Color(1, 1, 1, 0.65))
	l.add_theme_constant_override("shadow_offset_x", 0)
	l.add_theme_constant_override("shadow_offset_y", 3)
	return l
