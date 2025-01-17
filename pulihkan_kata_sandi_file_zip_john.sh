#!/bin/bash
# [pulihkan_kata_sandi_file_zip_john.sh]

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
	"john"
)

gagal=()

for cek_alat in "${daftar_alat[@]}"; do
	if ! command -v "${cek_alat}" &>/dev/null; then
		gagal+=("${cek_alat}")
	fi
done

if [[ "${#gagal[@]}" -ne 0 ]]; then
	if [[ "${#gagal[@]}" -eq 1 ]]; then
		echo "[-] Menu nomor 6 tidak bisa digunakan, karena ada alat yang belum diinstal."
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
		echo "[-] Menu nomor 6 tidak bisa digunakan, karena ada alat-alat yang belum diinstal."
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

echo "+---------------------------------------------------------------+"
echo "|                                                               |"
echo "|     Menu + Pulihkan Kata Sandi File ZIP (John The Ripper)     |"
echo "|                                                               |"
echo "+---------------------------------------------------------------+"
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

echo ""
echo "Daftar Enkripsi File ZIP:"
echo ""
echo "[1] ZipCrypto (PKZIP) (Compressed)"
echo "[2] ZipCrypto (PKZIP) (Uncompressed)"
echo "[3] ZipCrypto (PKZIP) (Compressed Multi File)"
echo "[4] ZipCrypto (PKZIP) (Uncompressed Multi File)"
echo "[5] ZipCrypto (PKZIP) (Mixed Multi File)"
echo "[6] AES-128 (WinZip) (Compressed)"
echo "[7] AES-128 (WinZip) (Uncompressed)"
echo "[8] AES-128 (WinZip) (Compressed Multi File)"
echo "[9] AES-128 (WinZip) (Uncompressed Multi File)"
echo "[10] AES-128 (WinZip) (Mixed Multi File)"
echo "[11] AES-192 (WinZip) (Compressed)"
echo "[12] AES-192 (WinZip) (Uncompressed)"
echo "[13] AES-192 (WinZip) (Compressed Multi File)"
echo "[14] AES-192 (WinZip) (Uncompressed Multi File)"
echo "[15] AES-192 (WinZip) (Mixed Multi File)"
echo "[16] AES-256 (WinZip) (Compressed)"
echo "[17] AES-256 (WinZip) (Uncompressed)"
echo "[18] AES-256 (WinZip) (Compressed Multi File)"
echo "[19] AES-256 (WinZip) (Uncompressed Multi File)"
echo "[20] AES-256 (WinZip) (Mixed Multi File)"
echo ""

while true; do
	read -p "[#] Pilih enkripsi yang digunakan oleh file ZIP: " enkripsi_yang_digunakan_file_zip
	if [[ "${enkripsi_yang_digunakan_file_zip}" == "1" || "${enkripsi_yang_digunakan_file_zip}" == "2" || "${enkripsi_yang_digunakan_file_zip}" == "3" || "${enkripsi_yang_digunakan_file_zip}" == "4" || "${enkripsi_yang_digunakan_file_zip}" == "5" ]]; then
		format="PKZIP"
		break
	elif [[ "${enkripsi_yang_digunakan_file_zip}" == "6" || "${enkripsi_yang_digunakan_file_zip}" == "7" || "${enkripsi_yang_digunakan_file_zip}" == "8" || "${enkripsi_yang_digunakan_file_zip}" == "9" || "${enkripsi_yang_digunakan_file_zip}" == "10" || "${enkripsi_yang_digunakan_file_zip}" == "11" || "${enkripsi_yang_digunakan_file_zip}" == "12" || "${enkripsi_yang_digunakan_file_zip}" == "13" || "${enkripsi_yang_digunakan_file_zip}" == "14" || "${enkripsi_yang_digunakan_file_zip}" == "15" || "${enkripsi_yang_digunakan_file_zip}" == "16" || "${enkripsi_yang_digunakan_file_zip}" == "17" || "${enkripsi_yang_digunakan_file_zip}" == "18" || "${enkripsi_yang_digunakan_file_zip}" == "19" || "${enkripsi_yang_digunakan_file_zip}" == "20" ]]; then
		format="ZIP"
		break
	else
		echo "[-] Enkripsi file ZIP tidak tersedia."
		continue
	fi
done

while true; do
	read -p "[#] Masukkan nama file Hash File ZIP: " file_hash
	if [[ -z "${file_hash}" ]]; then
		echo "[-] Nama file Hash file ZIP tidak boleh kosong."
		continue
	else
		if [[ -f "${file_hash}" ]]; then
			echo "[+] File Hash file ZIP ditemukan."
			break
		else
			echo "[-] File Hash file ZIP tidak ditemukan."
			continue
		fi
	fi
done

echo ""
echo "Daftar Teknik Pemulihan Kata Sandi File ZIP: "
echo ""
echo "[1] Dictionary Attack"
echo "[2] Brute Force Attack"
echo ""

while true; do
	read -p "[#] Pilih teknik pemulihan kata sandi file ZIP: " pilih_teknik
	if [[ "${pilih_teknik}" == "1" ]]; then
		teknik="Dictionary Attack"
		while true; do
			read -p "[#] Masukkan nama file Wordlist: " file_wordlist
			file_wordlist=$(echo "${file_wordlist}" | sed -e "s/^[ \t]*//" -e "s/[ \t]*$//" -e "s/^['\"]//" -e "s/['\"]$//")
			if [[ -z "${file_wordlist}" ]]; then
				echo "[-] Nama file Wordlist tidak boleh kosong."
				continue
			else
				if [[ -f "${file_wordlist}" ]]; then
					echo "[+] File Wordlist ditemukan."
      					echo ""
                                        read -p "Tekan [Enter] untuk memulai proses pemulihan kata sandi file ZIP..."
                                        echo ""
					echo "[*] Memulihkan kata sandi file ZIP..."
					echo ""
					if [[ ! -f "waktu.sh" ]]; then
						echo "[-] File 'waktu.sh' tidak ditemukan."
						exit 1
					fi
					waktu_mulai=$(bash "waktu.sh")
					john --wordlist="${file_wordlist}" --pot="pot.txt" --format="${format}" "${file_hash}"
					john --show "${file_hash}" --format="${format}" --pot="pot.txt"
					waktu_selesai=$(bash "waktu.sh")
					if [[ -f "pot.txt" ]]; then
						if [[ $(cat "pot.txt" | grep -o ':') ]]; then
							kata_sandi_file_zip=$(cat "pot.txt" | cut -d ":" -f 2)
							echo ""
							echo "[+] Kata sandi File ZIP berhasil dipulihkan."
							echo "[+] Kata sandi: ${kata_sandi_file_zip}"
							if [[ ! -d "hasil" ]]; then
								mkdir "hasil"
							fi
							base_name=$(basename "${file_zip}")
							if [[ ! -f "hasil/kata_sandi_${base_name}.txt" ]]; then
					                	touch "hasil/kata_sandi_${base_name}.txt"
					                fi
							echo "=====================================" > "hasil/kata_sandi_${base_name}.txt"
							echo "" >> "hasil/kata_sandi_${base_name}.txt"
					                echo "[+] File ZIP: ${file_zip}" >> "hasil/kata_sandi_${base_name}.txt"
					                echo "[+] Kata sandi: ${kata_sandi_file_zip}" >> "hasil/kata_sandi_${base_name}.txt"
							echo "" >> "hasil/kata_sandi_${base_name}.txt"
							echo "[+] Alat: John The Ripper" >> "hasil/kata_sandi_${base_name}.txt"
							echo "[+] Teknik: ${teknik}" >> "hasil/kata_sandi_${base_name}.txt"
							echo "[+] Waktu mulai: ${waktu_mulai}" >> "hasil/kata_sandi_${base_name}.txt"
							echo "[+] Waktu selesai: ${waktu_selesai}" >> "hasil/kata_sandi_${base_name}.txt"
							echo "" >> "hasil/kata_sandi_${base_name}.txt"
							echo "[https://github.com/fixploit03/PKSFZ]" >> "hasil/kata_sandi_${base_name}.txt"
							echo "=====================================" >> "hasil/kata_sandi_${base_name}.txt"
							real_path=$(realpath "hasil/kata_sandi_${base_name}.txt")
					                echo "[+] Kata sandi file ZIP disimpan di: ${real_path}"
							rm "pot.txt"
						else
							echo ""
							echo "[-] Kata sandi file ZIP gagal dipulihkan."
							rm "pot.txt"
						fi
					else
						echo ""
						echo "[-] Kata sandi file ZIP gagal dipulihkan."
						if [[ -f "pot.txt" ]]; then
							rm "pot.txt"
						fi
					fi
					echo ""
			       		read -p "Tekan [Enter] untuk kembali ke menu utama..."
			        	if [[ -f "pemulih_kata_sandi_file_zip.sh" ]]; then
				                bash "pemulih_kata_sandi_file_zip.sh"
			       		else
			               		echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
			                	exit 1
			        	fi
					break
				else
					echo "[-] File Wordlist tidak ditemukan."
					continue
				fi
			fi
		done
		break
	elif [[ "${pilih_teknik}" == "2" ]]; then
		teknik="Brute Force Attack"
		while true; do
			read -p "[#] Masukkan panjang minimal kata sandi: " panjang_min
			if [[ -z "${panjang_min}" ]]; then
				echo "[-] Panjang minimal kata sandi tidak boleh kosong."
				continue
			fi
			if [[ "${panjang_min}" =~ ^0 ]]; then
				echo "[-] Panjang minimal kata sandi tidak boleh diawali dengan angka nol."
				continue
			fi
			if [[ ! "${panjang_min}" =~ ^[0-9]+$ ]]; then
				echo "[-] Panjang minimal kata sandi harus berupa angka."
				continue
			fi
			break
		done
		while true; do
			read -p "[#] Masukkan panjang maksimal kata sandi: " panjang_maks
			if [[ -z "${panjang_maks}" ]]; then
				echo "[-] Panjang maksimal kata sandi tidak boleh kosong."
				continue
			fi
			if [[ ! "${panjang_maks}" =~ ^[0-9]+$ ]]; then
				echo "[-] Panjang maksimal kata sandi harus berupa angka."
				continue
			fi
			if [[ ! "${panjang_maks}" -ge "${panjang_min}" ]]; then
				echo "[-] Panjang maksimal kata sandi harus lebih besar atau sama dengan panjang minimal kata sandi."
				continue
			fi
			break
		done
		echo ""
                read -p "Tekan [Enter] untuk memulai proses pemulihan kata sandi file ZIP..."
                echo ""
		echo "[*] Memulihkan kata sandi file ZIP..."
		echo ""
		if [[ ! -f "waktu.sh" ]]; then
			echo "[-] File 'waktu.sh' tidak ditemukan."
			exit 1
		fi
		waktu_mulai=$(bash "waktu.sh")
		john --incremental --min-length="${panjang_min}" --max-length="${panjang_maks}" --pot="pot.txt" --format="${format}" "${file_hash}"
		john --show "${file_hash}" --format="${format}" --pot="pot.txt"
		waktu_selesai=$(bash "waktu.sh")
		if [[ -f "pot.txt" ]]; then
			if [[ $(cat "pot.txt" | grep -o ':') ]]; then
				kata_sandi_file_zip=$(cat "pot.txt" | cut -d ':' -f 2)
				echo ""
				echo "[+] Kata sandi file ZIP berhasil dipulihkan."
				echo "[+] Kata sandi: ${kata_sandi_file_zip}"
				if [[ ! -d "hasil" ]]; then
					mkdir "hasil"
				fi
				base_name=$(basename "${file_zip}")
				if [[ ! -f "hasil/kata_sandi_${base_name}.txt" ]]; then
                                	touch "hasil/kata_sandi_${base_name}.txt"
                                fi
				echo "=====================================" > "hasil/kata_sandi_${base_name}.txt"
				echo "" >> "hasil/kata_sandi_${base_name}.txt"
                                echo "[+] File ZIP: ${file_zip}" >> "hasil/kata_sandi_${base_name}.txt"
                                echo "[+] Kata sandi: ${kata_sandi_file_zip}" >> "hasil/kata_sandi_${base_name}.txt"
				echo "" >> "hasil/kata_sandi_${base_name}.txt"
				echo "[+] Alat: John The Ripper" >> "hasil/kata_sandi_${base_name}.txt"
				echo "[+] Teknik: ${teknik}" >> "hasil/kata_sandi_${base_name}.txt"
				echo "[+] Waktu mulai: ${waktu_mulai}" >> "hasil/kata_sandi_${base_name}.txt"
				echo "[+] Waktu selesai: ${waktu_selesai}" >> "hasil/kata_sandi_${base_name}.txt"
				echo "" >> "hasil/kata_sandi_${base_name}.txt"
				echo "[https://github.com/fixploit03/PKSFZ]" >> "hasil/kata_sandi_${base_name}.txt"
				echo "=====================================" >> "hasil/kata_sandi_${base_name}.txt"
				real_path=$(realpath "hasil/kata_sandi_${base_name}.txt")
                                echo "[+] Kata sandi file ZIP disimpan di: ${real_path}"
                                rm "pot.txt"
			else
				echo ""
				echo "[-] Kata sandi file ZIP gagal dipulihkan."
				rm "pot.txt"
			fi
		else
			echo ""
			echo "[-] Kata sandi file ZIP gagal dipulihkan."
			if [[ -f "pot.txt" ]]; then
				rm "pot.txt"
			fi
		fi
		echo ""
       		read -p "Tekan [Enter] untuk kembali ke menu utama..."
        	if [[ -f "pemulih_kata_sandi_file_zip.sh" ]]; then
	                bash "pemulih_kata_sandi_file_zip.sh"
       		else
               		echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
                	exit 1
        	fi
		break
	else
		echo "[-] Teknik pemulihan kata sandi file ZIP tidak tersedia."
		continue
	fi
done
