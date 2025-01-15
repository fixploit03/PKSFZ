#!/bin/bash
# [pemulih_kata_sandi_file_zip.sh]

if [[ $EUID -ne 0 ]]; then
	echo "[-] Program ini harus dijalankan sebagai root."
	exit 1
fi

if [[ ! -f "run.sh" ]]; then
	echo "[-] File 'run.sh' tidak ditemukan."
	exit 1
fi

clear

echo "+-----------------------------------------------+"
echo "|                                               |"
echo "|            ╔═╗  ╦╔═  ╔═╗  ╔═╗  ╔═╗            |"
echo "|            ╠═╝  ╠╩╗  ╚═╗  ╠╣   ╔═╝            |"
echo "|            ╩    ╩ ╩  ╚═╝  ╚    ╚═╝            |"
echo "|                                               |"
echo "|     Program + Pemulih Kata Sandi File ZIP     |"
echo "|                                               |"
echo "|       Dibuat oleh Rofi dengan ❤️  dan ☕       |"
echo "|                                               |"
echo "+-----------------------------------------------+"
echo ""
echo "Daftar Menu:"
echo ""
echo "[0] Keluar"
echo "[1] Instal Alat-alat yang Dibutuhkan"
echo "[2] Cek Enkripsi File ZIP"
echo "[3] Ekstrak Hash File ZIP (Joh The Ripper)"
echo "[4] Ekstrak Hash File ZIP (Hashcat)"
echo "[5] Pulihkan Kata Sandi File ZIP (Fcrackzip)"
echo "[6] Pulihkan Kata Sandi File ZIP (John The Ripper)"
echo "[7] Pulihkan Kata Sandi File ZIP (Hashcat)"
echo "[8] Ekstrak File ZIP"
echo "[9] Tentang"
echo ""

while true; do
	read -p "[#] Pilih menu: " pilih_menu
	if [[ "${pilih_menu}" == "0" ]]; then
		if [[ -f "keluar.sh" ]]; then
			bash "keluar.sh"
		else
			echo "[-] File 'keluar.sh' tidak ditemukan."
			exit 1
		fi
		break
	elif [[ "${pilih_menu}" == "1" ]]; then
		if [[ -f "instal_alat.sh" ]]; then
			bash "instal_alat.sh"
		else
			echo "[-] File 'instal_alat.sh' tidak ditemukan."
			exit 1
		fi
		break
	elif [[ "${pilih_menu}" == "2" ]]; then
		if [[ -f "cek_enkripsi_file_zip.sh" ]]; then
			bash "cek_enkripsi_file_zip.sh"
		else
			echo "[-] File 'cek_enkripsi_file_zip.sh' tidak ditemukan."
			exit 1
		fi
		break
	elif [[ "${pilih_menu}" == "3" ]]; then
		if [[ -f "ekstrak_hash_file_zip_john.sh" ]]; then
			bash "ekstrak_hash_file_zip_john.sh"
		else
			echo "[-] File 'ekstrak_hash_file_zip_john.sh' tidak ditemukan."
			exit 1
		fi
		break
	elif [[ "${pilih_menu}" == "4" ]]; then
		if [[ -f "ekstrak_hash_file_zip_hashcat.sh" ]]; then
			bash "ekstrak_hash_file_zip_hashcat.sh"
		else
			echo "[-] File 'ekstrak_hash_file_zip_hashcat.sh' tidak ditemukan."
			exit 1
		fi
		break
	elif [[ "${pilih_menu}" == "5" ]]; then
		if [[ -f "pulihkan_kata_sandi_file_zip_fcrackzip.sh" ]]; then
			bash "pulihkan_kata_sandi_file_zip_fcrackzip.sh"
		else
			echo "[-] File 'pulihkan_kata_sandi_file_zip_fcrackzip.sh' tidak ditemukan."
			exit 1
		fi
		break
	elif [[ "${pilih_menu}" == "6" ]]; then
		if [[ -f "pulihkan_kata_sandi_file_zip_john.sh" ]]; then
                        bash "pulihkan_kata_sandi_file_zip_john.sh"
                else
                        echo "[-] File 'pulihkan_kata_sandi_file_zip_john.sh' tidak ditemukan."
                        exit 1
                fi
		break
	elif [[ "${pilih_menu}" == "7" ]]; then
		if [[ -f "pulihkan_kata_sandi_file_zip_hashcat.sh" ]]; then
                        bash "pulihkan_kata_sandi_file_zip_hashcat.sh"
                else
                        echo "[-] File 'pulihkan_kata_sandi_file_zip_hashcat.sh' tidak ditemukan."
                        exit 1
                fi
		break
	elif [[ "${pilih_menu}" == "8" ]]; then
		if [[ -f "ekstrak_file_zip.sh" ]]; then
                        bash "ekstrak_file_zip.sh"
                else
                        echo "[-] File 'ekstrak_file_zip.sh' tidak ditemukan."
                        exit 1
                fi
		break
	elif [[ "${pilih_menu}" == "9" ]]; then
		if [[ -f "tentang.sh" ]]; then
                        bash "tentang.sh"
                else
                        echo "[-] File 'tentang.sh' tidak ditemukan."
                        exit 1
                fi
		break
	else
		echo "[-] Menu tidak tersedia."
		continue
	fi
done
