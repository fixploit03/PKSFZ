#!/bin/bash
# [instal_alat.sh]

if [[ $EUID -ne 0 ]]; then
	echo "[-] Program ini harus dijalankan sebagai root."
	exit 1
fi

if [[ ! -f "pemulih_kata_sandi_file_zip.sh" ]]; then
	echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
	exit 1
fi

clear

echo "+-------------------------------------------------+"
echo "|                                                 |"
echo "|     Menu + Instal Alat-alat yang Dibutuhkan     |"
echo "|                                                 |"
echo "+-------------------------------------------------+"
echo ""

daftar_alat=(
	"p7zip-full"
	"zip"
	"john-data"
	"unzip"
	"fcrackzip"
	"john"
	"hashcat"
)

gagal=()

echo "[*] Mengecek koneksi internet..."
echo ""
if ping -c 4 google.com; then
	echo ""
	echo "[+] Anda memiliki koneksi internet"
else
	echo ""
	echo "[-] Anda tidak memiliki koneksi internet."
	echo ""
	read -p "Tekan [Enter] untuk kembali kemenu utama..."
	if [[ -f "pemulih_kata_sandi_file_zip.sh" ]]; then
        	bash "pemulih_kata_sandi_file_zip.sh"
        else
                echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
                exit 1
        fi
fi

for alat in "${daftar_alat[@]}"; do
	echo "[*] Menginstal '${alat}'..."
	apt-get install "${alat}"
	if [[ $? -eq 0 ]]; then
		echo "[+] '${alat}' berhasil diinstal."
	else
		echo "[-] '${alat}' gagal diinstal."
		gagal+=("${alat}")
	fi
done

if [[ "${#gagal[@]}" -ne 0 ]]; then
	echo "[-] Ada alat yang gagal diinstal:"
	echo ""
	for alat_gagal in "${gagal[@]}"; do
		echo "- ${alat_gagal}"
	done
	echo ""
	read -p "Tekan [Enter] untuk kembali kemenu utama..."
	if [[ -f "pemulih_kata_sandi_file_zip.sh" ]]; then
        	bash "pemulih_kata_sandi_file_zip.sh"
        else
                echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
                exit 1
        fi
else
	echo "[+] Semua alat-alat yang dibutuhkan berhasil diinstal."
	echo ""
	read -p "Tekan [Enter] untuk kembali kemenu utama..."
	if [[ -f "pemulih_kata_sandi_file_zip.sh" ]]; then
        	bash "pemulih_kata_sandi_file_zip.sh"
        else
                echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
                exit 1
        fi
fi

