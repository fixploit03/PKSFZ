#!/bin/bash
# [ekstrak_file_zip.sh]

if [[ $EUID -ne 0 ]]; then
	echo "[-] Program ini harus dijalankan sebagai root."
	exit 1
fi

if [[ ! -f "pemulih_kata_sandi_file_zip.sh" ]]; then
	echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
	exit 1
fi

clear

if ! command -v zipinfo &>/dev/null; then
	echo "[-] 'zipinfo' belum diinstal."
	echo ""
	read -p "Tekan [Enter] untuk kembali ke menu utama..."
	if [[ -f "pemulih_kata_sandi_file_zip.sh" ]]; then
		bash "pemulih_kata_sandi_file_zip.sh"
	else
		echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
		exit 1
	fi
fi

if ! command -v 7z &>/dev/null; then
	echo "[-] '7z' belum diinstal."
	echo ""
	read -p "Tekan [Enter] untuk kembali ke menu utama..."
	if [[ -f "pemulih_kata_sandi_file_zip.sh" ]]; then
		bash "pemulih_kata_sandi_file_zip.sh"
	else
		echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
		exit 1
	fi
fi

if ! command -v unzip &>/dev/null; then
	echo "[-] 'unzip' belum diinstal."
	echo ""
	read -p "Tekan [Enter] untuk kembali ke menu utama..."
	if [[ -f "pemulih_kata_sandi_file_zip.sh" ]]; then
		bash "pemulih_kata_sandi_file_zip.sh"
	else
		echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
		exit 1
	fi
fi

echo "+---------------------------------+"
echo "|                                 |"
echo "|     Menu + Ekstrak File ZIP     |"
echo "|                                 |"
echo "+---------------------------------+"
echo ""

while true; do
	read -p "[#] Masukkan nama file ZIP: " file_zip
	file_zip=$(echo "${file_zip}" | sed -e "s/^[ \t]*//" -e "s/[ \t]*$//" -e "s/^['\"]//" -e "s/['\"]$//")
	if [[ -z "${file_zip}" ]]; then
		echo "[-] Nama file ZIP tidak boleh kosong."
		continue
	else
		if [[ ! -f "${file_zip}" ]]; then
			echo "[-] File ZIP tidak ditemukan."
			continue
		else
			zipinfo "${file_zip}" &>/dev/null
			if [[ $? -eq 0 ]]; then
				cek_enkripsi=$(7z l -slt "${file_zip}" | grep -i 'method' | awk '{print $3}')

				if [[ $? -ne 0 ]]; then
					echo "[-] Terjadi kesalahan yang tidak terduga."
					echo ""
					read -p "Tekan [Enter] untuk kembali ke menu utama..."
					if [[ -f "pemulih_kata_sandi_file_zip.sh" ]]; then
						bash "pemulih_kata_sandi_file_zip.sh"
					else
						echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
						exit 1
					fi
				fi

				if [[ $(echo "${cek_enkripsi}" | grep -o "ZipCrypto") || $(echo "${cek_enkripsi}" | grep -o "AES-128") || $(echo "${cek_enkripsi}" | grep -o "AES-192") ||$(echo "${cek_enkripsi}" | grep -o "AES-256") ]]; then
					echo "[+] File ZIP ditemukan."
					break
				else
					echo "[-] File ZIP tidak terenkripsi."
					continue
				fi
			else
				echo "[-] File ZIP tidak valid atau rusak."
				continue
			fi
		fi
	fi
done

while true; do
	read -p "[#] Masukkan kata sandi file ZIP: " kata_sandi
	if [[ -z "${kata_sandi}" ]]; then
		echo "[-] Kata sandi file ZIP tidak boleh kosong."
		continue
	else
		break
	fi
done

while true; do
	read -p "[#] Masukkan nama folder untuk menyimpan file ZIP yang berhasil diekstrak: " folder
	if [[ -z "${folder}" ]]; then
 		echo "[-] Nama folder tidak boleh kosong."
		continue
	else
		if [[ -d "${folder}" ]]; then
			break
		else
			echo "[-] Folder tidak ditemukan."
			continue
		fi
	fi
done
echo ""
echo "[*] Mengekstrak file ZIP..."
echo ""
if [[ $(echo "${cek_enkripsi}" | grep -o "ZipCrypto") ]]; then
	enkripsi="ZipCrypto"
	unzip -P "${kata_sandi}" "${file_zip}" -d "${folder}"
	if [[ $? -eq 0 ]]; then
		echo ""
		echo "[+] File ZIP berhasil diekstrak."
		real_path=$(realpath "${folder}")
		echo "[+] Disimpan di: ${real_path}"
		echo ""
		read -p "Tekan [Enter] untuk kembali ke menu utama..."
		if [[ -f "pemulih_kata_sandi_file_zip.sh" ]]; then
			bash "pemulih_kata_sandi_file_zip.sh"
		else
			echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
			exit 1
		fi
	else
		echo ""
		echo "[-] File ZIP gagal diekstrak."
		echo ""
		read -p "Tekan [Enter] untuk kembali ke menu utama..."
		if [[ -f "pemulih_kata_sandi_file_zip.sh" ]]; then
			bash "pemulih_kata_sandi_file_zip.sh"
		else
			echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
			exit 1
		fi
	fi
elif [[ $(echo "${cek_enkripsi}" | grep -o "AES-128") || $(echo "${cek_enkripsi}" | grep -o "AES-192") ||$(echo "${cek_enkripsi}" | grep -o "AES-256") ]]; then
	enkripsi="AES"
	7z x "${file_zip}" -p"${kata_sandi}" -o"${folder}"
	if [[ $? -eq 0 ]]; then
		echo ""
		echo "[+] File ZIP berhasil diekstrak."
		real_path=$(realpath "${folder}")
		echo "[+] Disimpan di: ${real_path}"
		echo ""
		read -p "Tekan [Enter] untuk kembali ke menu utama..."
		if [[ -f "pemulih_kata_sandi_file_zip.sh" ]]; then
			bash "pemulih_kata_sandi_file_zip.sh"
		else
			echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
			exit 1
		fi

	else
		echo ""
		echo "[-] File ZIP gagal diekstrak."
		echo ""
		read -p "Tekan [Enter] untuk kembali ke menu utama..."
		if [[ -f "pemulih_kata_sandi_file_zip.sh" ]]; then
			bash "pemulih_kata_sandi_file_zip.sh"
		else
			echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
			exit 1
		fi
	fi
fi
