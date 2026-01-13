# StudyNotes - Aplikasi Catatan Belajar

Aplikasi mobile berbasis Flutter untuk membantu mencatat materi belajar dengan sistem offline-first menggunakan database lokal Hive.

## Tentang Aplikasi

StudyNotes dirancang untuk memudahkan mahasiswa dan pelajar dalam mengorganisir catatan belajar. Semua data tersimpan di perangkat, sehingga bisa diakses kapan saja tanpa koneksi internet.

Aplikasi ini dilengkapi dengan fitur kategorisasi warna, pin catatan penting, sistem multi-user, dan berbagai tools tambahan yang memudahkan proses belajar.

## Fitur Utama

### Manajemen Catatan
- Buat, edit, dan hapus catatan dengan mudah
- Atur catatan berdasarkan tag dan kategori
- Pin catatan penting agar selalu muncul di atas
- Pilih dari 8 tema warna untuk kategorisasi visual
- Tampilan list atau grid sesuai preferensi

### Sistem Filter & Pencarian
- Filter berdasarkan abjad (A-Z)
- Urutkan berdasarkan waktu terbaru atau terlama
- Tampilkan catatan yang di-pin terlebih dahulu
- Pencarian real-time di semua catatan
- Lihat catatan berdasarkan tanggal di kalender

### Multi-User
- Sistem registrasi dan login lokal
- Setiap user punya data terpisah
- Profil custom per pengguna
- Logout aman dengan session management

### Tools Tambahan
- Share catatan ke WhatsApp, Email, atau aplikasi lain
- Copy konten ke clipboard
- Animasi Lottie untuk UX yang lebih menarik
- Bottom navigation untuk akses cepat

## Teknologi yang Digunakan

- **Framework**: Flutter 3.x
- **Database Lokal**: Hive (NoSQL)
- **State Management**: StatefulWidget
- **Session**: SharedPreferences
- **Animasi**: Lottie
- **Kalender**: table_calendar
- **Share**: share_plus

## Struktur Project

```
lib/
├── models/          # Model data (Note, User)
├── screens/         # Halaman UI
├── services/        # Logic bisnis (SessionService)
├── widgets/         # Komponen reusable
├── utils/           # Helper & utilities
├── data/            # Inisialisasi Hive
└── animation/       # File Lottie JSON
```

## Cara Instalasi

### Prasyarat
- Flutter SDK (versi 3.0.0 ke atas)
- Android SDK / Xcode
- Git

### Langkah Setup
```bash
git clone <url-repository>
cd studynotes
flutter pub get
flutter run
```

### Build APK Release
```bash
flutter build apk --release
```

File APK akan tersimpan di: `build/app/outputs/flutter-apk/app-release.apk`

## Cara Penggunaan

### Pertama Kali
1. Buka aplikasi dan buat akun baru
2. Isi username, email, dan password
3. Login dengan akun yang sudah dibuat

### Membuat Catatan
1. Tekan tombol (+) di home screen
2. Isi judul, tag, dan konten catatan
3. Pilih warna kategori (opsional)
4. Centang "Pin Note" jika penting
5. Tap "Save" untuk menyimpan

### Mengatur Tampilan
- Tap icon grid/list di kanan atas untuk ganti mode tampilan
- Tap tombol filter untuk mengubah urutan catatan
- Gunakan tab Search untuk mencari catatan tertentu
- Buka tab Calendar untuk lihat berdasarkan tanggal

### Share & Copy
1. Buka catatan yang ingin dibagikan
2. Tap tombol "Share" untuk kirim ke aplikasi lain
3. Atau tap "Copy" untuk salin ke clipboard

## Penyimpanan Data

Semua data disimpan secara lokal menggunakan Hive:
- Box `notesBox` untuk menyimpan catatan
- Box `usersBox` untuk data akun
- SharedPreferences untuk session dan preferensi

⚠️ **Penting**: Uninstall aplikasi akan menghapus semua data. Pastikan export catatan penting sebelum uninstall.

## Development

### Code Generation

Setelah mengubah model class yang menggunakan Hive:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Hot Reload vs Hot Restart

- Gunakan `r` untuk hot reload (perubahan UI)
- Gunakan `R` untuk hot restart (perubahan state/asset baru)

## Keterbatasan

Berikut beberapa batasan yang perlu diketahui:
- Tidak ada sinkronisasi cloud (data lokal only)
- Belum support attachment file/gambar
- Hanya untuk satu perangkat
- Tidak ada fitur password recovery

## Pengembangan Selanjutnya

Rencana fitur untuk versi mendatang:
- Cloud backup dan sinkronisasi
- Support Markdown formatting
- Attachment gambar dan file
- Export catatan ke PDF
- Dark mode theme
- Reminder dengan push notification

## Lisensi

Project ini dibuat untuk keperluan akademis sebagai tugas mata kuliah Pemrograman Mobile.

## Kontak

Untuk pertanyaan atau saran, silakan buka issue di repository ini.

---

**Dibuat dengan Flutter** • **Database Lokal Hive** • **Multi-User Support**

*Aplikasi UAS - Pemrograman Mobile 2026*
