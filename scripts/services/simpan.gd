class_name Simpan
## Progres bintang per mode, tersimpan lokal (user://progres.cfg).

const _PATH := "user://progres.cfg"
var data: Dictionary = {"huruf": {"sesi": 0, "bintang": 0}, "suku": {"sesi": 0, "bintang": 0}, "kata": {"sesi": 0, "bintang": 0}}

func muat() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(_PATH) == OK:
		for mode in data.keys():
			data[mode] = {"sesi": int(cfg.get_value(mode, "sesi", 0)), "bintang": int(cfg.get_value(mode, "bintang", 0))}

func catat_sesi(mode: String, bintang: int) -> void:
	if not data.has(mode):
		return
	data[mode]["sesi"] = int(data[mode]["sesi"]) + 1
	data[mode]["bintang"] = int(data[mode]["bintang"]) + bintang
	_tulis()

func total_bintang() -> int:
	var t := 0
	for mode in data.keys():
		t += int(data[mode]["bintang"])
	return t

func reset() -> void:
	for mode in data.keys():
		data[mode] = {"sesi": 0, "bintang": 0}
	_tulis()

func _tulis() -> void:
	var cfg := ConfigFile.new()
	for mode in data.keys():
		cfg.set_value(mode, "sesi", int(data[mode]["sesi"]))
		cfg.set_value(mode, "bintang", int(data[mode]["bintang"]))
	cfg.save(_PATH)
