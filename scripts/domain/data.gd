class_name Data
## Data konten Baca Ceria: huruf, suku kata, kata bergambar.

const HURUF: Array[String] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
const KONSONAN: Array[String] = ["b","m","s","k","t","p","n","l","g","r","d"]
const VOKAL: Array[String] = ["a","i","u","e","o"]
const KATA: Array[Dictionary] = [
	{"kata": "bola", "suku": ["bo", "la"]},
	{"kata": "buku", "suku": ["bu", "ku"]},
	{"kata": "mata", "suku": ["ma", "ta"]},
	{"kata": "topi", "suku": ["to", "pi"]},
	{"kata": "roti", "suku": ["ro", "ti"]},
	{"kata": "susu", "suku": ["su", "su"]},
	{"kata": "roda", "suku": ["ro", "da"]},
	{"kata": "meja", "suku": ["me", "ja"]},
]
const PUJIAN: Array[String] = ["hebat", "pintar", "bagus", "luar_biasa"]

static func suku_dari(kata: String) -> Array:
	for k in KATA:
		if String(k["kata"]) == kata:
			return k["suku"]
	return []
