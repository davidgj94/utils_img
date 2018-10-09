input=$1
rate=$2
output=$3
format=$4
ffmpeg -i "${input}" -r "${rate}" "${output}"/img_%04d."${format}"
