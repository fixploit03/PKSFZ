#!/bin/bash
# [pulihkan_kata_sandi_file_zip_fcrackzip.sh]

if [[ $EUID -ne 0 ]]; then
	echo "[-] Program ini harus dijalankan sebagai root."
	exit 1
fi

if [[ ! -f "pemulih_kata_sandi_file_zip.sh" ]]; then
	echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
	exit 1
fi

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

if ! command -v fcrackzip &>/dev/null; then
        echo "[-] 'fcrackzip' belum diinstal."
        echo ""
        read -p "Tekan [Enter] untuk kembali ke menu utama..."
        if [[ -f "pemulih_kata_sandi_file_zip.sh" ]]; then
                bash "pemulih_kata_sandi_file_zip.sh"
        else
                echo "[-] File 'pemulih_kata_sandi_file_zip.sh' tidak ditemukan."
                exit 1
        fi
fi

clear

echo "+---------------------------------------------------------+"
echo "|                                                         |"
echo "|     Menu + Pulihkan Kata Sandi File ZIP (Fcrackzip)     |"
echo "|                                                         |"
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
                              		echo "[+] File ZIP ditemukan."
                                       	break
				elif [[ $(echo "${cek_enkripsi}" | grep -o "AES-128") || $(echo "${cek_enkripsi}" | grep -o "AES-192") ||$(echo "${cek_enkripsi}" | grep -o "AES-256") ]]; then
					echo "[-] File ZIP dengan enkripsi AES tidak didukung."
					continue
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
echo "Daftar Teknik Pemulihan Kata Sandi File ZIP:"
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
					fcrackzip -v -u -D -p "${file_wordlist}" "${file_zip}" | tee "pot.txt"
					waktu_selesai=$(bash "waktu.sh")
					if [[ -f "pot.txt" ]]; then
						if [[ $(grep -i 'password found' "pot.txt") ]]; then
							kata_sandi_file_zip=$(cat "pot.txt" | grep -i 'password found' | awk -F "== " '{print $2}')
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
							echo "[+] Alat: Fcrackzip" >> "hasil/kata_sandi_${base_name}.txt"
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
		fcrackzip -v -u -b -c aA1! -l "${panjang_min}-${panjang_maks}" "${file_zip}" | tee "pot.txt"
		waktu_selesai=$(bash "waktu.sh")
		if [[ -f "pot.txt" ]]; then
				if [[ $(grep -i 'password found' "pot.txt") ]]; then
					kata_sandi_file_zip=$(cat "pot.txt" | grep -i 'password found' | awk -F "== " '{print $2}')
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
					echo "[+] Alat: Fcrackzip" >> "hasil/kata_sandi_${base_name}.txt"
					echo "[+] Teknik: ${teknik}" >> "hasil/kata_sandi_${base_name}.txt"
					echo "[+] Waktu mulai: ${waktu_muulai}" >> "hasil/kata_sandi_${base_name}.txt"
					echo "[+] Waktu akhir: ${waktu_akhir}" >> "hasil/kata_sandi_${base_name}.txt"
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
