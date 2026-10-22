class_name Simpan
## Penyimpanan lokal v2: profil anak banyak, progres per mode, kata yang dikuasai
## (untuk Album Stiker), bendera premium, dan pengaturan musik.

const PATH := "user://progres.cfg"
const MODE_LABEL: Dictionary = {
	"huruf": "Belajar Huruf & Kuis", "suku": "Suku Kata & Susun Kata",
	"kata": "Kata Bergambar", "tulis": "Tulis Huruf",
	"kalimat": "Kalimat", "memori": "Kartu Memori",
}

var _cfg := ConfigFile.new()
var _aktif: String = "Anak 1"

func _init() -> void:
	muat()

func muat() -> void:
	var err := _cfg.load(PATH)
	if err != OK:
		_aktif = "Anak 1"
		_pastikan_profil(_aktif)
		return
	_aktif = String(_cfg.get_value("umum", "aktif", "Anak 1"))
	# Migrasi format lama (tanpa profil): bungkus sebagai "Anak 1"
	if not _cfg.has_section("profil/" + _aktif):
		var lama: Dictionary = {}
		for kunci in ["sesi", "bintang"]:
			var seksi := "progres"
			var d: Dictionary = {}
			for mode in MODE_LABEL.keys():
				var v = _cfg.get_value(seksi, mode + "_" + kunci, 0)
				d[mode] = int(v)
			lama[kunci] = d
		_tulis_profil("Anak 1", lama)
		_aktif = "Anak 1"
	_pastikan_profil(_aktif)

func _pastikan_profil(nama: String) -> void:
	if not _cfg.has_section("profil/" + nama):
		_tulis_profil(nama, {})

func _tulis_profil(nama: String, data: Dictionary) -> void:
	var sesi: Dictionary = data.get("sesi", {})
	var bintang: Dictionary = data.get("bintang", {})
	for mode in MODE_LABEL.keys():
		_cfg.set_value("profil/" + nama, "sesi_" + mode, int(sesi.get(mode, 0)))
		_cfg.set_value("profil/" + nama, "bintang_" + mode, int(bintang.get(mode, 0)))
	var dk: Array = data.get("kata_dikuasai", [])
	_cfg.set_value("profil/" + nama, "kata_dikuasai", dk)

func simpan_ke_disk() -> void:
	_cfg.set_value("umum", "aktif", _aktif)
	_cfg.save(PATH)

# --- Profil ---
func profil_aktif() -> String:
	return _aktif

func daftar_profil() -> Array:
	var hasil: Array = []
	for seksi in _cfg.get_sections():
		if seksi.begins_with("profil/"):
			hasil.append(seksi.trim_prefix("profil/"))
	if hasil.is_empty():
		hasil.append(_aktif)
	hasil.sort()
	return hasil

func tambah_profil(nama: String) -> bool:
	nama = nama.strip_edges()
	if nama.is_empty() or nama.length() > 16 or _cfg.has_section("profil/" + nama):
		return false
	_tulis_profil(nama, {})
	simpan_ke_disk()
	return true

func ganti_profil(nama: String) -> void:
	if _cfg.has_section("profil/" + nama):
		_aktif = nama
		simpan_ke_disk()

func hapus_profil(nama: String) -> void:
	if daftar_profil().size() <= 1:
		return
	_cfg.erase_section("profil/" + nama)
	if _aktif == nama:
		_aktif = String(daftar_profil()[0])
	simpan_ke_disk()

# --- Progres per mode (profil aktif) ---
func catat_sesi(mode: String, bintang_baru: int) -> void:
	var s := "profil/" + _aktif
	_cfg.set_value(s, "sesi_" + mode, sesi(mode) + 1)
	_cfg.set_value(s, "bintang_" + mode, bintang(mode) + bintang_baru)
	_cfg.set_value("umum", "tanggal_terakhir", Time.get_date_string_from_system())
	_cfg.set_value("umum", "sesi_hari_ini", sesi_hari_ini() + 1 if _hari_ini() else 1)
	simpan_ke_disk()

func _hari_ini() -> bool:
	return String(_cfg.get_value("umum", "tanggal_terakhir", "")) == Time.get_date_string_from_system()

func sesi_hari_ini() -> int:
	if _hari_ini():
		return int(_cfg.get_value("umum", "sesi_hari_ini", 0))
	return 0

func sesi(mode: String) -> int:
	return int(_cfg.get_value("profil/" + _aktif, "sesi_" + mode, 0))

func bintang(mode: String) -> int:
	return int(_cfg.get_value("profil/" + _aktif, "bintang_" + mode, 0))

func total_bintang() -> int:
	var t := 0
	for mode in MODE_LABEL.keys():
		t += bintang(mode)
	return t

func total_sesi() -> int:
	var t := 0
	for mode in MODE_LABEL.keys():
		t += sesi(mode)
	return t

func status_kemampuan(mode: String) -> String:
	var s := sesi(mode)
	var b := bintang(mode)
	if s == 0:
		return "Belum mulai"
	var rata := float(b) / float(s)
	if rata >= 2.6:
		return "Tuntas"
	if rata >= 1.8:
		return "Bagus"
	return "Mulai"

func saran_hari_ini() -> String:
	var terlemah := ""
	var skor_terendah := 999.0
	for mode in MODE_LABEL.keys():
		var s := sesi(mode)
		var skor := 99.0 if s == 0 else float(bintang(mode)) / float(s)
		if s == 0:
			skor = -1.0
		if skor < skor_terendah:
			skor_terendah = skor
			terlemah = mode
	if terlemah == "":
		return "Semua mode sudah dicoba. Hebat!"
	return "Hari ini coba main: " + String(MODE_LABEL.get(terlemah, terlemah))

# --- Kata dikuasai / stiker ---
func kata_dikuasai() -> Array:
	return Array(_cfg.get_value("profil/" + _aktif, "kata_dikuasai", []))

## Kembalikan true bila ini stiker BARU.
func tandai_kata(kata: String) -> bool:
	var dk := kata_dikuasai()
	if dk.has(kata):
		return false
	dk.append(kata)
	_cfg.set_value("profil/" + _aktif, "kata_dikuasai", dk)
	simpan_ke_disk()
	return true

# --- Premium & pengaturan (umum, bukan per profil) ---
func premium() -> bool:
	return bool(_cfg.get_value("umum", "premium", false))

func set_premium(v: bool) -> void:
	_cfg.set_value("umum", "premium", v)
	simpan_ke_disk()

func musik_nyala() -> bool:
	return bool(_cfg.get_value("umum", "musik", true))

func set_musik(v: bool) -> void:
	_cfg.set_value("umum", "musik", v)
	simpan_ke_disk()

func reset_semua() -> void:
	DirAccess.remove_absolute(ProjectSettings.globalize_path(PATH))
	_cfg = ConfigFile.new()
	_aktif = "Anak 1"
	_pastikan_profil(_aktif)
	simpan_ke_disk()
