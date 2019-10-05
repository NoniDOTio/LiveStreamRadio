. ./config.sh

tee_muxer_output=""
i=0

for platform in "${PLATFORMS[@]}"
do
    if (( $i > 0 )); then
        tee_muxer_output+="|"
    fi
    tee_muxer_output+="[f=fifo:fifo_format=flv:queue_size=120:drop_pkts_on_overflow=1:attempt_recovery=1:recovery_wait_time=10:max_recovery_attempts=0:restart_with_keyframe=1]${platform}"
    i=$((i+1))
done

while true :
do
	ffmpeg -threads "${THREAD_COUNT}" -loglevel warning \
		-fflags "+autobsf+genpts+discardcorrupt" -avoid_negative_ts "make_zero" -copytb 1 \
		-re -stream_loop -1 -i "${BACKGROUND}" \
		-f alsa -ac 2 -thread_queue_size 1024 -i hw:Loopback,1,0 -c:v copy -c:a aac -filter:a "volume=${VOLUME}" -map 0:v -map 1:a \
		-f tee "${tee_muxer_output}"
	 echo "[ERROR] `date '+%Y-%m-%d %H:%M:%S'` Stream crashed. Restarting..." >> ${SCRIPT_DIR}/event.log
done