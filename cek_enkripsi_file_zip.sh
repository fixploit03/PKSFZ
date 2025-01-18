#!/bin/bash
# [cek_enkripsi_file_zip.sh]

if [[ $EUID -ne 0 ]]; then
	echo "[-] Program ini harus dijalankan sebagai root."
	exit 1
fi

if [[ ! -f "pemulih_kata_sandi_file_zip.sh" ]]; then
	echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
	exit 1
fi

daftar_alat=(
	"zipinfo"
	"7z"
)

gagal=()

for cek_alat in "${daftar_alat[@]}"; do
	if ! command -v "${cek_alat}" &>/dev/null; then
		gagal+=("${cek_alat}")
	fi
done

if [[ "${#gagal[@]}" -ne 0 ]]; then
	if [[ "${#gagal[@]}" -eq 1 ]]; then
		echo "[-] Menu nomor 2 tidak bisa digunakan, karena ada alat yang belum diinstal."
		echo ""
		echo "Alat yang belum diinstal:"
		echo ""
		echo "- ${gagal[0]}"
		echo ""
		read -p "Tekan [Enter] untuk kembali kemenu utama..."
		if [[ -f "pemulih_kata_sandi_file_zip.sh" ]]; then
	        	bash "pemulih_kata_sandi_file_zip.sh"
	        else
	                echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
	                exit 1
	        fi
	else
		echo "[-] Menu nomor 2 tidak bisa digunakan, karena ada alat-alat yang belum diinstal."
		echo ""
		echo "Alat-alat yang belum diinstal:"
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
	fi
fi

clear

echo "+--------------------------------------+"
echo "|                                      |"
echo "|     Menu + Cek Enkripsi File ZIP     |"
echo "|                                      |"
echo "+--------------------------------------+"
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
				echo "[+] File ZIP ditemukan."
				break
			else
				echo "[-] File ZIP tidak valid atau rusak."
				continue
			fi
		fi
	fi
done

echo "[*] Mengecek enkripsi file ZIP..."

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

if [[ $(echo "${cek_enkripsi}" | grep -o "ZipCrypto") ]]; then
	enkripsi="ZipCrypto"
elif [[ $(echo "${cek_enkripsi}" | grep -o "AES-128") ]]; then
	enkripsi="AES-128"
elif [[ $(echo "${cek_enkripsi}" | grep -o "AES-192") ]]; then
	enkripsi="AES-192"
elif [[ $(echo "${cek_enkripsi}" | grep -o "AES-256") ]]; then
	enkripsi="AES-256"
else
	echo "[-] File ZIP '${file_zip}' tidak terenkripsi."
	echo ""
	read -p "Tekan [Enter] untuk kembali ke menu utama..."
	if [[ -f "pemulih_kata_sandi_file_zip.sh" ]]; then
		bash "pemulih_kata_sandi_file_zip.sh"
	else
		echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
		exit 1
	fi
fi

jumlah_file=$(zipinfo "${file_zip}" | awk 'NR == 2 {print $9}')

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

lebih_dari_satu=false

if [[ "${jumlah_file}" != "1" ]]; then
	status="Multi-File"
	lebih_dari_satu=true
fi

cek_metode=($(7z l -slt "${file_zip}" | grep -i 'method' | awk '{print $4}'))

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

metode_deflate=false
metode_store=false

for m in "${cek_metode[@]}"; do
	if [[ "${m}" == "Deflate" || "${m}" == "Deflate:Maximum" ]]; then
		metode_deflate=true
	elif [[ "${m}" == "Store" ]]; then
		metode_store=true
	fi
done

if [[ "${metode_deflate}" == true && "${metode_store}" == true ]]; then
	metode="Mixed"
elif [[ "${metode_deflate}" == true ]]; then
    	metode="Compressed"
elif [[ "${metode_store}" == true ]]; then
    	metode="Uncompressed"
fi

if [[ "${enkripsi}" == "ZipCrypto" ]]; then
	if [[ "${lebih_dari_satu}" == true ]]; then
		echo "[+] Enkripsi file ZIP: ${enkripsi} (PKZIP) (${metode} ${status})"
		echo ""
		read -p "Tekan [Enter] untuk kembali ke menu utama..."
		if [[ -f "pemulih_kata_sandi_file_zip.sh" ]]; then
			bash "pemulih_kata_sandi_file_zip.sh"
		else
			echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
			exit 1
		fi
	else
		echo "[+] Enkripsi file ZIP: ${enkripsi} (PKZIP) (${metode})"
		echo ""
		read -p "Tekan [Enter] untuk kembali ke menu utama..."
		if [[ -f "pemulih_kata_sandi_file_zip.sh" ]]; then
			bash "pemulih_kata_sandi_file_zip.sh"
		else
			echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
			exit 1
		fi
	fi
else
	if [[ "${lebih_dari_satu}" == true ]]; then
		echo "[+] Enkripsi file ZIP: ${enkripsi} (WinZIP) (${metode} ${status})"
		echo ""
		read -p "Tekan [Enter] untuk kembali ke menu utama..."
		if [[ -f "pemulih_kata_sandi_file_zip.sh" ]]; then
			bash "pemulih_kata_sandi_file_zip.sh"
		else
			echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
			exit 1
		fi
	else
		echo "[+] Enkripsi file ZIP: ${enkripsi} (WinZIP) (${metode})"
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



