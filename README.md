# ResepKu - Aplikasi Resep Masakan

**Tugas Praktikum Mobile IF-E**
- Nama : Ikhsan Fillah Hidayat
- NIM  : 123230219

Aplikasi resep masakan menggunakan Flutter + TheMealDB API.

## Struktur Project
```
lib/
├── main.dart
├── models/
│   ├── meal_model.dart
│   └── meal_model.g.dart
└── screens/
    ├── login_screen.dart
    ├── register_screen.dart
    ├── main_screen.dart
    ├── home_screen.dart
    ├── detail_screen.dart
    └── favorite_screen.dart
```

## Setup & Jalankan
```bash
flutter pub get
flutter run
```
> File `meal_model.g.dart` sudah disertakan, **tidak perlu** jalankan `build_runner`.

## API
Base URL: `https://www.themealdb.com/api/json/v1/1/`
- List resep: `/filter.php?c={kategori}`
- Detail: `/lookup.php?i={id}`

## Fitur
- [x] Register & Login (SharedPreferences)
- [x] Logout dari AppBar
- [x] Home: GridView resep + filter kategori + loading indicator
- [x] Detail: foto, nama, kategori, negara, bahan, cara masak
- [x] Toggle favorit (tambah/hapus)
- [x] Favorit disimpan di Hive (persisten)
- [x] Favorite Page: grid + hapus item
