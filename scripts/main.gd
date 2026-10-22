extends Node
## Baca Ceria — perakit utama: latar, layanan (suara & simpan), penukar layar.

var suara: Suara
var simpan: Simpan
var halo_dimainkan: bool = false

var _wadah: Control
var _layar_ini: Control

func _ready() -> void:
	Engine.max_fps = 120
	var latar := Latar.new()
	latar.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(latar)
	_wadah = Control.new()
	_wadah.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_wadah)
	suara = Suara.new()
	add_child(suara)
	simpan = Simpan.new()
	simpan.muat()
	if simpan.musik_nyala():
		suara.latar_mulai()
	ke_layar("menu")

func ke_layar(nama: String) -> void:
	if _layar_ini:
		_layar_ini.queue_free()
		_layar_ini = null
	var layar: Control
	match nama:
		"huruf":
			layar = LayarHuruf.new()
		"suku":
			layar = LayarSuku.new()
		"kata":
			layar = LayarKata.new()
		"tulis":
			layar = LayarTulis.new()
		"kalimat":
			layar = LayarKalimat.new()
		"memori":
			layar = LayarMemori.new()
		"album":
			layar = LayarAlbum.new()
		_:
			layar = LayarMenu.new()
	layar.set_anchors_preset(Control.PRESET_FULL_RECT)
	_wadah.add_child(layar)
	layar.siapkan(self)
	layar.minta.connect(ke_layar)
	_layar_ini = layar
