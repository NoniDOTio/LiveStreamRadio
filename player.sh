. ./config.sh

while true; do
	# Shuffle playlist
	shuf ${SCRIPT_DIR}/playlist.txt --output=${SCRIPT_DIR}/playlist.txt
	while read f; do
		# Clean up file name
		removed_ext=$(echo "${f}" | sed -e 's/.*\///' -e 's/\.mp3//')

		# Execute custom function
		custom_func "${f}" "${removed_ext}"

		# Play current song in mpg123
		mpg123 "${f}"
	done < playlist.txt
done