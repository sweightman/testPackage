#!/bin/bash

IFS=$'\n'

GIT_REPOS=($(grep -o '<a href.*\.git.*</a>' git.html | grep -v '>Git<' | grep -oP '(?<=(\?r\=)).*(?=" class)' | uniq))
GIT_REPOS_COUNT=${#GIT_REPOS[@]}

GIT_REPOS_LAST_UPDATED=($(grep -o '<span class="age.*</span>' git.html | grep -oP '(?<=(">)).*(?= ago</span>)'))

unset IFS

for (( i=0; i<$GIT_REPOS_COUNT; i++ )); do
  if [[ ! ${GIT_REPOS_LAST_UPDATED[$i]} =~ .*mins|hours|days|4.weeks.* ]]; then
    echo "> Git Repo: ${GIT_REPOS[$i]}"
    echo -e "  Last Updated: ${GIT_REPOS_LAST_UPDATED[$i]}\n"
  fi
done
