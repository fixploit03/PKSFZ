#!/bin/bash
# [tentang.sh]

if [[ $EUID -ne 0 ]]; then
	echo "[-] Program ini harus dijalankan sebagai root."
	exit 1
fi

if [[ ! -f "pemulih_kata_sandi_file_zip.sh" ]]; then
	echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
	exit 1
fi

clear

echo "+-----------------------------------------------------------+"
echo "| PKSFZ                                                     |"
echo "|                                                           |"
echo "| PKSFZ adalah program bash sederhana yang dirancang        |"
echo "| untuk memulihkan kata sandi file ZIP.                     |"
echo "|                                                           |"
echo "| PKSFZ menggunakan berbagai tools dan teknik untuk         |"
echo "| memulihkan kata sandi file ZIP. Tools yang digunakan      |"
echo "| diantaranya: Fcrackzip, John The Ripper dan Hashcat.      |"
echo "| Sementara teknik yang digunakan untuk memulihkan kata     |"
echo "| sandi file ZIP diantaranya: Dictionary Attack dan         |"
echo "| Brute Force Attcak. Dictionary Attack adalah teknik       |"
echo "| yang menggunakan daftar kata (dictionary) yang berisi     |"
echo "| kata sandi umum, frasa, atau kombinasi karakter yang      |"
echo "| sering digunakan. Sementara Brute Force Attack adalah     |"
echo "| teknik yang mencoba setiap kemungkinan kombinasi karakter |"
echo "| secara sistematis (misalnya, 001, 002, dan seterusnya).   |"
echo "|                                                           |"
echo "| Tujuan saya membuat program ini untuk mengotomatisasikan  |"
echo "| penggunaan tools seperti Fcrackzip, John The Ripper dan   |"
echo "| Hashcat. yang tadinya kita harus mengetik perintahnya     |"
echo "| secara manual menjadi otomastis.                          |"
echo "|                                                           |"
echo "| DISCLAIMER                                                |"
echo "|                                                           |"
echo "| PROGRAM INI GW BUAT HANYA UNTUK TUJUAN EDUKASI DAN        |"
echo "| PEMBELAJARAN AJA. JANGAN BUAT DIPAKE BUAT NGE-CRACK       |"
echo "| FILE ZIP ORANG KARENA ITU PERBUATAN YANG TIDAK BAIK.      |"
echo "| PAKELAH PROGRAM INI PADA FILE ZIP YANG LU PUNYA.          |"
echo "| MISALNYA LU LUPA SAMA KATA SANDI FILE ZIP LU. NAH         |"
echo "| LU PAKE DAH PROGRAM INI.                                  |"
echo "|                                                    [Rofi] |"
echo "+-----------------------------------------------------------+"
echo ""
read -p "Tekan [Enter] untuk kembali ke menu utama..."
if [[ -f "pemulih_kata_sandi_file_zip.sh" ]]; then
	bash "pemulih_kata_sandi_file_zip.sh"
else
        echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
        exit 1
fi

