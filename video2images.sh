canard_dir="${HOME}"/export/data_gpm/canard/T1
videos_folder="${canard_dir}"/Video_Murcia_julio_2018
plataforma_folder="${videos_folder}"/Plataforma
runaway_folder="${videos_folder}"/Runaway
rodadura_folder="${videos_folder}"/Rodadura
input="${runaway_folder}"/
output="${HOME}"/projects/canard/images_runaway/image_
ffmpeg -i "${input}" -r 0.25 "${output}_"%04d.png