#!/usr/bin/env sh

fd --one-file-system --follow --type symlink --search-path "$1" -X rm -i
# fd --one-file-system --type empty --type directory --search-path "$1" -X rm -r -i
