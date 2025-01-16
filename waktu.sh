hari=$(date +%A)

if [[ "${hari}" == "Monday" ]]; then
    	hari="Senin"
elif [[ "${hari}" == "Tuesday" ]]; then
    	hari="Selasa"
elif [[ "${hari}" == "Wednesday" ]]; then
	hari="Rabu"
elif [[ "${hari}" == "Thursday" ]]; then
    	hari="Kamis"
elif [[ "${hari}" == "Friday" ]]; then
    	hari="Jumat"
elif [[ "${hari}" == "Saturday" ]]; then
    	hari="Sabtu"
elif [[ "${hari}" == "Sunday" ]]; then
    	hari="Minggu"
fi

tanggal=$(date +%e)

bulan=$(date +%B)

if [[ "${bulan}" == "January" ]]; then
    	bulan="Januari"
elif [[ "${bulan}" == "February" ]]; then
    	bulan="Februari"
elif [[ "${bulan}" == "March" ]]; then
    	bulan="Maret"
elif [[ "${bulan}" == "April" ]]; then
   	bulan="April"
elif [[ "${bulan}" == "May" ]]; then
    	bulan="Mei"
elif [[ "${bulan}" == "June" ]]; then
    	bulan="Juni"
elif [[ "${bulan}" == "July" ]]; then
    	bulan="Juli"
elif [[ "${bulan}" == "August" ]]; then
    	bulan="Agustus"
elif [[ "${bulan}" == "September" ]]; then
    	bulan="September"
elif [[ "${bulan}" == "October" ]]; then
    	bulan="Oktober"
elif [[ "${bulan}" == "November" ]]; then
    	bulan="November"
elif [[ "${bulan}" == "December" ]]; then
    	bulan="Desember"
fi

tahun=$(date +%Y)

jam=$(date +"%H:%M:%S")

echo "${hari}, ${tanggal} ${bulan} ${tahun} - ${jam}"
