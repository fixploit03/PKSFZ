#!/bin/bash
# [keluar.sh]

if [[ $EUID -ne 0 ]]; then
	echo "[-] Program ini harus dijalankan sebagai root."
	exit 1
fi

if [[ ! -f "pemulih_kata_sandi_file_zip.sh" ]]; then
	echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
	exit 1
fi

echo "[*] Terimakasi telah menggunakan program kami ^_^"
exit 0