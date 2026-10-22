class_name Data
## Data konten Baca Ceria: huruf, suku kata, kata berfoto, kalimat, jalur tracing.

const HURUF: Array[String] = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
const KONSONAN: Array[String] = ["b","m","s","k","t","p","n","l","g","r","d","ng","ny"]
const VOKAL: Array[String] = ["a","i","u","e","o"]

## Kata berfoto. tema: hewan | buah | benda. suku: urutan suku kata (sesuai klip audio).
const KATA: Array[Dictionary] = [
	{"kata": "bola", "suku": ["bo", "la"], "tema": "benda"},
	{"kata": "buku", "suku": ["bu", "ku"], "tema": "benda"},
	{"kata": "mata", "suku": ["ma", "ta"], "tema": "benda"},
	{"kata": "topi", "suku": ["to", "pi"], "tema": "benda"},
	{"kata": "roti", "suku": ["ro", "ti"], "tema": "benda"},
	{"kata": "susu", "suku": ["su", "su"], "tema": "benda"},
	{"kata": "roda", "suku": ["ro", "da"], "tema": "benda"},
	{"kata": "meja", "suku": ["me", "ja"], "tema": "benda"},
	{"kata": "apel", "suku": ["a", "pel"], "tema": "buah"},
	{"kata": "pisang", "suku": ["pi", "sang"], "tema": "buah"},
	{"kata": "jeruk", "suku": ["je", "ruk"], "tema": "buah"},
	{"kata": "mangga", "suku": ["mang", "ga"], "tema": "buah"},
	{"kata": "anggur", "suku": ["ang", "gur"], "tema": "buah"},
	{"kata": "nanas", "suku": ["na", "nas"], "tema": "buah"},
	{"kata": "kucing", "suku": ["ku", "cing"], "tema": "hewan"},
	{"kata": "ikan", "suku": ["i", "kan"], "tema": "hewan"},
	{"kata": "singa", "suku": ["si", "nga"], "tema": "hewan"},
	{"kata": "monyet", "suku": ["mo", "nyet"], "tema": "hewan"},
	{"kata": "nyamuk", "suku": ["nya", "muk"], "tema": "hewan"},
	{"kata": "bangau", "suku": ["ba", "ngau"], "tema": "hewan"},
	{"kata": "sapi", "suku": ["sa", "pi"], "tema": "hewan"},
	{"kata": "ayam", "suku": ["a", "yam"], "tema": "hewan"},
]

## Kalimat sederhana: kata-kata chip + foto jangkar (kata yang punya foto).
const KALIMAT: Array[Dictionary] = [
	{"teks": "Kucing minum susu", "kata": ["kucing", "minum", "susu"], "foto": "kucing"},
	{"teks": "Ayah baca buku", "kata": ["ayah", "baca", "buku"], "foto": "buku"},
	{"teks": "Ibu beli roti", "kata": ["ibu", "beli", "roti"], "foto": "roti"},
	{"teks": "Adik main bola", "kata": ["adik", "main", "bola"], "foto": "bola"},
	{"teks": "Kucing makan ikan", "kata": ["kucing", "makan", "ikan"], "foto": "ikan"},
]

const PUJIAN: Array[String] = ["hebat", "pintar", "bagus", "luar_biasa"]

static func kata_dari(nama: String) -> Dictionary:
	for k in KATA:
		if String(k["kata"]) == nama:
			return k
	return {}

static func kata_tema(tema: String) -> Array:
	if tema == "semua":
		return KATA.duplicate()
	var hasil: Array = []
	for k in KATA:
		if String(k["tema"]) == tema:
			hasil.append(k)
	return hasil
