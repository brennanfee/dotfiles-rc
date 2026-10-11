#!/usr/bin/env sh

fd --one-file-system --hidden --type file --search-path "$1" '^\.DS_Store$' -X rm
fd --one-file-system --hidden --type file --search-path "$1" '^\.directory$' -X rm
