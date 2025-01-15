#!/bin/bash
# [ekstrak_hash_file_zip_john.sh]

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

if ! command -v zip2john &>/dev/null; then
	echo "[-] 'zip2john' belum diinstal."
	echo ""
	read -p "Tekan [Enter] untuk kembali ke menu utama..."
	if [[ -f "pemulih_kata_sandi_file_zip.sh" ]]; then
		bash "pemulih_kata_sandi_file_zip.sh"
	else
		echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
		exit 1
	fi
fi

echo "+--------------------------------------------------------+"
echo "|                                                        |"
echo "|     Menu + Ekstrak Hash File ZIP (John The Ripper)     |"
echo "|                                                        |"
echo "+---------------------------------------------------------+"
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
                                cek_enkripsi_file_zip=$(7z l -slt "${file_zip}" | grep -i 'method' | awk '{print $3}')
                                if [[ $(echo "${cek_enkripsi_file_zip}" | grep -o 'ZipCrypto') ]]; then
                                        enkripsi="ZipCrypto"
                                elif [[ $(echo "${cek_enkripsi_file_zip}" | grep -o 'AES-128' || echo "${cek_enkripsi_file_zip}" | grep -o 'AES-192' || echo "${cek_enkripsi_file_zip}" | grep -o 'AES-256') ]]; then
                                        enkripsi="AES"
                                else
                                        echo "[-] File ZIP tidak dienkripsi."
                                        continue
                                fi
                                break
			else
				echo "[-] File ZIP tidak valid atau rusak."
				continue
			fi
		fi
	fi
done

echo ""
echo "Daftar Teknik Ekstrak Hash File ZIP:"
echo ""
echo "[1] Ekstrak Hash File ZIP Dari Salah Satu Isi File ZIP"
echo "[2] Ekstrak Hash File ZIP (Default)"
echo ""

while true; do
	read -p "[#] Pilih teknik ekstrak Hash file ZIP: " pilih_teknik_ekstrak_hash
	if [[ "${pilih_teknik_ekstrak_hash}" == "1" ]]; then
		echo "[*] Mengecek isi file ZIP..."
		echo "[+] Isi file ZIP:"
		echo ""
		lihat_isi_file_zip=$(unzip -l "${file_zip}")
		echo "${lihat_isi_file_zip}"
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
		echo ""
		while true; do
			read -p "[#] Masukkan salah satu nama file dari salah satu isi file ZIP: " file_isi_file_zip
			if [[ -z "${file_isi_file_zip}" ]]; then
				echo "[-] Nama file tidak boleh kosong."
				continue
			else
				if [[ $(echo "${lihat_isi_file_zip}" | grep -o "${file_isi_file_zip}") ]]; then
					if [[ ! -d "file_hash" ]]; then
						echo "[*] Membuat folder untuk menyimpan file Hash."
						mkdir "file_hash"
						if [[ $? -eq 0 ]]; then
							echo "[+] Berhasil membuat folder untuk menyimpan file Hash."
						else
							echo "[-] Gagal membuat folder untuk menyimpan file Hash."
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
					base_name=$(basename "${file_zip}")
					nama_file_hash_salah_satu_isi_file="${base_name}_hash.txt"
					echo "[*] Mengekstrak Hash file ZIP..."
					ekstrak_hash_file_zip_salah_satu_file=$(zip2john -o "${file_isi_file_zip}" "${file_zip}" 2>&1 > "file_hash/john_${nama_file_hash_salah_satu_isi_file}")
					if [[ $? -eq 0 ]]; then
						echo "[+] Hash file ZIP berhasil diekstrak."
						real_path=$(realpath "file_hash/john_${nama_file_hash_salah_satu_isi_file}")
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
						echo "[-] Hash file ZIP gagal diekstrak."
						echo ""
						read -p "Tekan [Enter] untuk kembali ke menu utama..."
						if [[ -f "pemulih_kata_sandi_file_zip.sh" ]]; then
							bash "pemulih_kata_sandi_file_zip.sh"
						else
							echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
							exit 1
						fi
					fi
					break
				else
					echo "[-] File tidak ditemukan dalam file ZIP."
					continue
				fi
			fi
		done
		break
	elif [[ "${pilih_teknik_ekstrak_hash}" == "2" ]]; then
		if [[ ! -d "file_hash" ]]; then
			echo "[*] Membuat folder untuk menyimpan file Hash."
			mkdir "file_hash"
			if [[ $? -eq 0 ]]; then
				echo "[+] Berhasil membuat folder untuk menyimpan file Hash."
			else
				echo "[-] Gagal membuat folder untuk menyimpan file Hash."
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
		base_name=$(basename "${file_zip}")
		nama_file_hash_default="${base_name}_hash.txt"
		echo "[*] Mengekstrak Hash file ZIP..."
		ekstrak_hash_file_zip_default=$(zip2john "${file_zip}" 2>&1 > "file_hash/john_${nama_file_hash_default}")
		if [[ $? -eq 0 ]]; then
			echo "[+] Hash file ZIP berhasil diekstrak."
			real_path=$(realpath "file_hash/john_${nama_file_hash_default}")
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
			echo "[-] Hash file ZIP gagal diekstrak."
			echo ""
			read -p "Tekan [Enter] untuk kembali ke menu utama..."
			if [[ -f "pemulih_kata_sandi_file_zip.sh" ]]; then
				bash "pemulih_kata_sandi_file_zip.sh"
			else
				echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
				exit 1
			fi
		fi
		break
	else
		echo "[-] Teknik ekstrak Hash file ZIP tidak tersedia."
		continue
	fi
done
