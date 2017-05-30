if [[ -e "${HOME}/7/archived/" ]]; then
  export SCRATCH="${HOME}/7/repos/scratch/*/*.txt
  $((
      \cd ~/7/repos/scratch && \ls -1d 20[1-9]*;
      \cd ~/7/archived && \ls -1d 20[1-9]*
    ) | sort | uniq -u | \
    sed -e "s%\(.*\)%${HOME}/7/archived/\1/*/scratch-*.txt%"
  )
  ${HOME}/7/current/scratch-????-??.txt"
fi
