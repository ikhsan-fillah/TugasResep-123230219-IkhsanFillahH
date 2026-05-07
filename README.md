# ResepKu — Aplikasi Resep Masakan (Flutter)

Aplikasi mobile sederhana untuk mencari dan melihat detail resep masakan dari **TheMealDB API**, lengkap dengan fitur **autentikasi (Register/Login)**, **favorit (persisten)**, dan **filter kategori**.

> **Tugas Praktikum Mobile IF-E**  
> **Nama:** Ikhsan Fillah Hidayat  
> **NIM:** 123230219

---

## Preview Fitur
- Autentikasi: **Register**, **Login**, dan **Logout** (menggunakan `SharedPreferences`)
- Home: daftar resep dalam **GridView**, **filter kategori**, dan **loading indicator**
- Detail resep: foto, nama, kategori, asal negara, daftar bahan, dan langkah memasak
- Favorit: **tambah/hapus** favorit
- Penyimpanan favorit **persisten** menggunakan **Hive**
- Halaman Favorite: grid daftar favorit + hapus item

---

## Tech Stack
- **Flutter**
- **Dart**
- **TheMealDB API**
- **SharedPreferences** (session sederhana)
- **Hive** (local database untuk favorit)

---

## Struktur Project
```text
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

---

## Cara Menjalankan
1. Pastikan Flutter SDK sudah ter-install.
2. Jalankan perintah berikut di root project:

```bash
flutter pub get
flutter run
```

> File `meal_model.g.dart` **sudah disertakan**, jadi **tidak perlu** menjalankan `build_runner`.

---

## Konfigurasi & Catatan
### Generate Model (Opsional)
Jika suatu saat kamu mengubah model dan perlu generate ulang file `*.g.dart`, gunakan:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

*(Namun untuk project ini, tidak wajib karena file generator sudah ada.)*

---

## API Reference (TheMealDB)
Base URL:
```
https://www.themealdb.com/api/json/v1/1/
```

Endpoint yang digunakan:
- **List resep per kategori**
  - `filter.php?c={kategori}`
- **Detail resep**
  - `lookup.php?i={id}`

---

## Alur Singkat Aplikasi
1. User **Register** lalu **Login**.
2. Masuk ke halaman utama (Home) berisi list resep.
3. User bisa memilih kategori (filter) untuk menampilkan resep tertentu.
4. Klik salah satu resep untuk melihat **Detail**.
5. User dapat menambahkan resep ke **Favorite** (tersimpan di Hive).
6. Di halaman **Favorite**, user dapat melihat daftar favorit dan menghapus item.

---

## Troubleshooting
- Jika aplikasi gagal jalan karena dependency, coba:
  ```bash
  flutter clean
  flutter pub get
  ```
- Pastikan emulator/perangkat sudah terhubung dan terdeteksi:
  ```bash
  flutter devices
  ```

---

## Lisensi
Project ini dibuat untuk kebutuhan tugas praktikum.
