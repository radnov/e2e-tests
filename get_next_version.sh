#!/bin/bash

VERSION=0;
current_branch="v33"
all_branches=$(git ls-remote --heads origin  | sed 's?.*refs/heads/??' )
tags=($(git ls-remote --tags origin | sed 's?.*refs/tags/??' ))
echo "$tags"

all_major_versions=$(echo "$all_branches" | tr ' ' '\n' | grep -o -E '^v.*' | grep -o -E '[0-9]+')

echo "$all_major_versions"
if [[ "$current_branch" == "master" ]]; then 
  last_major_version=$(echo "${all_major_versions[*]}" | sort -nr | head -n1 )
  next_major_version=$(($last_major_version + 1))
  next_major_version=$(echo $next_major_version | sed 's/^/2./')
  VERSION=$next_major_version
else 
  current_major_version=$(echo "${current_branch}" | sed 's/v//g')
  echo "current major $current_major_version"
  echo "${tags[*]}"
  test=$(echo "${tags[*]}" | tr ' ' '\n')
  echo "$test"
  patches=($(echo "${tags[*]}" |
     tr ' ' '\n' | 
     grep -o -E "^2.${current_major_version}.\\d" ))
  
  echo "matching patches $patches"
  last_patch=$(echo "${patches[*]}" | tr ' ' '\n' | sort -nr | head -n1 )
  echo "last patch $last_patch"
  next_patch=$(($(echo $last_patch | 
    sed "s/2.${current_major_version}.//") + 1))
    
  echo "next patch $next_patch"
  next_patch=$(echo $next_patch | sed "s/^/2.${current_major_version}./")
  echo "next patch $next_patch"
  VERSION=$next_patch
fi

echo "$VERSION"
