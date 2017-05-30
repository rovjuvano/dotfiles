function time-to-seconds {
  awk -F: '{ printf "%.6f", ($1*60+$2)*60+$3 }'
}
function time-to-frames {
  time-to-seconds | seconds-to-frames "${1:?"usage: ${FUNCNAME} fps-time"}"
}
function seconds-to-frames {
  awk -F: '{ fps='"${1:?"usage: ${FUNCNAME} fps-time"}"'; print int($1*fps+.5) }'
}
function time-to-timecode {
  time-to-frames "${1:?"usage: ${FUNCNAME} fps-time [fps-timecode]"}" | frames-to-timecode "${2:-$1}"
}
function seconds-to-timecode {
  seconds-to-frames "${1:?"usage: ${FUNCNAME} fps-time [fps-timecode]"}" | frames-to-timecode "${2:-$1}"
}
function frames-to-timecode {
  awk -F: '{
    fps='"${1:?"usage: ${FUNCNAME} fps-timecode"}"'
    nframes=$1
    h=(nframes/(3600*fps))
    m=(nframes/(60*fps))%60
    s=(nframes/fps)%60
    f=nframes%fps
    printf "%02i:%02i:%02i:%02i\n", h, m, s, f
  }'
}
function timecode-to-frames {
  awk -F: '{ fps='"${1:?"usage: ${FUNCNAME} fps-timecode"}"'; print (($1*60+$2)*60+$3)*fps+$4 }'
}
function timecode-to-seconds {
  timecode-to-frames "${1:?"usage: ${FUNCNAME} fps-timecode [fps-time]"}" | frames-to-seconds "${2:-$1}"
}
function frames-to-seconds {
  awk -F: '{ fps='"${1:?"usage: ${FUNCNAME} fps-time"}"'; printf "%.6f", $1/fps }'
}
function timecode-to-time {
  timecode-to-seconds "${1:?"usage: ${FUNCNAME} fps-timecode [fps-time]"}" "$2" | seconds-to-time
}
function frames-to-time {
  frames-to-seconds "${1:?"usage: ${FUNCNAME} fps-time"}" | seconds-to-time
}
function seconds-to-time {
  awk -F: '{
    seconds=$1
    h=seconds/3600
    m=(seconds/60)%60
    s=seconds%60
    printf "%02i:%02i:%09.6f\n", h, m, s
  }'
}

function drop-frame-timecode-to-timecode {
  drop-frame-timecode-to-frames | frames-to-timecode "${1:-30}"
}
function drop-frame-timecode-to-frames {
  sed -re 's/([1-9]):00:0[01]$/\1:00:02/' | awk -F: '{
    fps='"${1:-30}"'
    print (($1*60+$2)*60+$3)*fps+$4-(108*$1+2*($2-int($2/10)))
  }'
}
function frames-to-drop-frame-timecode {
  awk '{
    fps='"${1:-30}"'
    fpm=60*fps-2
    fpd=10*fpm+2
    dfd=int($1/fpd)
    dfm=int(($1%fpd-2)/fpm)
    print $1+18*dfd+2*dfm
  }' | frames-to-timecode "${1:-30}"
}
function _edl-to-from-drop-frame {
  local DF="$1"
  local TEXT="$2"
  sed -re 's/[[:space:]]+$//;s/ ([0-9][0-9]:[0-9][0-9]:[0-9][0-9]:[0-9][0-9])/\t\1/g' |
  awk -F$'\t' -v "df=${DF}" -v "fcm_text=${TEXT}" '
    function to_frames(h,m,s,f) {
      return ((h*60+m)*60+s)*30+f+df*(108*h+2*(m-int(m/10)))
    }
    function to_timecode(nframes) {
      fps=30
      h=(nframes/(3600*fps))
      m=(nframes/(60*fps))%60
      s=(nframes/fps)%60
      f=nframes%fps
      return sprintf("%02i:%02i:%02i:%02i", h, m, s, f)
    }
    function t(x) {
      split(x,a,":");
      return to_timecode(to_frames(a[1], a[2], a[3], a[4]))
    }
    /^FCM: /{ $0 = "FCM: " fcm_text " FRAME" }
    /^[0-9]/{
      $2=t($2)
      $3=t($3)
      $4=t($4)
      $5=t($5)
    }
    {print $0}
  '
}
function drop-frame-edl-to-edl {
  _edl-to-from-drop-frame -1 'NON-DROP'
}
function edl-to-drop-frame-edl {
  _edl-to-from-drop-frame 1 'DROP'
}
function edl-from-scratch {
  local FPS_TIME="${1:?"usage: ${FUNCNAME} fps-time [fps-timecode]"}"
  local FPS_TIMECODE="${2:-$1}"
  nl -ba -nrz -w3 -s'¦' | while IFS='¦' read LN ST ET D; do
    [[ -z "${D}" ]] && continue
    SF=$(time-to-frames "${FPS_TIME}" <<<"${ST}")
    EF=$(time-to-frames "${FPS_TIME}" <<<"${ET}")
    ((EF+="${FPS_TIMECODE}"-1))
    STC=$(frames-to-timecode "${FPS_TIMECODE}"<<<"${SF}")
    ETC=$(frames-to-timecode "${FPS_TIMECODE}"<<<"${EF}")
    DF=$(( ${EF} - ${SF} ))
    printf "%s  001  V  C  %s %s %s %s\n%s|D:%s\n" "${LN}" "${STC}" "${ETC}" "${STC}" "${ETC}" "${D}" "${DF}"
  done
}
