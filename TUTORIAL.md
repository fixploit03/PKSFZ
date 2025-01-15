# Tutorial Cara Menggunakan PKSFZ

PKSFZ memiliki 10 menu yaitu:

- **Menu nomor 0**  
  Menu ini adalah menu untuk keluar dari program PKSFZ.
- **Menu nomor 1**  
  Menu ini adalah menu untuk menginstal alat-alat yang dibutuhkan oleh program PKSFZ.
- **Menu nomor 2**  
  Menu ini adalah menu untuk mengetahui jenis enkripsi apa yang digunakan oleh file ZIP.
- **Menu nomor 3**  
  Menu ini adalah menu untuk mengekstrak Hash file ZIP dalam format yang dapat digunakan oleh John The Ripper.
- **Menu nomor 4**  
  Menu ini adalah menu untuk mengekstrak Hash file ZIP dalam format yang dapat digunakan oleh Hashcat.
- **Menu nomor 5**  
  Menu ini adalah menu untuk memulihkan kata sandi file ZIP menggunakan Tools Fcrackzip.
- **Menu nomor 6**  
  Menu ini adalah menu untuk memulihkan kata sandi file ZIP menggunakan Tools John The Ripper.
- **Menu nomor 7**  
  Menu ini adalah menu untuk memulihkan kata sandi file ZIP menggunakan Tools Hashcat.
- **Menu nomor 8**  
  Menu ini adalah menu untuk mengekstrak file ZIP.
- **Menu nomor 9**  
  Menu ini adalah menu untuk menjelaskan tentang program PKSFZ.

## Cara Memulihkan Kata Sandi file ZIP

## 1. Memulihkan Kata Sandi File ZIP Menggunakan Fcrackzip

> Fcrackzip tidak dapat memulihkan kata sandi file ZIP dengan enkripsi AES. Fcrackzip hanya mendukung enkripsi lama, yaitu PKZIP (ZipCrypto). Untuk memeriksa jenis enkripsi file ZIP, gunakan menu nomor 2. Setelah jenis enkripsi yang digunakan oleh file ZIP diketahui, ikuti langkah-langkah berikut:

1. Jalankan program PKSFZ dengan mengetikkan `bash run.sh`.
2. Masukkan nama file ZIP yang ingin dipulihkan kata sandinya.
3. Pilih teknik pemulihan kata sandi file ZIP. Teknik yang tersedia adalah `Dictionary Attack` dan `Brute Force Attack`.
4. Program akan memulai proses pemulihan kata sandi menggunakan Fcrackzip.
5. Jika kata sandi ditemukan, program akan menampilkan kata sandi tersebut dan menyimpannya dalam file di folder `hasil`.
6. Setelah proses selesai, Anda diminta menekan `[Enter]` untuk kembali ke menu utama.

## 2. Memulihkan Kata Sandi File ZIP Menggunakan John The Ripper

> Untuk memulihkan kata sandi file ZIP menggunakan John The Ripper, diperlukan hash dari file ZIP. Gunakan menu nomor 3 untuk mendapatkan hash tersebut. Setelah hash diperoleh, ikuti langkah-langkah berikut:

1. Jalankan program PKSFZ dengan mengetikkan `bash run.sh`.
2. Masukkan nama file ZIP yang ingin dipulihkan kata sandinya.
3. Pilih jenis enkripsi yang digunakan oleh file ZIP.
   > Untuk memeriksa jenis enkripsi, gunakan menu nomor 2.
4. Masukkan nama file hash dari file ZIP.
5. Pilih teknik pemulihan kata sandi file ZIP. Teknik yang tersedia adalah `Dictionary Attack` dan `Brute Force Attack`.
6. Program akan memulai proses pemulihan kata sandi menggunakan John The Ripper.
7. Jika kata sandi ditemukan, program akan menampilkan kata sandi tersebut dan menyimpannya dalam file di folder `hasil`.
8. Setelah proses selesai, Anda diminta menekan `[Enter]` untuk kembali ke menu utama.
   
## 3. Memulihkan Kata Sandi File ZIP Menggunakan Hashcat

> Untuk memulihkan kata sandi file ZIP menggunakan Hashcat, diperlukan hash dari file ZIP. Gunakan menu nomor 4 untuk mendapatkan hash tersebut. Setelah hash diperoleh, ikuti langkah-langkah berikut:

1. Jalankan program PKSFZ dengan mengetikkan `bash run.sh`.
2. Masukkan nama file ZIP yang ingin dipulihkan kata sandinya.
3. Pilih jenis enkripsi yang digunakan oleh file ZIP.
   Untuk memeriksa jenis enkripsi, gunakan menu nomor 2.
4. Masukkan nama file hash dari file ZIP.
5. Pilih teknik pemulihan kata sandi file ZIP. Teknik yang tersedia adalah `Dictionary Attack` dan Brute `Force Attack`.
6. Program akan memulai proses pemulihan kata sandi menggunakan Hashcat.
7. Jika kata sandi ditemukan, program akan menampilkan kata sandi tersebut dan menyimpannya dalam file di folder `hasil`.
8. Setelah proses selesai, Anda diminta menekan `[Enter]` untuk kembali ke menu utama.

Jika Anda memiliki pertanyaan atau masalah, silakan ajukan di: [https://github.com/fixploit03/PKSFZ/issues](https://github.com/fixploit03/PKSFZ/issues)

