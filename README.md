# Task Tracker App

Proyek ini adalah implementasi aplikasi "Task Tracker App". Fokus utama pengembangan proyek ini bukan pada desain yang berlebihan, melainkan pada penulisan kode yang rapih, masuk akal, *scalable*, dan memperlihatkan kualitas *Flutter implementation* yang kuat.

Aplikasi ini mencakup seluruh fitur utama (melihat, menambah, mengubah status, dan melihat detail *task*), dan telah mengeksekusi semua poin bonus tambahan demi menunjukkan standar aplikasi berskala produksi.

---

## 🚀 Cara Menjalankan Project

### 1. Menjalankan Backend (Golang + SQLite + Docker)
*Backend* menggunakan Golang *backend implementation* yang dibungkus dengan Docker.
Pastikan Docker Daemon sudah berjalan di PC Desktop Anda. Masuk ke direktori `go-api/`, lalu jalankan:

```bash
# Membangun Docker image (Multi-stage build dengan CGO untuk SQLite)
docker build -t go-api .

# Menjalankan container dengan volume mapping agar database persisten
docker run -d -p 8080:8080 -v $(pwd):/app --name task_api go-api
```

### 2. Menjalankan Frontend (Flutter App)
Pastikan Anda menggunakan Flutter SDK yang diinstal secara mandiri (standalone installation). Menghindari instalasi melalui package manager distribusi Linux sangat disarankan untuk mencegah isu permission saat melakukan build atau update. Masuk ke direktori utama proyek, lalu jalankan:
```bash
flutter pub get
flutter run
```
Catatan Pengujian Lingkungan (Environment):
- Perangkat Fisik (Physical Device): Ubah Base URL menjadi IP lokal PC Desktop Anda (contoh: http://192.168.1.15:8080). (pastikan API dan device berada dalam jaringan yang sama untuk tes lokal)

## 📐 Architecture Explanation
Proyek ini tidak menggunakan Clean Architecture full textbook, melainkan dirancang dengan struktur Feature-First Architecture yang jelas dan maintainable. Setiap fitur (seperti tasks) memisahkan kodenya ke dalam tiga lapisan:
1. Presentation (presentation/): Menangani UI dan State Management.  
2. Domain (domain/): Menangani entitas data murni dan interface repositori (business logic) tanpa terikat dengan ekosistem luar.  
3. Data (data/): Menangani implementasi komunikasi API dan Local Caching.  

Alasan Memilih Pendekatan Ini:
Arsitektur ini sangat scalable. Saat aplikasi bertambah besar, pengembang tidak perlu melompat antar direktori layer global, melainkan cukup fokus memodifikasi satu ruang lingkup direktori fitur saja.

## 📊 State Management Explanation
Aplikasi ini menggunakan Provider (ChangeNotifier).

Alasan Memilih Pendekatan Ini:
Untuk aplikasi Task Tracker, Provider memberikan solusi yang paling optimal antara performa dan kecepatan pengembangan. Provider menangani kondisi asynchronous secara reaktif , memetakan status aplikasi dengan sangat jelas menjadi loading, error, atau loaded (baik ada data maupun empty data) tanpa tumpukan boilerplate berlebih yang biasa ditemukan pada Bloc.

## ✨ Fitur & Bonus Points
Selain kebutuhan API dasar (GET, POST, PATCH), aplikasi ini mengimplementasikan seluruh nilai tambahan:
- Golang Backend & Docker: Menggunakan backend sederhana mandiri yang terisolasi.  
- Infinite Scroll/Pagination: Menangani pemuatan data dalam jumlah besar tanpa memberatkan RAM.  
- Local Caching & Offline Support Sederhana: Menggunakan SharedPreferences untuk menyimpan kuki respons JSON. Aplikasi otomatis merender data lokal jika koneksi terputus.  
- Clean Reusable Widget System: Komponen antarmuka yang sering digunakan (CustomTextField, StatusBadge) diekstrak ke core/widgets/ untuk komposisi widget dan reusability yang konsisten.  
- Testing: Mencakup implementasi Unit test (untuk konversi JSON) dan Widget test (untuk komponen status).  
- CI/CD Sederhana: Terdapat skrip otomasi GitHub Actions (.github/workflows/flutter_ci.yml) untuk pengujian dan build otomatis setiap kali terjadi pembaruan kode.

# 📸 Demo Aplikasi
## 1. Screenshot
<img width="300" alt="Screenshot_20260621_140156" src="https://github.com/user-attachments/assets/c4eb01e9-03ae-40db-af15-39f577578a16" />
<img width="1080" height="2340" alt="Screenshot_20260621_140205" src="https://github.com/user-attachments/assets/058686c7-f91f-4623-80f3-b09d12b65a84" />
<img width="1080" height="2340" alt="Screenshot_20260621_140214" src="https://github.com/user-attachments/assets/bcb1d9de-7ed0-4238-9f9d-a47f85bc5fdf" />

## 2. Video
https://github.com/user-attachments/assets/059cb67d-122e-4e13-9b1d-3fcafdd640a8
