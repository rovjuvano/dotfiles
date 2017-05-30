function ffmpeg-mp4-to-m4a {
  ffmpeg -i "$1" -vn -c:a copy "${1/.mp4}.m4a"
}
function ffmpeg-youtube {
  local VIDEO_ARGS=(
    -codec:v libx264
    -crf 21
    -bf 2
    -flags +cgop
    -pix_fmt yuv420p
  )
  local AUDIO_ARGS=(
    -codec:a aac
    -strict -2
    -b:a 384k
    -r:a 48000
  )
  local OTHER_ARGS=(
    -movflags faststart
  )
  while [[ $# -gt 1 ]]; do
    case "$1" in
    --speed)
      OTHER_ARGS+=(
        -filter_complex
        $(awk 'BEGIN{printf "[0:v]setpts=%0.9f*PTS[v];[0:a]atempo=%0.9f[a]", 1/ARGV[1], ARGV[1]}' "$2")
        -map '[v]' -map '[a]'
      )
      shift ;;
    -o|--output) OUTPUT_ARG=$2; shift;;
    *) OTHER_ARGS+=("$1");;
    esac
    shift
  done
  local INPUT=$1
  local OUTPUT="${OUTPUT_ARG:-${INPUT%.*}.mp4}"
  echo -i "${INPUT}" "${VIDEO_ARGS[@]}" "${AUDIO_ARGS[@]}" "${OTHER_ARGS[@]}" "${OUTPUT}"
  ffmpeg -i "${INPUT}" "${VIDEO_ARGS[@]}" "${AUDIO_ARGS[@]}" "${OTHER_ARGS[@]}" "${OUTPUT}"
}
